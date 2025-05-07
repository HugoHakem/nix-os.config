-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
config = wezterm.config_builder()

-- This is where you actually apply your config choices

config.font_size = 19
config.default_cursor_style = "SteadyBlock"
-- config.color_scheme = 'Batman'

-- tab bar
-- local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
-- bar.apply_to_config(config, {
-- 	modules = {
-- 		pane = {
-- 			enabled = false,
-- 		},
-- 		workspace = {
-- 			enabled = false,
-- 		},
-- 		cwd = {
-- 			enabled = false,
-- 		},
-- 	},
-- })

-- and finally, return the configuration to wezterm
return config