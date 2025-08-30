local wezterm = require 'wezterm'

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
      key = "f",
      mods = "CMD",
      action = wezterm.action.ToggleFullScreen,
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
