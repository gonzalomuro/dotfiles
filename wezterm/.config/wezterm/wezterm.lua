local wezterm = require 'wezterm'
local mux = wezterm.mux
local act = wezterm.action
local config = {}
local fish_paths = {
	'/usr/local/bin/fish',
	'/opt/homebrew/bin/fish'
}

wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  -- Todo - Resize to max and min
  -- window:gui_window():maximize()
end)

config.front_end = 'WebGpu'
config.color_scheme = 'Dracula'
config.font = wezterm.font_with_fallback {
	-- {
	-- 	family = 'Fira Code',
	-- 	weight = 'Light',
	-- 	harfbuzz_features = { 'calt=0', 'cling=0', 'liga=0', 'zero', 'ss01', 'ss05', 'ss04', 'ss03' }
	-- },
	{
		family = 'MesloLGS Nerd Font Mono',
    weight = 'Light'
	}
}
config.font_size = 16
config.line_height = 1.2
for _, path in ipairs(fish_paths) do
	local f = io.open(path, 'r')
	if f then
		f:close()
		config.default_prog = { path }
		break
	end
end
config.window_decorations = 'RESIZE'
config.use_dead_keys = false
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false
config.inactive_pane_hsb = {
	saturation = 0.9,
	brightness = 0.8
}

config.leader = { key = 'a', mods = 'CMD', timeout_milliseconds = 1000 }

config.keys = require 'keys'

return config
