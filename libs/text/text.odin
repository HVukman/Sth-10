package text


import "core:fmt"
import lua "vendor:lua/5.4"
import "core:c/libc"
import "base:runtime"
import rl "vendor:raylib"
import "core:strings"
import "core:os"
import "../colors"
import "../shapes"

// Texture userdata wrapper
FontData :: struct {
	font : rl.Font,
	fonttype : rl.FontType,
}

lua_draw_text_ex :: proc "c" (L: ^lua.State) -> i32 {

	COLOR_ARRAY := colors.COLOR_ARRAY
	font_:= cast(^FontData)lua.L_checkudata(L,1,"FontMT")
	text := lua.L_checkstring(L,2)
	pos:= cast(^shapes.point)lua.L_checkudata(L,3,"PointMT")
	size := lua.L_checknumber(L,4)
	spacing := lua.L_checknumber(L,5)
	col_:= lua.L_checkinteger(L,6)
	vec2 : rl.Vector2
	vec2.x = pos.x
	vec2.y = pos.y
	rl.DrawTextEx( font_.font, text , vec2, f32(size),f32(spacing), COLOR_ARRAY[col_])
	return 0
}

lua_draw_fps :: proc "c" (L: ^lua.State) -> i32 {

	COLOR_ARRAY := colors.COLOR_ARRAY
	pos:= cast(^shapes.point)lua.L_checkudata(L,1,"PointMT")
	rl.DrawFPS(  i32(pos.x), i32(pos.y))
	return 0
}


lua_draw_text :: proc "c" (L: ^lua.State) -> i32 {

	COLOR_ARRAY := colors.COLOR_ARRAY

	text := lua.L_checkstring(L,1)
	pos:= cast(^shapes.point)lua.L_checkudata(L,2,"PointMT")
	size := lua.L_checkinteger(L,3)
	col_:= lua.L_checkinteger(L,4)

	rl.DrawText( text, i32(pos.x), i32(pos.y), i32(size), COLOR_ARRAY[col_])
	return 0
}


lua_load_font :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()

	path := lua.L_checkstring(L,1)

	if os.is_file(strings.clone_from_cstring(path)) {
		f := rl.LoadFont(path)
		if rl.IsFontValid(f){
			f_ :=  cast(^FontData)lua.newuserdata(L, size_of(FontData))
			f_.font = f
			f_.fonttype = rl.FontType.DEFAULT
			lua.L_setmetatable(L, "FontMT")
			return 1
		}else{
			lua.L_error(L, "%s not a valid font", path)
			return 0
		}
	}else{
			lua.L_error(L, "%s not a valid path", path)
			return 0
	}

}


lua_get_default_font :: proc "c" (L: ^lua.State) -> i32 {

	f :=  cast(^FontData)lua.newuserdata(L, size_of(rl.Font))
	f.font = rl.GetFontDefault()
	f.fonttype = rl.FontType.DEFAULT
	return 1
}


lua_text_gc :: proc "c" (L: ^lua.State) -> i32 {

 	context = runtime.default_context()
    text := cast(^FontData)lua.L_checkudata(L, 1, "FontMT")
    rl.UnloadFont(text.font)

	return 0
}

text_meta := []lua.L_Reg{
 /*   {"__index", lua_getpointindex  },
    {"__newindex",  lua_setpoint},
    */
   // {"__tostring", lua_texture_tostring},

  /* {"__add", lua_point_add},
    {"__sub", lua_point_sub},
    {"__mul", lua_point_mul}, */
    {"__gc", lua_text_gc},
    {nil, nil},
}


lua_textlib := []lua.L_Reg{
	{"draw_text", lua_draw_text },
	{"draw_fps", lua_draw_fps},
	{"draw_text_ex", lua_draw_text_ex },
	{"get_default_font",lua_get_default_font },
	{"load_font",lua_load_font },
    {nil, nil},
}

luatext_open :: proc "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()

    lua.L_newmetatable(L, "FontMT")
    lua.L_setfuncs(L, raw_data(text_meta), 0)
    lua.pop(L, 1)


    lua.L_newlib(L, lua_textlib)
    return 1
}
