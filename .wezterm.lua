-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- Tab configuration
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

-- Set colour scheme
config.color_scheme = "Catppuccin Mocha"

-- Use powerlevel10k recommended font
config.font = wezterm.font("MesloLGS NF")

local act = wezterm.action

-- Set keybindings
config.keys = {
	-- Split the pane horizontally with CMD + SHIFT + J
	{
		key = "J",
		mods = "CMD|SHIFT",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	-- Close the current pane with CMD + SHIFT + K
	{
		key = "K",
		mods = "CMD|SHIFT",
		action = act.CloseCurrentPane({ confirm = false }),
	},
	-- Navigate to the pane below with CMD + J
	{
		key = "j",
		mods = "CMD",
		action = act.ActivatePaneDirection("Down"),
	},
	-- Navigate to the pane above with CMD + K
	{
		key = "k",
		mods = "CMD",
		action = act.ActivatePaneDirection("Up"),
	},
}

-- and finally, return the configuration to wezterm
return config
