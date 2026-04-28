local wezterm = require 'wezterm'

local config = wezterm.config_builder()

local palette = {
  rosewater = '#f5e0dc',
  flamingo = '#f2cdcd',
  pink = '#f5c2e7',
  mauve = '#cba6f7',
  red = '#f38ba8',
  maroon = '#eba0ac',
  peach = '#fab387',
  yellow = '#f9e2af',
  green = '#a6e3a1',
  teal = '#94e2d5',
  sky = '#89dceb',
  sapphire = '#74c7ec',
  blue = '#89b4fa',
  lavender = '#b4befe',
  text = '#cdd6f4',
  subtext1 = '#bac2de',
  subtext0 = '#a6adc8',
  overlay2 = '#9399b2',
  overlay1 = '#7f849c',
  overlay0 = '#6c7086',
  surface2 = '#585b70',
  surface1 = '#45475a',
  surface0 = '#313244',
  base = '#1e1e2e',
  mantle = '#181825',
  crust = '#11111b',
}

local function basename(path)
  if not path or path == '' then
    return ''
  end

  return path:gsub('(.*[/\\])(.*)', '%2')
end

local function tab_title(tab_info)
  local pane = tab_info.active_pane
  local title = basename(pane.foreground_process_name)

  if title == '' then
    title = basename(pane.current_working_dir and pane.current_working_dir.file_path or '')
  end

  if title == '' then
    title = 'shell'
  end

  return string.format(' %s ', title)
end

wezterm.on('format-tab-title', function(tab)
  local is_active = tab.is_active

  return {
    {
      Background = {
        Color = is_active and palette.surface0 or palette.mantle,
      },
    },
    {
      Foreground = {
        Color = is_active and palette.text or palette.overlay1,
      },
    },
    {
      Text = tab_title(tab),
    },
  }
end)

wezterm.on('update-status', function(window, pane)
  local cwd_uri = pane.current_working_dir
  local cwd = cwd_uri and basename(cwd_uri.file_path) or '~'
  local process = basename(pane.foreground_process_name)
  local cells = {}

  if cwd ~= '' then
    table.insert(cells, cwd)
  end

  if process ~= '' and process ~= cwd then
    table.insert(cells, process)
  end

  window:set_right_status(wezterm.format({
    { Foreground = { Color = palette.overlay1 } },
    { Text = table.concat(cells, '  ') },
  }))
end)

config.font = wezterm.font_with_fallback({
  'JetBrains Mono',
  'Symbols Nerd Font Mono',
})
config.font_size = 16.0
config.line_height = 1.15
config.cell_width = 1.0

config.colors = {
  foreground = palette.text,
  background = palette.crust,
  cursor_bg = palette.rosewater,
  cursor_fg = palette.base,
  cursor_border = palette.rosewater,
  selection_fg = palette.text,
  selection_bg = palette.overlay0,
  scrollbar_thumb = palette.surface2,
  split = palette.surface1,
  compose_cursor = palette.flamingo,
  ansi = {
    palette.surface1,
    palette.red,
    palette.green,
    palette.yellow,
    palette.blue,
    palette.mauve,
    palette.sky,
    palette.subtext1,
  },
  brights = {
    palette.surface2,
    palette.red,
    palette.green,
    palette.yellow,
    palette.blue,
    palette.mauve,
    palette.sky,
    palette.text,
  },
  tab_bar = {
    background = palette.crust,
    inactive_tab_edge = palette.crust,
    active_tab = {
      bg_color = palette.surface0,
      fg_color = palette.text,
    },
    inactive_tab = {
      bg_color = palette.mantle,
      fg_color = palette.overlay1,
    },
    inactive_tab_hover = {
      bg_color = palette.surface0,
      fg_color = palette.subtext1,
    },
    new_tab = {
      bg_color = palette.crust,
      fg_color = palette.overlay1,
    },
    new_tab_hover = {
      bg_color = palette.surface0,
      fg_color = palette.text,
    },
  },
}

config.default_cursor_style = 'SteadyBlock'
config.animation_fps = 60

config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false
config.show_tab_index_in_tab_bar = false
config.tab_max_width = 24
config.switch_to_last_active_tab_when_closing_tab = true
config.show_new_tab_button_in_tab_bar = false

config.window_decorations = 'RESIZE'
config.window_padding = {
  left = 10,
  right = 10,
  top = 8,
  bottom = 6,
}
config.window_background_opacity = 1.0
config.macos_window_background_blur = 18

config.adjust_window_size_when_changing_font_size = false
config.native_macos_fullscreen_mode = false

config.enable_scroll_bar = true
config.scrollback_lines = 10000

config.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.75,
}

config.audible_bell = 'Disabled'
config.visual_bell = {
  fade_in_function = 'EaseIn',
  fade_in_duration_ms = 100,
  fade_out_function = 'EaseOut',
  fade_out_duration_ms = 120,
}

config.mouse_bindings = {
  {
    event = { Down = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = wezterm.action.PasteFrom 'Clipboard',
  },
}

config.keys = {
  {
    key = 'd',
    mods = 'CMD',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'D',
    mods = 'CMD|SHIFT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'w',
    mods = 'CMD',
    action = wezterm.action.CloseCurrentTab { confirm = true },
  },
  {
    key = 't',
    mods = 'CMD',
    action = wezterm.action.SpawnTab 'CurrentPaneDomain',
  },
  {
    key = '[',
    mods = 'CMD|SHIFT',
    action = wezterm.action.ActivateTabRelative(-1),
  },
  {
    key = ']',
    mods = 'CMD|SHIFT',
    action = wezterm.action.ActivateTabRelative(1),
  },
}

return config
