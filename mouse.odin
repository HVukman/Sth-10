package sth10


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
}


lua_is_mousebutton_pressed :: proc "c" (L: ^lua.State) -> i32 {

	key := lua.L_checkinteger(L, 1)
	is_pressed := rl.IsMouseButtonPressed(rl.MouseButton(key))
	lua.pushboolean(L, b32(is_pressed))

	return 1
}


lua_mouselib := []lua.L_Reg{
	{"is_mouse_button_pressed", lua_is_mousebutton_pressed},
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


    return 1
}
