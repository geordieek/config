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

-- Always prompt window close (tmux handles panes anyway)
config.window_close_confirmation = "AlwaysPrompt"

-- Hide title bar
config.window_decorations = "RESIZE"

local act = wezterm.action

-- This overrides the default so wezterm will ask for confirmation when closing tmux
config.skip_close_confirmation_for_processes_named = {
	"bash",
	"sh",
	"zsh",
	"fish",
	"nu",
	"cmd.exe",
	"pwsh.exe",
	"powershell.exe",
}

-- Set keybindings for pane navigation (uncommented as this is now handled with tmux)

-- Set leader key to CTRL-S
config.leader = { key = "s", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {
	-- Configure tmux-like keybindings
	-- Split pane vertically (like tmux's prefix + ") with leader + "
	{
		key = '"',
		mods = "LEADER",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	-- Split pane horizontally (like tmux's prefix + %) with leader + %
	{
		key = "%",
		mods = "LEADER",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	-- Close pane with leader + x (like tmux)
	{
		key = "x",
		mods = "LEADER",
		action = act.CloseCurrentPane({ confirm = true }),
	},
	-- Create new window with leader + c (like tmux)
	{
		key = "c",
		mods = "LEADER",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	-- Next window with leader + n (like tmux)
	{
		key = "n",
		mods = "LEADER",
		action = act.ActivateTabRelative(1),
	},
	-- Previous window with leader + p (like tmux)
	{
		key = "p",
		mods = "LEADER",
		action = act.ActivateTabRelative(-1),
	},
	-- Navigate to the pane above with CMD + k
	{
		key = "k",
		mods = "CMD",
		action = act.ActivatePaneDirection("Up"),
	},
	-- Navigate to the pane below with CMD + j
	{
		key = "j",
		mods = "CMD",
		action = act.ActivatePaneDirection("Down"),
	},
	-- Navigate to the pane to the right with CMD + l
	{
		key = "l",
		mods = "CMD",
		action = act.ActivatePaneDirection("Right"),
	},
	-- Navigate to the pane to the right with CMD + h
	{
		key = "h",
		mods = "CMD",
		action = act.ActivatePaneDirection("Left"),
	},
	-- Open new tab in home directory
	{
		key = "t",
		mods = "CMD",
		action = act.SpawnCommandInNewTab({
			cwd = wezterm.home_dir,
		}),
	},
}

-- and finally, return the configuration to wezterm
return config
