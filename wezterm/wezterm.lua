local wezterm = require "wezterm"
local config = wezterm.config_builder()
local action = wezterm.action

config.set_environment_variables = {
  PATH = '/opt/homebrew/bin:' .. os.getenv('PATH')
}

local function scheme_for_appearance(appearance)
  if appearance:find "Dark" then
    return "Catppuccin Macchiato"
  else
    return "Catppuccin Latte"
  end
end

config.font = wezterm.font {
  family = 'Fira Code',
  weight = 'Light',
  harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
}

config.font_size = 13.5
config.line_height = 1.0
config.bold_brightens_ansi_colors = true
config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())
config.window_decorations = 'RESIZE|INTEGRATED_BUTTONS'
config.window_padding = { left = '1cell', right = '1cell', top = '0.5cell', bottom = '0.5cell' }
config.window_background_opacity = 0.88
config.macos_window_background_blur = 16
config.default_cursor_style = 'SteadyBlock'

config.window_frame = {
  border_left_width = '2px',
  border_right_width = '2px',
  border_bottom_height = '2px',
  border_top_height = '1px',
  border_left_color = '151515',
  border_right_color = '151515',
  border_bottom_color = '151515',
  border_top_color = '151520',
}

-- https://github.com/wez/wezterm/issues/3299#issuecomment-2145712082
wezterm.on("gui-startup", function(cmd)
  local active = wezterm.gui.screens().active
	local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():set_position(active.x, active.y)
  window:gui_window():set_inner_size(active.width, active.height)
end)

config.keys = {
  { key = 'd', mods = 'CMD|SHIFT', action = action.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'd', mods = 'CMD', action = action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 'k', mods = 'CMD', action = action.ClearScrollback 'ScrollbackAndViewport' },
  { key = 'w', mods = 'CMD', action = action.CloseCurrentPane { confirm = false } },
  { key = 'w', mods = 'CMD|SHIFT', action = action.CloseCurrentTab { confirm = false } },
  -- { key = 'LeftArrow', mods = 'CMD', action = action.SendKey { key = 'Home' } },
  -- { key = 'RightArrow', mods = 'CMD', action = action.SendKey { key = 'End' } },
  { key = 'p', mods = 'CMD|SHIFT', action = action.ActivateCommandPalette },
  { key = ',', mods = 'CMD', action = action.SpawnCommandInNewTab { cwd = wezterm.home_dir, args = { 'zed', wezterm.config_file } } },
  {
    key = 'LeftArrow',
    mods = 'OPT',
    action = action.SendKey {
      key = 'b',
      mods = 'ALT',
    },
  },
  {
    key = 'RightArrow',
    mods = 'OPT',
    action = action.SendKey { key = 'f', mods = 'ALT' },
  },
}

mouse_bindings = {
    -- Disable the default click behavior
    {
      event = { Up = { streak = 1, button = "Left"} },
      mods = "NONE",
      action = wezterm.action.DisableDefaultAssignment,
    },

    -- Ctrl-click will open the link under the mouse cursor
    {
        event = { Up = { streak = 1, button = "Left" } },
        mods = "CTRL",
        action = wezterm.action.OpenLinkAtMouseCursor,
    },
    -- Disable the Ctrl-click down event to stop programs from seeing it when a URL is clicked
    {
        event = { Down = { streak = 1, button = "Left" } },
        mods = "CTRL",
        action = wezterm.action.Nop,
    }
}

return config
