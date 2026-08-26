package drawing

import "../colors"
import shapes "../shapes"
import "base:runtime"
import "core:fmt"
import "core:strings"
import lua "vendor:lua/5.4"
import rl "vendor:raylib"

render_texture_wrap :: struct {
	render_texture: rl.RenderTexture,
}


// clear background
//
l_clear_background :: proc "c" (L: ^lua.State) -> i32 {

	COLOR_ARRAY := colors.COLOR_ARRAY
	col_ := lua.L_checkinteger(L, 1)
	rl.ClearBackground(COLOR_ARRAY[col_])
	return 0
}

// draw pixel or point
l_draw_point :: proc "c" (L: ^lua.State) -> i32 {

	COLOR_ARRAY := colors.COLOR_ARRAY
	point_ := cast(^shapes.point)lua.L_checkudata(L, 1, "PointMT")
	col_ := lua.L_checkinteger(L, 2)
	rl.DrawPixel(i32(point_.x), i32(point_.y), COLOR_ARRAY[col_])
	return 0
}

l_draw_line :: proc "c" (L: ^lua.State) -> i32 {

	COLOR_ARRAY := colors.COLOR_ARRAY
	point_ := cast(^shapes.point)lua.L_checkudata(L, 1, "PointMT")
	point2_ := cast(^shapes.point)lua.L_checkudata(L, 2, "PointMT")
	col_ := lua.L_checkinteger(L, 3)

	rl.DrawLine(i32(point_.x), i32(point_.y), i32(point2_.x), i32(point2_.y), COLOR_ARRAY[col_])

	return 0
}


l_draw_full_rectangle :: proc "c" (L: ^lua.State) -> i32 {

	COLOR_ARRAY := colors.COLOR_ARRAY
	rect_ := cast(^shapes.rectangle)lua.L_checkudata(L, 1, "RectangleMT")

	col_ := lua.L_checkinteger(L, 2)

	rl.DrawRectangle(
		i32(rect_.x),
		i32(rect_.y),
		i32(rect_.width),
		i32(rect_.height),
		COLOR_ARRAY[col_],
	)

	return 0
}

l_draw_lines_rectangle :: proc "c" (L: ^lua.State) -> i32 {

	COLOR_ARRAY := colors.COLOR_ARRAY
	rect_ := cast(^shapes.rectangle)lua.L_checkudata(L, 1, "RectangleMT")

	col_ := lua.L_checkinteger(L, 2)

	rl.DrawRectangleLines(
		i32(rect_.x),
		i32(rect_.y),
		i32(rect_.width),
		i32(rect_.height),
		COLOR_ARRAY[col_],
	)

	return 0
}

l_draw_full_ellipse :: proc "c" (L: ^lua.State) -> i32 {

	COLOR_ARRAY := colors.COLOR_ARRAY
	ellipse := cast(^shapes.Ellipse)lua.L_checkudata(L, 1, "EllipseMT")

	col_ := lua.L_checkinteger(L, 2)

	point_ := ellipse.center
	rl.DrawEllipse(
		i32(point_.x),
		i32(point_.y),
		f32(ellipse.radiush),
		f32(ellipse.radiusv),
		COLOR_ARRAY[col_],
	)

	return 0
}


l_draw_lines_ellipse :: proc "c" (L: ^lua.State) -> i32 {

	COLOR_ARRAY := colors.COLOR_ARRAY
	ellipse := cast(^shapes.Ellipse)lua.L_checkudata(L, 1, "EllipseMT")

	col_ := lua.L_checkinteger(L, 2)
	point_ := ellipse.center
	rl.DrawEllipse(
		i32(point_.x),
		i32(point_.y),
		f32(ellipse.radiush),
		f32(ellipse.radiusv),
		COLOR_ARRAY[col_],
	)

	return 0
}

l_draw_full_polygon :: proc "c" (L: ^lua.State) -> i32 {

	COLOR_ARRAY := colors.COLOR_ARRAY
	poly := cast(^shapes.Polygon)lua.L_checkudata(L, 1, "PolygonMT")

	col_ := lua.L_checkinteger(L, 2)

	point_ := poly.center
	center := rl.Vector2{f32(point_.x), point_.y}
	rl.DrawPoly(center, i32(poly.sides), f32(poly.radius), f32(poly.rotation), COLOR_ARRAY[col_])

	return 0
}

l_draw_full_circle :: proc "c" (L: ^lua.State) -> i32 {

	COLOR_ARRAY := colors.COLOR_ARRAY
	circ_ := cast(^shapes.circle)lua.L_checkudata(L, 1, "CircleMT")

	col_ := lua.L_checkinteger(L, 2)

	rl.DrawCircle(i32(circ_.x), i32(circ_.y), f32(circ_.radius), COLOR_ARRAY[col_])

	return 0
}

