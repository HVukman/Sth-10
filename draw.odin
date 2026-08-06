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
	{"line", l_draw_line},
	{"triangle", l_draw_triangle},
	{"lines_triangle", l_draw_triangle_lines},
	{"clear_background" , l_clear_background },
	{"rectangle", l_draw_full_rectangle},
	{"lines_rectangle", l_draw_lines_rectangle},
	{"circle", l_draw_full_circle},
	{"lines_circle", l_draw_lines_circle},
    {nil, nil},
}

// clear background
//
l_clear_background :: proc "c" (L: ^lua.State) -> i32 {

	COLOR_ARRAY := COLOR_ARRAY
	col_:= lua.L_checkinteger(L,1)
	rl.ClearBackground( COLOR_ARRAY[col_])
	return 0
}

// draw pixel or point
l_draw_point :: proc "c" (L: ^lua.State) -> i32 {

	 COLOR_ARRAY := COLOR_ARRAY
	point_:= cast(^point)lua.L_checkudata(L,1,"PointMT")
	col_:= lua.L_checkinteger(L,2)
	rl.DrawPixel(i32(point_.x),i32(point_.y), COLOR_ARRAY[col_])
	return 0
}

l_draw_line :: proc "c" (L: ^lua.State) -> i32 {

	COLOR_ARRAY := COLOR_ARRAY
	point_:= cast(^point)lua.L_checkudata(L,1,"PointMT")
	point2_:= cast(^point)lua.L_checkudata(L,2,"PointMT")
	col_:= lua.L_checkinteger(L,3)

	rl.DrawLine(i32(point_.x),i32(point_.y), i32(point2_.x),i32(point2_.y) , COLOR_ARRAY[col_])

	return 0
}


l_draw_full_rectangle :: proc "c" (L: ^lua.State) -> i32 {

	COLOR_ARRAY := COLOR_ARRAY
	rect_:= cast(^rectangle)lua.L_checkudata(L,1,"RectangleMT")

	col_:= lua.L_checkinteger(L,2)

	rl.DrawRectangle(i32(rect_.x),i32(rect_.y),i32(rect_.width),i32(rect_.height) , COLOR_ARRAY[col_])

	return 0
}

l_draw_lines_rectangle :: proc "c" (L: ^lua.State) -> i32 {

	COLOR_ARRAY := COLOR_ARRAY
	rect_:= cast(^rectangle)lua.L_checkudata(L,1,"RectangleMT")

	col_:= lua.L_checkinteger(L,2)

	rl.DrawRectangleLines(i32(rect_.x),i32(rect_.y),i32(rect_.width),i32(rect_.height) , COLOR_ARRAY[col_])

	return 0
}


l_draw_full_circle :: proc "c" (L: ^lua.State) -> i32 {

	COLOR_ARRAY := COLOR_ARRAY
	circ_:= cast(^circle)lua.L_checkudata(L,1,"CircleMT")

	col_:= lua.L_checkinteger(L,2)

	rl.DrawCircle(i32(circ_.x),i32(circ_.y),f32(circ_.radius), COLOR_ARRAY[col_])

	return 0
}

l_draw_lines_circle :: proc "c" (L: ^lua.State) -> i32 {

	COLOR_ARRAY := COLOR_ARRAY
	circ_:= cast(^circle)lua.L_checkudata(L,1,"CircleMT")

	col_:= lua.L_checkinteger(L,2)

	rl.DrawCircleLines(i32(circ_.x),i32(circ_.y),f32(circ_.radius), COLOR_ARRAY[col_])

	return 0
}

l_draw_triangle :: proc "c" (L: ^lua.State) -> i32 {


	COLOR_ARRAY := COLOR_ARRAY
	tri_:= cast(^triangle)lua.L_checkudata(L,1,"TriangleMT")

	v1 : rl.Vector2
	v2 : rl.Vector2
	v3 : rl.Vector2

	v1.xx = tri_.p1.x
	v1.yy = tri_.p1.y

	v2.xx = tri_.p2.x
	v2.yy = tri_.p2.y

	v3.xx = tri_.p3.x
	v3.yy = tri_.p3.y

	col_:= lua.L_checkinteger(L,2)
	rl.DrawTriangle(v1,v2,v3, COLOR_ARRAY[col_])

	return 0
}

l_draw_triangle_lines  :: proc "c" (L: ^lua.State) -> i32 {


	COLOR_ARRAY := COLOR_ARRAY
	tri_:= cast(^triangle)lua.L_checkudata(L,1,"TriangleMT")

	v1 : rl.Vector2
	v2 : rl.Vector2
	v3 : rl.Vector2

	v1.xx = tri_.p1.x
	v1.yy = tri_.p1.y

	v2.xx = tri_.p2.x
	v2.yy = tri_.p2.y

	v3.xx = tri_.p3.x
	v3.yy = tri_.p3.y

	col_:= lua.L_checkinteger(L,2)
	rl.DrawTriangleLines(v1,v2,v3, COLOR_ARRAY[col_])

	return 0
}

lua_opendraw :: proc "c" (L: ^lua.State) -> i32  {

	context = runtime.default_context()

	lua.L_setfuncs(L, raw_data(draw_meta), 0)
	lua.L_newlib(L, drawlib)
	return 1
}
