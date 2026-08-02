package sth10

import rl "vendor:raylib"
import lua "vendor:lua/5.4"
import "core:fmt"
import "base:runtime"


draw_meta := []lua.L_Reg{
//	{"point", l_draw_point},
    {nil, nil},
}

drawlib := []lua.L_Reg{
	{"point", l_draw_point},
    {nil, nil},
}

// draw pixel or point
l_draw_point :: proc "c" (L: ^lua.State) -> i32 {

	 COLOR_ARRAY := COLOR_ARRAY
	point_:= cast(^point)lua.L_checkudata(L,1,"PointMT")
	col_:= lua.L_checkinteger(L,2)
	rl.DrawPixel(i32(point_.x),i32(point_.y), COLOR_ARRAY[col_])
	return 0
}

lua_opendraw :: proc "c" (L: ^lua.State) -> i32  {

	context = runtime.default_context()

	lua.L_setfuncs(L, raw_data(draw_meta), 0)
	lua.L_newlib(L, drawlib)
	return 1
}
