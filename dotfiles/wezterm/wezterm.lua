local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Shell
config.default_prog = { "/run/current-system/sw/bin/fish", "-l" }

-- Font
-- config.font = wezterm.font("FiraCode Nerd Font")
config.font = wezterm.font("DankMono Nerd Font")
config.font = wezterm.font_with_fallback({
    "FiraCode Nerd Font",
})
config.font_size = 20
config.line_height = 1.2

-- Theme
config.color_scheme = "Night Owl (Gogh)"

-- Window
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.window_decorations = "RESIZE"
config.initial_cols = 220
config.initial_rows = 50

-- Tab bar
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

-- Scrollback
config.scrollback_lines = 10000

-- Keys
config.keys = {
    -- Split pane horizontal
    { key = "d", mods = "CMD",       action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    -- Split pane vertical
    { key = "d", mods = "CMD|SHIFT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
    -- Close pane
    { key = "w", mods = "CMD",       action = wezterm.action.CloseCurrentPane({ confirm = false }) },
    -- Navigate panes
    { key = "h", mods = "CMD|ALT",   action = wezterm.action.ActivatePaneDirection("Left") },
    { key = "l", mods = "CMD|ALT",   action = wezterm.action.ActivatePaneDirection("Right") },
    { key = "k", mods = "CMD|ALT",   action = wezterm.action.ActivatePaneDirection("Up") },
    { key = "j", mods = "CMD|ALT",   action = wezterm.action.ActivatePaneDirection("Down") },
}

-- Miscellaneous
config.max_fps = 120
config.prefer_egl = true

return config
