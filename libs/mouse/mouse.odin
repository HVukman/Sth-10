package mouse


import "core:fmt"
import lua "vendor:lua/5.4"
import "core:c/libc"
import "base:runtime"
import rl "vendor:raylib"
import "core:strings"
import "core:os"

MouseEnum :: enum {
	Left = int(rl.MouseButton.LEFT),
	Right =  int(rl.MouseButton.RIGHT),
	Middle =  int(rl.MouseButton.MIDDLE),
	Side =  int(rl.MouseButton.SIDE),
	Extra =  int(rl.MouseButton.EXTRA),
}

lua_iscursor_onscreen :: proc "c" (L: ^lua.State) -> i32 {

	lua.pushboolean(L, b32(rl.IsCursorOnScreen()))
	return 1
}

lua_iscursor_hidden :: proc "c" (L: ^lua.State) -> i32 {

	lua.pushboolean(L, b32(rl.IsCursorHidden()))
	return 1
}

lua_disable_cursor :: proc "c" (L: ^lua.State) -> i32 {

	rl.DisableCursor()
	return 0
}

lua_enable_cursor :: proc "c" (L: ^lua.State) -> i32 {

	rl.EnableCursor()
	return 0
}


lua_hide_cursor :: proc "c" (L: ^lua.State) -> i32 {

	rl.HideCursor()
	return 0
}


lua_show_cursor :: proc "c" (L: ^lua.State) -> i32 {

	rl.ShowCursor()
	return 0
}


lua_get_mousewheel_move:: proc "c" (L: ^lua.State) -> i32 {


	lua.pushnumber(L, lua.Number(rl.GetMouseWheelMove()))

	return 1
}


lua_get_mousebutton_y :: proc "c" (L: ^lua.State) -> i32 {

	lua.pushinteger(L, lua.Integer(rl.GetMouseY()))

	return 1
}

lua_get_mousebutton_x :: proc "c" (L: ^lua.State) -> i32 {

	lua.pushinteger(L, lua.Integer(rl.GetMouseX()))

	return 1
}


lua_is_mousebutton_released :: proc "c" (L: ^lua.State) -> i32 {

	key := lua.L_checkinteger(L, 1)
	is_pressed := rl.IsMouseButtonReleased(rl.MouseButton(key))
	lua.pushboolean(L, b32(is_pressed))

	return 1
}

lua_is_mousebutton_up :: proc "c" (L: ^lua.State) -> i32 {

	key := lua.L_checkinteger(L, 1)
	is_pressed := rl.IsMouseButtonUp(rl.MouseButton(key))
	lua.pushboolean(L, b32(is_pressed))

	return 1
}

lua_is_mousebutton_down :: proc "c" (L: ^lua.State) -> i32 {

	key := lua.L_checkinteger(L, 1)
	is_pressed := rl.IsMouseButtonDown(rl.MouseButton(key))
	lua.pushboolean(L, b32(is_pressed))

	return 1
}

lua_is_mousebutton_pressed :: proc "c" (L: ^lua.State) -> i32 {

	key := lua.L_checkinteger(L, 1)
	is_pressed := rl.IsMouseButtonPressed(rl.MouseButton(key))
	lua.pushboolean(L, b32(is_pressed))

	return 1
}


lua_mouselib := []lua.L_Reg{
	{"is_mouse_button_pressed", lua_is_mousebutton_pressed},
	{"is_mouse_button_down", lua_is_mousebutton_down},
	{"is_mouse_button_released", lua_is_mousebutton_released},
	{"is_mouse_button_up", lua_is_mousebutton_up},
	{"get_mouse_x",lua_get_mousebutton_x},
	{"get_mouse_y",lua_get_mousebutton_y},
	{"get_mousewheel_move",lua_get_mousewheel_move},
	{"show_cursor", lua_show_cursor},
	{"hide_cursor", lua_hide_cursor},
	{"enable_cursor", lua_enable_cursor},
	{"disable_cursor", lua_disable_cursor},
	{"is_cursor_hidden", lua_iscursor_hidden} ,
	{"is_cursor_onscreen", lua_iscursor_onscreen} ,
    {nil, nil},
}

luamouse_open :: proc "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()


    lua.L_newlib(L, lua_mouselib)
   	// Add enum constants as integers
	lua.pushinteger(L, lua.Integer(MouseEnum.Left))
	lua.setfield(L, -2, "Left")

	lua.pushinteger(L, lua.Integer(MouseEnum.Right))
	lua.setfield(L, -2, "Right")

	lua.pushinteger(L, lua.Integer(MouseEnum.Middle))
	lua.setfield(L, -2, "Middle")

	lua.pushinteger(L, lua.Integer(MouseEnum.Side))
	lua.setfield(L, -2, "Side")

	lua.pushinteger(L, lua.Integer(MouseEnum.Extra))
	lua.setfield(L, -2, "Extra")

    return 1
}
