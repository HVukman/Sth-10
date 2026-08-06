package sth10

import rl "vendor:raylib"
import lua "vendor:lua/5.4"
import "core:fmt"
import "base:runtime"


l_window_should_close :: proc "c" (L: ^lua.State) -> i32
{

	lua.pushboolean(L, b32(rl.WindowShouldClose()))
	return 1
}

l_is_window_fullscreen :: proc "c" (L: ^lua.State) -> i32
{

	lua.pushboolean(L, b32(rl.IsWindowFullscreen()))
	return 1
}

l_is_window_focused :: proc "c" (L: ^lua.State) -> i32
{

	lua.pushboolean(L, b32(rl.IsWindowFocused()))
	return 1
}

l_is_window_resized :: proc "c" (L: ^lua.State) -> i32
{

	lua.pushboolean(L, b32(rl.IsWindowResized()))
	return 1
}

l_toggle_fullscreen :: proc "c" (L: ^lua.State) -> i32
{

	rl.ToggleFullscreen()
	return 0
}

l_toggle_borderless:: proc "c" (L: ^lua.State) -> i32
{

	rl.ToggleBorderlessWindowed()
	return 0
}

l_maximize_window:: proc "c" (L: ^lua.State) -> i32
{

	rl.MaximizeWindow()
	return 0
}

l_minimize_window :: proc "c" (L: ^lua.State) -> i32
{

	rl.MinimizeWindow()
	return 0
}

l_restore_window :: proc "c" (L: ^lua.State) -> i32
{

	rl.RestoreWindow()
	return 0
}

l_set_window_widthheight :: proc "c" (L: ^lua.State) -> i32
{

	width := lua.L_checknumber(L,1)
	height := lua.L_checknumber(L,2)

	rl.SetWindowSize( i32(width) , i32(height))
	return 0
}


l_set_window_position :: proc "c" (L: ^lua.State) -> i32
{

	x := lua.L_checknumber(L,1)
	y := lua.L_checknumber(L,2)

	rl.SetWindowPosition( i32(x) , i32(y))
	return 0
}


l_set_window_minsize :: proc "c" (L: ^lua.State) -> i32
{

	x := lua.L_checknumber(L,1)
	y := lua.L_checknumber(L,2)

	rl.SetWindowMinSize( i32(x) , i32(y))
	return 0
}

l_set_window_maxsize :: proc "c" (L: ^lua.State) -> i32
{

	x := lua.L_checknumber(L,1)
	y := lua.L_checknumber(L,2)

	rl.SetWindowMinSize( i32(x) , i32(y))
	return 0
}

// only one monitor?
 l_get_current_monitor :: proc "c" (L: ^lua.State) -> i32
{

	lua.pushinteger(L,lua.Integer(rl.GetCurrentMonitor()))
	return 1
}


l_get_monitor_widthheight :: proc "c" (L: ^lua.State) -> i32
{

	monitor := lua.L_checknumber(L,1)

	width := rl.GetMonitorWidth(i32(monitor))
	lua.pushinteger(L,lua.Integer(width))
	height := rl.GetMonitorHeight(i32(monitor))
	lua.pushinteger(L,lua.Integer(height))
	return 2
}

l_get_window_widthheight :: proc "c" (L: ^lua.State) -> i32
{

	width := rl.GetScreenWidth()
	lua.pushinteger(L,lua.Integer(width))
	height := rl.GetScreenHeight()
	lua.pushinteger(L,lua.Integer(height))
	return 2
}

l_window_title :: proc "c" (L: ^lua.State) -> i32
{
	title := lua.L_checkstring(L,-1)
	rl.SetWindowTitle(title)
	return 0
}

l_get_fps :: proc "c" (L: ^lua.State) -> i32
{
	lua.pushinteger(L, lua.Integer(rl.GetFPS()))
	return 1
}

window_meta := []lua.L_Reg{
//	{"point", l_draw_point},
    {nil, nil},
}

windowlib := []lua.L_Reg{
	{"title", l_window_title},
	{"get_fps" ,l_get_fps},
	{"get_width_height" ,l_get_window_widthheight},
	{"set_width_height" ,l_set_window_widthheight},
	{"set_maxsize" ,l_set_window_maxsize },
	{"set_minsize" ,l_set_window_minsize },
	{"set_window_position" ,l_set_window_position },
	{"maximize_window", l_maximize_window},
	{"minimize_window", l_minimize_window},
	{"restore_window", l_restore_window},
	{"toggle_borderless", l_toggle_borderless},
	{"toggle_fullscreen", l_toggle_fullscreen},
	{"is_resized", l_is_window_resized},
	{"is_fullscreen", l_is_window_fullscreen},
	{"is_focused", l_is_window_focused},
	{"should_close", l_window_should_close},
	{"get_monitor_width_height",l_get_monitor_widthheight },
	{"get_current_monitor",l_get_current_monitor },
    {nil, nil},
}


lua_openwindow :: proc "c" (L: ^lua.State) -> i32  {

	context = runtime.default_context()

	lua.L_setfuncs(L, raw_data(window_meta), 0)
	lua.L_newlib(L,windowlib)
	return 1
}