l_draw_lines_circle :: proc "c" (L: ^lua.State) -> i32 {

	COLOR_ARRAY := colors.COLOR_ARRAY
	circ_ := cast(^shapes.circle)lua.L_checkudata(L, 1, "CircleMT")

	col_ := lua.L_checkinteger(L, 2)

	rl.DrawCircleLines(i32(circ_.x), i32(circ_.y), f32(circ_.radius), COLOR_ARRAY[col_])

	return 0
}

l_draw_triangle :: proc "c" (L: ^lua.State) -> i32 {


	COLOR_ARRAY := colors.COLOR_ARRAY
	tri_ := cast(^shapes.triangle)lua.L_checkudata(L, 1, "TriangleMT")

	v1: rl.Vector2
	v2: rl.Vector2
	v3: rl.Vector2

	v1.xx = tri_.p1.x
	v1.yy = tri_.p1.y

	v2.xx = tri_.p2.x
	v2.yy = tri_.p2.y

	v3.xx = tri_.p3.x
	v3.yy = tri_.p3.y

	col_ := lua.L_checkinteger(L, 2)
	rl.DrawTriangle(v1, v2, v3, COLOR_ARRAY[col_])

	return 0
}

l_draw_triangle_lines :: proc "c" (L: ^lua.State) -> i32 {


	COLOR_ARRAY := colors.COLOR_ARRAY
	tri_ := cast(^shapes.triangle)lua.L_checkudata(L, 1, "TriangleMT")

	v1: rl.Vector2
	v2: rl.Vector2
	v3: rl.Vector2

	v1.xx = tri_.p1.x
	v1.yy = tri_.p1.y

	v2.xx = tri_.p2.x
	v2.yy = tri_.p2.y

	v3.xx = tri_.p3.x
	v3.yy = tri_.p3.y

	col_ := lua.L_checkinteger(L, 2)
	rl.DrawTriangleLines(v1, v2, v3, COLOR_ARRAY[col_])

	return 0
}

// begin 2d
//
lua_begin_2d :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	cam := cast(^rl.Camera2D)lua.touserdata(L, 1)
	rl.BeginMode2D(cam^)
	return 0

}

// end 2d
//
lua_end_2d :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	rl.EndMode2D()
	return 0

}


// new camera
//
lua_new_camera :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	cam := cast(^rl.Camera2D)lua.newuserdata(L, size_of(rl.Camera2D))
	lua.L_setmetatable(L, "CameraMT")
	return 1

}

// set camera target
lua_set_camera_target :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	cam := cast(^rl.Camera2D)lua.L_checkudata(L, 1, "CameraMT")
	point_ := cast(^shapes.point)lua.L_checkudata(L, 2, "PointMT")
	cam.target.x = point_.x
	cam.target.y = point_.y

	return 0

}

// set camera target
lua_set_camera_offset :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	cam := cast(^rl.Camera2D)lua.L_checkudata(L, 1, "CameraMT")
	point_ := cast(^shapes.point)lua.L_checkudata(L, 2, "PointMT")
	cam.offset.x = point_.x
	cam.offset.y = point_.y

	return 0

}

// set camera zoom
lua_set_camera_zoom :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	cam := cast(^rl.Camera2D)lua.L_checkudata(L, 1, "CameraMT")
	zoom := lua.L_checknumber(L, 2)

	cam.zoom = f32(zoom)

	return 0

}

// set camera rot
lua_set_camera_rotation :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	cam := cast(^rl.Camera2D)lua.L_checkudata(L, 1, "CameraMT")
	rot := lua.L_checknumber(L, 2)

	cam.rotation = f32(rot)

	return 0

}

lua_end_texture_mode :: proc "c" (L: ^lua.State) -> i32 {
	rl.EndTextureMode()
	return 0
}

lua_begin_texture_mode :: proc "c" (L: ^lua.State) -> i32 {

	rt := cast(^render_texture_wrap)lua.L_checkudata(L, 1, "RenderTextureMT")
	rl.BeginTextureMode(rt.render_texture)
	return 0
}

lua_render_texture :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	w := lua.L_checknumber(L, 1)
	h := lua.L_checknumber(L, 2)
	rendertext := cast(^render_texture_wrap)lua.newuserdata(L, size_of(render_texture_wrap))
	rendertext.render_texture.texture.height = i32(h)
	rendertext.render_texture.texture.width = i32(w)

	lua.L_setmetatable(L, "RenderTextureMT")

	return 1

}

