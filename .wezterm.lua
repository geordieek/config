-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- Set colour scheme
config.color_scheme = "Tokyo Night Moon"

-- Use powerlevel10k recommended font
config.font = wezterm.font("MesloLGS NF")

-- and finally, return the configuration to wezterm
return config
