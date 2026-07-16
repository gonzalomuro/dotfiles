local wezterm = require 'wezterm'
local act = wezterm.action

local keys = {
{ key = 'Enter', mods = 'SHIFT|CMD', action = act.ToggleFullScreen },
{ key = 'C', mods = 'CMD', action = act.CopyTo 'Clipboard' },
{ key = 'F', mods = 'SHIFT|CMD', action = act.Search 'CurrentSelectionOrEmptyString' },

-- Leader bindings
{ key = 'd', mods = 'LEADER', action = act.ShowDebugOverlay },
{ key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },
{ key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
{ key = 'v', mods = 'LEADER', action = act.SplitHorizontal{ domain =  'CurrentPaneDomain' } },

{ key = 'N', mods = 'SHIFT|CMD', action = act.SpawnWindow },
{ key = 'P', mods = 'SHIFT|CMD', action = act.ActivateCommandPalette },
{ key = 'V', mods = 'SHIFT|CMD', action = act.PasteFrom 'Clipboard' },
{ key = 'X', mods = 'SHIFT|CMD', action = act.ActivateCopyMode },
{ key = 'phys:Space', mods = 'SHIFT|CMD', action = act.QuickSelect },
{ key = 's', mods = 'CMD', action = act.SendString ':w\n', },
{ key = 'o', mods = 'CMD', action = act.SendKey { key = 'o', mods = 'CTRL' }, },
{ key = 'i', mods = 'CMD', action = act.SendKey { key = 'i', mods = 'CTRL' }, },
{ key = 'd', mods = 'CMD', action = act.SendKey { key = 'd', mods = 'CTRL' }, },
{ key = 'u', mods = 'CMD', action = act.SendKey { key = 'u', mods = 'CTRL' }, },
{ key = 'y', mods = 'CMD', action = act.SendKey { key = 'y', mods = 'CTRL' }, },
{ key = 'e', mods = 'CMD', action = act.SendKey { key = 'e', mods = 'CTRL' }, },
	{
    key = 'C',
    mods = 'CMD|SHIFT',
    action = wezterm.action_callback(function(window, pane)
      local sel = window:get_selection_text_for_pane(pane)
      sel = sel:gsub('([^\n])\n([^\n])', '%1 %2')
      sel = sel:gsub(' +', ' ')
      window:copy_to_clipboard(sel)
    end),
  }
}

return keys
