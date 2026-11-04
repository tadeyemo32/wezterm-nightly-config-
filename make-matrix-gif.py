#!/usr/bin/env python3
"""Generate the seamlessly-looping matrix-rain GIF used by the 'Matrix' theme.

Regenerate with:  python3 ~/.config/wezterm/make-matrix-gif.py

The loop is exact: every column's head advances a whole number of cells per
frame and the glyph grid only flickers on a period that divides FRAMES, so the
last frame lines up with the first and the animation never jumps.
"""
import random, os
from PIL import Image, ImageDraw, ImageFont

W, H = 1280, 800
CELL_W, CELL_H = 16, 20
COLS, ROWS = W // CELL_W, H // CELL_H   # 80 x 40
FRAMES = 40                              # ROWS % FRAMES-compatible (speeds 1 and 2)
FLICKER_PERIOD = 8                       # divides FRAMES, so the flicker loops too
DELAY_MS = 60
OUT = os.path.expanduser("~/.config/wezterm/matrix-rain.gif")

FONT_CANDIDATES = [
    os.path.expanduser("~/Library/Fonts/FiraCode-Regular.ttf"),
    "/System/Library/Fonts/Menlo.ttc",
    "/System/Library/Fonts/Monaco.ttf",
]
font = None
for path in FONT_CANDIDATES:
    if os.path.exists(path):
        try:
            font = ImageFont.truetype(path, 16)
            break
        except Exception:
            continue
if font is None:
    font = ImageFont.load_default()

random.seed(1903)   # deterministic: same GIF every regeneration

# ASCII only. Katakana would be more film-accurate but Fira Code has no glyphs
# for them, so they rendered as tofu boxes.
#
# Three kinds of column, so the rain reads as a machine at work rather than a
# digit shuffler: real code fragments, binary runs, and operator/hex soup.
CODE_SNIPPETS = [
    "if (err != nil) { return nil, err }",
    "for i := 0; i < len(buf); i++ {",
    "const hash = sha256(payload ^ nonce);",
    "sudo chmod 0600 ~/.ssh/id_ed25519",
    "SELECT * FROM sessions WHERE uid = ?;",
    "0x7ffee3b4c0 <- mmap(NULL, 4096, PROT_EXEC)",
    "curl -sL https://api/v2/token | jq .jwt",
    "while true: pkt = sock.recv(1500)",
    "import hashlib, socket, struct, sys",
    "ssh -i key -o StrictHostKeyChecking=no",
    "pub fn decrypt(&self, iv: [u8; 16])",
    "grep -rniE 'passwd|secret' /var/log",
    "assert(ptr != NULL && len > 0);",
    "docker run --rm -it --net=host alpine",
    "git rebase -i HEAD~3 --autosquash",
    "panic: runtime error: index out of range",
    "openssl enc -aes-256-cbc -salt -in f",
    "kill -9 $(lsof -ti tcp:8080)",
    "xor eax, eax; mov ebx, 0x1; int 0x80",
    "try { await flush(); } catch (e) {}",
    "func main() { defer wg.Wait() }",
    "nmap -sS -p- -T4 10.0.0.0/24",
    "let mut stream = TcpStream::connect(a)?;",
    "#define MAX_FRAME_LEN 0xFFFF",
    "ptrace(PTRACE_ATTACH, pid, NULL, NULL);",
    "return subtle.digest('SHA-512', block)",
    "chmod +x payload && ./payload --quiet",
    "10.0.0.1:443 ESTABLISHED (tls1.3)",
    "memcpy(dst, src + off, n & 0xFF);",
    "export AWS_SECRET_ACCESS_KEY=****",
    "rustc -C opt-level=3 --emit=obj main.rs",
    "[WARN] handshake retry 3/5 backoff=800ms",
]

BINARY = "01"
SYMBOLS = "{}[]()<>/\\|!@#$%^&*-+=_~;:.,?"
HEX = "0123456789abcdefABCDEF"

# Column kinds and how often they appear. Code is the loudest signal, so it
# stays a minority -- too many and the screen turns into a wall of text.
KINDS = ["code"] * 3 + ["binary"] * 3 + ["symbol"] * 2 + ["hex"] * 2


def column_cells(kind):
    """One column's worth of glyphs, top to bottom."""
    if kind == "code":
        # Chain whole snippets separated by a space so the seam between two
        # fragments still looks like a line break rather than a collision.
        text = ""
        while len(text) < ROWS:
            text += random.choice(CODE_SNIPPETS) + "  "
        return list(text[:ROWS])
    pool = {"binary": BINARY, "symbol": SYMBOLS, "hex": HEX}[kind]
    return [random.choice(pool) for _ in range(ROWS)]


kinds = [random.choice(KINDS) for _ in range(COLS)]

# glyph[flicker][col][row] -- fixed per flicker phase so the loop is seamless
glyphs = [[column_cells(kinds[c]) for c in range(COLS)]
          for _ in range(FLICKER_PERIOD)]
for phase in range(1, FLICKER_PERIOD):
    for c in range(COLS):
        # Code columns hold still: a fragment that mutates mid-fall stops
        # looking like code. The noise columns churn a few cells per phase.
        churn = 0.0 if kinds[c] == "code" else 0.06
        for r in range(ROWS):
            if random.random() > churn:
                glyphs[phase][c][r] = glyphs[0][c][r]

streams = []
for c in range(COLS):
    streams.append({
        "speed": random.choice([1, 1, 1, 2]),      # cells per frame
        "start": random.randrange(ROWS),
        # Code columns run long tails so a readable run of the fragment is lit
        # at once; noise columns stay short and sparky.
        "tail": random.randint(18, 34) if kinds[c] == "code"
                else random.randint(6, 22),
        "dim": random.uniform(0.7, 1.0) if kinds[c] == "code"
               else random.uniform(0.45, 0.9),
    })

HEAD = (200, 255, 200)
BODY = (0, 255, 70)

def shade(depth, tail, dim, code):
    """Brightness falloff from the head down the tail.

    Noise tails drop off fast so they read as sparks. Code tails fall off
    gently and never go below a floor, so a whole fragment stays readable at
    once instead of trailing into nothing after four characters.
    """
    if depth == 0:
        return tuple(int(v * dim) for v in HEAD)
    if code:
        f = max(0.42, (1.0 - depth / tail) ** 0.75)
    else:
        f = (1.0 - depth / tail) ** 1.7
    return tuple(int(v * f * dim) for v in BODY)

frames = []
for f in range(FRAMES):
    img = Image.new("RGB", (W, H), (0, 0, 0))
    d = ImageDraw.Draw(img)
    grid = glyphs[f % FLICKER_PERIOD]
    for c, s in enumerate(streams):
        head = (s["start"] + f * s["speed"]) % ROWS
        for depth in range(s["tail"]):
            r = (head - depth) % ROWS
            colour = shade(depth, s["tail"], s["dim"], kinds[c] == "code")
            if max(colour) < 8:
                continue
            d.text((c * CELL_W, r * CELL_H), grid[c][r], font=font, fill=colour)
    frames.append(img.quantize(colors=64, method=Image.MEDIANCUT))

frames[0].save(
    OUT, save_all=True, append_images=frames[1:],
    duration=DELAY_MS, loop=0, optimize=True, disposal=2,
)
kind_counts = {k: kinds.count(k) for k in sorted(set(kinds))}
print(f"wrote {OUT}  ({os.path.getsize(OUT)/1024:.0f} KB, {FRAMES} frames, "
      f"{COLS}x{ROWS} cells, columns {kind_counts})")
