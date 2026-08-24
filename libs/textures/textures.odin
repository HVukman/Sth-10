package textures


import img "../images"
import shapes "../shapes"
import "base:runtime"
import "core:fmt"
import "core:strings"
import lua "vendor:lua/5.4"
import rl "vendor:raylib"
import "core:os"

// Texture userdata wrapper
TextureData :: struct {
	texture: rl.Texture2D,
}


texture_meta := []lua.L_Reg {
	/*   {"__index", lua_getpointindex  },
    {"__newindex",  lua_setpoint},
    */
	{"__tostring", lua_texture_tostring},
	{"__gc", lua_texture_gc},
	/* {"__add", lua_point_add},
    {"__sub", lua_point_sub},
    {"__mul", lua_point_mul}, */
	{nil, nil},
}

lua_valid_texture :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()

	text := cast(^TextureData)lua.L_checkudata(L, 1, "TextureMT")

	valid := rl.IsTextureValid(text.texture)
	lua.pushboolean(L, b32(valid))

	return 1
}

lua_draw :: proc "c" (L: ^lua.State) -> i32 {

	text_ := cast(^TextureData)lua.L_checkudata(L, 1, "TextureMT")
	point_ := cast(^shapes.point)lua.L_checkudata(L, 2, "PointMT")
	x := point_.x
	y := point_.y
	rl.DrawTexture(text_.texture, i32(x), i32(y), rl.WHITE)
	return 0
}

lua_texture_gc :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	text := cast(^TextureData)lua.L_checkudata(L, 1, "TextureMT")
	rl.UnloadTexture(text.texture)
	return 0
}

lua_load_texture :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	file := lua.L_checkstring(L,1)

	if os.is_file(strings.clone_from_cstring(file)) {
		text_ := rl.LoadTexture(file)
		if rl.IsTextureValid(text_) {
			fmt.printfln("succesfully loaded texture %s", file)
			text:= cast(^TextureData)lua.newuserdata(L, size_of(TextureData))
			text.texture = text_
			lua.L_setmetatable(L, "TextureMT")
			return 1
		}else{
			fmt.println("invalid image  %s ", file)
			lua.L_error(L, "invalid image")
			return 0
		}
	}else{

		lua.L_error(L, "invalid file  %s" , file)
		return 0
	}

}

lua_texture_from_image :: proc "c" (L: ^lua.State) -> i32 {

	img_ := cast(^img.ImageData)lua.L_checkudata(L, 1, "ImageMT")
	texture_ := rl.LoadTextureFromImage(img_.image)

	newtext := cast(^TextureData)lua.newuserdata(L, size_of(TextureData))
	newtext.texture = texture_
	lua.L_setmetatable(L, "TextureMT")
	return 1
}

lua_texture_tostring :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	text := cast(^TextureData)lua.L_checkudata(L, 1, "TextureMT")
	res := fmt.tprintf("Texture width: %i height %i", text.texture.width, text.texture.height)
	lua.pushstring(L, strings.clone_to_cstring(res))
	return 1
}

lua_texturelib := []lua.L_Reg {
	{"is_valid", lua_valid_texture},
	{"texture_from_image", lua_texture_from_image},
	{"load_texture", lua_load_texture },
	{"draw", lua_draw},
	{nil, nil},
}

lua_opentexture :: proc "c" (L: ^lua.State) -> i32 {
	context = runtime.default_context()

	lua.L_newmetatable(L, "TextureMT")
	lua.L_setfuncs(L, raw_data(texture_meta), 0)
	lua.pop(L, 1)

	lua.L_newlib(L, lua_texturelib)

	return 1

}
