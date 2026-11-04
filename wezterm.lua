local wezterm = require 'wezterm'

-- CMD+SHIFT+R: cycle through every theme.
-- Entry 1 is the base Dracula look defined at the bottom of this file;
-- 'Plain B&W' is the opaque black/white look for screen sharing;
-- 'Matrix' is black + green over the falling-digits animation.
local THEMES = {
  'Dracula',
  'Matrix',
  'Tokyo Night',
  'Catppuccin Mocha',
  'Kanagawa (Gogh)',
  'rose-pine',
  'nord',
  'GruvboxDark',
  'Snazzy',
  'Plain B&W',
}

local MATRIX_GIF = wezterm.config_dir .. '/matrix-rain.gif'

-- Mostly green on black. Red survives as red on purpose: an unreadable error
-- is a worse trade than a slightly impure Matrix.
local MATRIX_COLORS = {
  background = '#000000',
  foreground = '#00e64d',
  cursor_bg = '#a9ffb0',
  cursor_border = '#a9ffb0',
  cursor_fg = '#000000',
  selection_fg = '#000000',
  selection_bg = '#00ff62',
  ansi = {
    '#0a1f0a', '#ff5f5f', '#00d942', '#7dff8a',
    '#009a34', '#00ff62', '#2fe08a', '#a6ffb2',
  },
  brights = {
    '#1f4d2a', '#ff8787', '#3bff6e', '#c7ffcd',
    '#00c94f', '#78ff9e', '#6effc0', '#e8ffec',
  },
}

wezterm.on('cycle-theme', function(window, _)
  local idx = ((wezterm.GLOBAL.theme_idx or 1) % #THEMES) + 1
  wezterm.GLOBAL.theme_idx = idx
  local name = THEMES[idx]
  local overrides = {}
  if name == 'Plain B&W' then
    overrides = {
      colors = {
        background = '#000000',
        foreground = '#ffffff',
        cursor_bg = '#ffffff',
        cursor_border = '#ffffff',
      },
      window_background_opacity = 1.0,
      text_background_opacity = 1.0,
      macos_window_background_blur = 0,
    }
  elseif name == 'Matrix' then
    -- `background` is a stack of layers, back to front, and it REPLACES the
    -- default background-colour layer -- hence the explicit black one under
    -- the gif. brightness keeps the rain behind the text rather than in it.
    overrides = {
      colors = MATRIX_COLORS,
      window_background_opacity = 1.0,
      text_background_opacity = 1.0,
      macos_window_background_blur = 0,
      animation_fps = 20,
      background = {
        {
          source = { Color = '#000000' },
          width = '100%',
          height = '100%',
          opacity = 1.0,
        },
        {
          source = { File = { path = MATRIX_GIF, speed = 0.7 } },
          width = '100%',
          height = '100%',
          opacity = 1.0,
          hsb = { brightness = 0.18, hue = 1.0, saturation = 1.0 },
        },
      },
    }
  elseif name ~= 'Dracula' then
    -- the base config pins `colors` (which beats color_scheme), so cycling
    -- overrides `colors` with the builtin palette itself
    overrides = { colors = wezterm.color.get_builtin_schemes()[name] }
  end
  window:set_config_overrides(overrides)
  window:toast_notification('wezterm', 'Theme: ' .. name, nil, 1500)
end)

return {
  color_scheme = "Dracula",
  window_background_opacity = 0.9,
  text_background_opacity = 0.9,
  macos_window_background_blur = 15,
  window_decorations = "TITLE | RESIZE",
  window_frame = {
    active_titlebar_bg = '#282a36',
    inactive_titlebar_bg = '#282a36',
    button_fg = '#282a36',
    button_bg = '#282a36',
    button_hover_fg = '#ff79c6',
    button_hover_bg = '#282a36',
  },
  enable_tab_bar = false,
  hide_tab_bar_if_only_one_tab = true,
  keys = {
    {
      key = "r",
      mods = "CMD|SHIFT",
      action = wezterm.action.EmitEvent 'cycle-theme',
    },
    {
      key = "f",
      mods = "CMD",
      action = wezterm.action.ToggleFullScreen,
    },
    {
      key = "d",
      mods = "CMD",
      action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" },
    },
    {
      key = "e",
      mods = "CMD",
      action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" },
    },
    {
      key = "q",
      mods = "CMD",
      action = wezterm.action.QuitApplication,
    },
    {
      key = "Enter",
      mods = "CMD",
      action = wezterm.action.DisableDefaultAssignment,
    },
    {
      key = "m",
      mods = "CMD",
      action = wezterm.action.DisableDefaultAssignment,
    },
  },
  disable_default_key_bindings = false,
  font = wezterm.font_with_fallback({
    "Fira Code",
    "Monaco",
    "Menlo",
    "JetBrains Mono",
    "Source Code Pro",
    "Consolas",
  }),
  font_size = 14.0,
  warn_about_missing_glyphs = false,
  colors = {
    background = "#282a36",
    foreground = "#f8f8f2",
    cursor_bg = "#f8f8f2",
    cursor_border = "#f8f8f2",
    selection_fg = "#000000",
    selection_bg = "#fffacd",
    ansi = {
      "#000000", "#ff5555", "#50fa7b", "#f1fa8c", 
      "#bd93f9", "#ff79c6", "#8be9fd", "#bbbbbb"
    },
    brights = {
      "#555555", "#ff5555", "#50fa7b", "#f1fa8c", 
      "#bd93f9", "#ff79c6", "#8be9fd", "#ffffff"
    },
    tab_bar = {
      background = "#282a36",
      active_tab = {
        bg_color = "#bd93f9",
        fg_color = "#282a36",
      },
      inactive_tab = {
        bg_color = "#282a36",
        fg_color = "#6272a4",
      },
      inactive_tab_hover = {
        bg_color = "#44475a",
        fg_color = "#f8f8f2",
      },
      new_tab = {
        bg_color = "#282a36",
        fg_color = "#6272a4",
      },
      new_tab_hover = {
        bg_color = "#bd93f9",
        fg_color = "#282a36",
      },
    },
  },
  window_padding = {
    left = 5,
    right = 5,
    top = 5,
    bottom = 5,
  },
}
