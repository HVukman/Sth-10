package sth10


import "core:fmt"
import lua "vendor:lua/5.4"
import "core:c/libc"
import "base:runtime"
import rl "vendor:raylib"
import "core:strings"
import "core:os"


lua_draw_text :: proc "c" (L: ^lua.State) -> i32 {

	COLOR_ARRAY := COLOR_ARRAY
	text := lua.L_checkstring(L,1)
	pos:= cast(^point)lua.L_checkudata(L,2,"PointMT")
	size := lua.L_checkinteger(L,3)

	col_:= lua.L_checkinteger(L,4)

	rl.DrawText( text, i32(pos.x), i32(pos.y), i32(size), COLOR_ARRAY[col_])
	return 0
}


lua_textlib := []lua.L_Reg{
	{"draw_text", lua_draw_text },
    {nil, nil},
}

luatext_open :: proc "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()

    lua.L_newlib(L, lua_textlib)
    return 1
}
