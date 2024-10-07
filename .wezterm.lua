local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local act = wezterm.action

config:set_strict_mode(true)

config.color_scheme = 'Afterglow'
config.font = wezterm.font 'Hack'
config.audible_bell = 'Disabled'

config.disable_default_key_bindings = true
config.leader = {key = 'a', mods = 'CTRL', timeout_milliseconds = 2000}
config.keys = {
	-- Copy/Paste
	{key = 'c', mods = 'CTRL|SHIFT', action = act.CopyTo 'Clipboard'},
	{key = 'v', mods = 'CTRL|SHIFT', action = act.PasteFrom 'Clipboard'},
	-- Debug Overlay,
	{key = 'l', mods = 'CTRL|SHIFT', action = act.ShowDebugOverlay},
	-- Tmux-like keybindings for tab/pane control
	{key = 'x', mods = 'LEADER', action = act.CloseCurrentPane{confirm = false}},
	{key = 'c', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain'},
	{key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(1)},
	{key = 'p', mods = 'LEADER', action = act.ActivateTabRelative(-1)},
	{key = 'h', mods = 'LEADER', action = act.SplitHorizontal{domain = 'CurrentPaneDomain'}},
	{key = 'v', mods = 'LEADER', action = act.SplitVertical{domain = 'CurrentPaneDomain'}},
	{key = 'x', mods = 'LEADER', action = act.CloseCurrentPane{confirm = false}},
	{key = 'LeftArrow', mods = 'LEADER', action = act.ActivatePaneDirection 'Left'},
	{key = 'RightArrow', mods = 'LEADER', action = act.ActivatePaneDirection 'Right'},
	{key = 'UpArrow', mods = 'LEADER', action = act.ActivatePaneDirection 'Up'},
	{key = 'DownArrow', mods = 'LEADER', action = act.ActivatePaneDirection 'Down'},
	{key = 'o', mods = 'LEADER', action = act.ActivatePaneDirection 'Next'},
    {key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },
    -- Launch new Domains
    {key = 'l', mods = 'LEADER', action = act.ShowLauncherArgs{flags = 'FUZZY|DOMAINS|LAUNCH_MENU_ITEMS'} },
}

local function make_shell_domain(name, shell_args, args_func)
    return wezterm.exec_domain(name, function(cmd)
		if args_func then
		  args_table = {args_func(cmd)}
		  for _, arg in ipairs(args_table) do
		    table.insert(shell_args, arg)
          end		  
		end
		
		if cmd.args then
          for _, arg in ipairs(cmd.args) do
            table.insert(shell_args, arg)
          end
        end
		
		cmd.args = shell_args
		
        wezterm.log_info(cmd)
        return cmd
    end)
end

-- Remove unneeded builtin domains
config.wsl_domains = {}
config.unix_domains = {}

local launch_menu = {}

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  config.exec_domains = {
    make_shell_domain('Powershell', {'powershell.exe', '-NoLogo'}),
    make_shell_domain('WSL',
	 {'wsl.exe'},
	 function (cmd)
	   if cmd.cwd then
	     return '--cd', cmd.cwd
	   end
	 end
	), 
    make_shell_domain('MSYS2',
        {'C:/msys64/msys2_shell.cmd',
        '-defterm',
        '-no-start',
        '-mingw64'},
		function (cmd)
		  if cmd.cwd then
		    -- cwd is a posix path reported via OSC7 by the current MSYS Pane, but for invoking
			-- a new instance we require a Windows Path. So we prepend the Msys install dir
		    return '-where', 'C:/msys64' .. cmd.cwd
		  end
		end
		)
  }
  
  -- Find installed visual studio version(s) and add their compilation
  -- environment command prompts to the menu
  for _, vsvers in
    ipairs(
      wezterm.glob('Microsoft Visual Studio/20*/*', 'C:/Program Files')
    )
  do
    local year = vsvers:gsub('Microsoft Visual Studio/', '')
    table.insert(launch_menu, {
      label = 'x64 VS ' .. year,
      args = {
        'cmd.exe',
        '/k',
        'C:/Program Files/'
          .. vsvers
          .. '/VC/Auxiliary/Build/vcvars64.bat',
      },
    })
  end
end

config.launch_menu = launch_menu

config.exit_behavior = 'Hold'

return config