lua_rt_gc :: proc "c" (L: ^lua.State) -> i32 {

	rt := cast(^render_texture_wrap)lua.L_checkudata(L, 1, "RenderTextureMT")
	rl.UnloadRenderTexture(rt.render_texture)
	return 0

}
// Get camera field (__index)
lua_camera_getindex :: proc "c" (L: ^lua.State) -> i32 {
	context = runtime.default_context()
	cam := cast(^rl.Camera2D)lua.L_checkudata(L, 1, "CameraMT")
	ind := lua.L_checkstring(L, 2)

	if ind == "offset" || ind == "Offset" {
		result := cast(^shapes.point)lua.newuserdata(L, size_of(shapes.point))
		result.x = cam.offset.x
		result.y = cam.offset.y
		return 1
	} else if ind == "target" || ind == "Target" {

		result := cast(^shapes.point)lua.newuserdata(L, size_of(shapes.point))
		result.x = cam.target.x
		result.y = cam.target.y
		return 1

	} else if ind == "rotation" || ind == "Rotation" {

		lua.pushnumber(L, lua.Number(cam.rotation))
		return 1

	} else if ind == "zoom" || ind == "Zoom" {

		lua.pushnumber(L, lua.Number(cam.zoom))
		return 1


	} else {
		fmt.println("no valid index")
		lua.pushnil(L)
		return 1
	}


}

// Set camera field (__newindex)
lua_camera_index :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	cam := cast(^rl.Camera2D)lua.L_checkudata(L, 1, "CameraMT")
	ind := lua.L_checkstring(L, 2)

	if ind == "offset" || ind == "Offset" {
		p := cast(^shapes.point)lua.L_checkudata(L, 3, "PointMT")

		cam.offset.x = p.x
		cam.offset.y = p.y
		return 1
	} else if ind == "target" || ind == "Target" {

		p := cast(^shapes.point)lua.L_checkudata(L, 3, "PointMT")

		cam.target.x = p.x
		cam.target.y = p.y
		return 1

	} else if ind == "rotation" || ind == "Rotation" {

		r := lua.L_checknumber(L, 3)
		cam.rotation = f32(r)
		return 1

	} else if ind == "zoom" || ind == "Zoom" {

		z := lua.L_checknumber(L, 3)
		cam.zoom = f32(z)
		return 1


	} else {
		fmt.println("no valid index")
		lua.pushnil(L)
		return 1
	}

}

// __tostring for camera
lua_camera_tostring :: proc "c" (L: ^lua.State) -> i32 {
	context = runtime.default_context()
	cam := cast(^rl.Camera2D)lua.L_checkudata(L, 1, "CameraMT")

	buf: [128]byte
	result := fmt.bprintf(
		buf[:],
		"Cam(target: x=%.2f, y=%.2f; offset  x=%.2f, y=%.2f ; rot %.2f ; zoom %.2f)",
		cam.target.x,
		cam.target.y,
		cam.offset.x,
		cam.offset.y,
		cam.rotation,
		cam.zoom,
	)
	lua.pushstring(L, strings.clone_to_cstring(result))
	return 1
}

camera_meta := []lua.L_Reg {
	{"__index", lua_camera_getindex},
	{"__newindex", lua_camera_index},
	{"__tostring", lua_camera_tostring},
	{nil, nil},
}

rendertexture_meta := []lua.L_Reg{{"__gc", lua_rt_gc}, {nil, nil}}

draw_meta := []lua.L_Reg {
	//	{"point", l_draw_point},
	{nil, nil},
}

drawlib := []lua.L_Reg {
	{"point", l_draw_point},
	{"line", l_draw_line},
	{"triangle", l_draw_triangle},
	{"lines_triangle", l_draw_triangle_lines},
	{"clear_background", l_clear_background},
	{"rectangle", l_draw_full_rectangle},
	{"lines_rectangle", l_draw_lines_rectangle},
	{"ellipse", l_draw_full_ellipse},
	{"lines_ellipse", l_draw_lines_ellipse},
	{"polygon", l_draw_full_polygon},
	{"circle", l_draw_full_circle},
	{"lines_circle", l_draw_lines_circle},
	{"new_render_texture", lua_render_texture},
	{"begin_texture_mode", lua_begin_texture_mode},
	{"end_texture_mode", lua_end_texture_mode},
	{"new_camera", lua_new_camera},
	{"camera_set_zoom", lua_set_camera_zoom},
	{"camera_set_target", lua_set_camera_target},
	{"camera_set_offset", lua_set_camera_target},
	{"camera_set_rotation", lua_set_camera_rotation},
	{"begin_mode_2D", lua_begin_2d },
	{"end_mode_2D", lua_end_2d },
		{"load_shader", lua_load_shader},
	{nil, nil},
}

lua_opendraw :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()

	lua.L_newmetatable(L, "RenderTextureMT")
	lua.L_setfuncs(L, raw_data(rendertexture_meta), 0)
	lua.pop(L, 1)

	lua.L_newmetatable(L, "CameraMT")
	lua.L_setfuncs(L, raw_data(camera_meta), 0)
	lua.pop(L, 1)

	lua.L_newmetatable(L, "ShaderMT")
	lua.L_setfuncs(L, raw_data(shader_meta), 0)
	lua.pop(L, 1)

	lua.L_setfuncs(L, raw_data(draw_meta), 0)
	lua.L_newlib(L, drawlib)

	return 1
}
