local wezterm = require 'wezterm'

return {
  -- Dracula color scheme
  color_scheme = "Dracula",
  
  -- Window transparency
  window_background_opacity = 0.9,
  text_background_opacity = 0.9,
  macos_window_background_blur = 15,
  
  -- Enable resize handles but customize window decorations
  -- Use "TITLE | RESIZE" to get proper resize handles while keeping control over buttons
  window_decorations = "TITLE | RESIZE",
  
  -- Customize the window frame to hide or minimize the green button visually
  window_frame = {
    -- Use Dracula colors for consistency
    active_titlebar_bg = '#282a36',
    inactive_titlebar_bg = '#282a36',
    
    -- Make button colors blend with titlebar
    button_fg = '#282a36',      -- Buttons nearly invisible
    button_bg = '#282a36',      -- Buttons blend with background
    button_hover_fg = '#ff79c6', -- Subtle color on hover
    button_hover_bg = '#282a36',
  },
  
  -- Completely hide the tab bar
  enable_tab_bar = false,
  hide_tab_bar_if_only_one_tab = true,
  
  -- Key bindings
  keys = {
    -- Fullscreen (Windows-style, not tab)
    {
      key = "f",
      mods = "CMD",
      action = wezterm.action.ToggleFullScreen,
    },
    
    -- Quit with Cmd+Q
    {
      key = "q",
      mods = "CMD",
      action = wezterm.action.QuitApplication,
    },
    
    -- Disable Cmd+Enter (fullscreen that creates tabs)
    {
      key = "Enter",
      mods = "CMD",
      action = wezterm.action.DisableDefaultAssignment,
    },
    
    -- Disable other problematic shortcuts
    {
      key = "m",
      mods = "CMD",
      action = wezterm.action.DisableDefaultAssignment,
    },
  },
  
  -- Keep most default key bindings but disable specific ones
  disable_default_key_bindings = false,
  
  -- Additional Dracula theme customization
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
    
    -- Customize tab bar colors to make it blend if it ever appears
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
  
  -- Window padding
  window_padding = {
    left = 5,
    right = 5,
    top = 5,
    bottom = 5,
  },
  
  -- Font settings for better appearance
  font = wezterm.font_with_fallback({
    "Fira Code",
    "JetBrains Mono", 
    "Menlo",
    "Monaco",
  }),
  font_size = 14.0,
  warn_about_missing_glyphs = false,
}