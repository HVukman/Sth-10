package lighttexture


import color "../colors"
import img "../images"
import shapes "../shapes"
import "base:runtime"
import "core:fmt"
import "core:os"
import "core:strings"
import lua "vendor:lua/5.4"
import rl "vendor:raylib"

import hm "core:container/handle_map"

Handle :: hm.Handle16

// texture wrapper
TextureData :: struct {
	texture: rl.Texture2D,
}

// handle wrapper
Handle_Wrap :: struct {
	handle: u64,
}

Entity :: struct {
	handle:   Handle,
	texture_: TextureData,
}

entities: hm.Dynamic_Handle_Map(Entity, Handle)
// Creates a texture from an image and returns a handle
texture_system_load_from_file :: proc(file: cstring) -> hm.Handle16 {

	texture := rl.LoadTexture(file)
	texture_data: TextureData
	texture_data.texture = texture
	h1 := hm.add(&entities, Entity{texture_ = texture_data})

	// 3. Return a handle (packing index and generation)
	return h1
}

// Retrieves a *pointer* to the texture from a handle (safety checks!)
texture_system_draw :: proc(handle: hm.Handle16, x, y: i32) {
	if e, ok := hm.dynamic_get(&entities, handle); ok {
		rl.DrawTexture(e.texture_.texture, x, y, rl.WHITE)
	} else {
		fmt.println("not ok")

	}
}

// free texture
texture_system_free :: proc(handle: hm.Handle16) {
	if e, ok := hm.dynamic_get(&entities, handle); ok {
		rl.UnloadTexture(e.texture_.texture)
	} else {
		fmt.println("not ok")
	}
}

// Lua binding: texture.load("path.png")
lua_load_texture_handle :: proc "c" (L: ^lua.State) -> i32 {
	context = runtime.default_context()
	filename := lua.L_checkstring(L, 1)

	//Load the image
	text_ := rl.LoadTexture(filename)
	if !rl.IsTextureValid(text_) {
		lua.L_error(L, "Failed to load texture: %s", filename)
		return 0
	}

	handle := texture_system_load_from_file(filename)
	rl.UnloadTexture(text_) //

	//  Push the handle as  userdata (or integer) to Lua

	packed := (u64(handle.idx) << 32) | u64(handle.gen)

	// only cast as integer!
	handledata := cast(^Handle_Wrap)lua.newuserdata(L, size_of(Handle_Wrap))
	handledata.handle = packed
	lua.L_setmetatable(L, "LightTextureMT")
	return 1

}

lua_texture_draw_handle :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	// Retrieve the handle from the userdata
	//
	handle_ := cast(^Handle_Wrap)lua.L_checkudata(L, 1, "LightTextureMT")

	x := i32(lua.L_checknumber(L, 2))
	y := i32(lua.L_checknumber(L, 3))

	packed := uintptr(handle_.handle)
	handle: hm.Handle16
	handle.idx = u8(packed >> 32)
	handle.gen = u8(packed & 0xFFFFFFFF)

	// draw texture at x,y
	texture_system_draw(handle, x, y)

	return 0
}

lua_texture_free_handle :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	// Retrieve the handle from the light userdata
	packed := uintptr(lua.touserdata(L, 1))
	handle: hm.Handle16
	handle.idx = u8(packed >> 32)
	handle.gen = u8(packed & 0xFFFFFFFF)
	x := i32(lua.L_checknumber(L, 2))
	y := i32(lua.L_checknumber(L, 3))

	// Convert handle to a safe pointer
	texture_system_free(handle)

	return 0
}


// draw as spritesheet
// draw_as_spritesheet(texture, sprite_int, point, width, height )
lua_draw_as_sprite :: proc "c" (L: ^lua.State) -> i32 {

	text_ := cast(^TextureData)lua.L_checkudata(L, 1, "TextureMT")
	sprite_int := i32(lua.L_checknumber(L, 2))
	point := cast(^shapes.point)lua.L_checkudata(L, 3, "PointMT")

	xpos := point.x
	ypos := point.y

	sprite_w_b := lua.isnoneornil(L, 4)
	sprite_h_b := lua.isnoneornil(L, 5)

	width: i32
	height: i32

	if sprite_w_b {
		width = 32
	} else {
		width = i32(lua.L_checknumber(L, 4))
	}
	if sprite_w_b {
		height = 32
	} else {
		height = i32(lua.L_checknumber(L, 5))
	}


	//  standard: (0*32)%256
	texture_x := (sprite_int * width) % (text_.texture.width * text_.texture.height)
	// standard: ((6*32)//96)*32
	// standard: ((6*height)//text_.height)*height
	texture_y := ((sprite_int * height) / text_.texture.height) * height


	rl.DrawTextureRec(
		text_.texture,
		{f32(texture_x), f32(texture_y), f32(width), f32(height)},
		{xpos, ypos},
		rl.WHITE,
	)
	return 0
}

// draw expert
lua_draw_ex :: proc "c" (L: ^lua.State) -> i32 {

	col := color.COLOR_ARRAY
	text_ := cast(^TextureData)lua.L_checkudata(L, 1, "TextureMT")
	point_ := cast(^shapes.point)lua.L_checkudata(L, 2, "PointMT")
	pos: rl.Vector2
	pos.x = point_.x
	pos.y = point_.y
	rot := lua.L_checknumber(L, 3)
	scale := lua.L_checknumber(L, 4)
	col_ := lua.L_checkinteger(L, 5)
	rl.DrawTextureEx(text_.texture, pos, f32(rot), f32(scale), col[col_])
	return 0
}

lua_draw :: proc "c" (L: ^lua.State) -> i32 {

	text_ := cast(^TextureData)lua.L_checkudata(L, 1, "TextureMT")
	point_ := cast(^shapes.point)lua.L_checkudata(L, 2, "PointMT")
	x := point_.x
	y := point_.y
	rl.DrawTexture(text_.texture, i32(x), i32(y), rl.WHITE)
	return 0
}


lua_texture_from_image :: proc "c" (L: ^lua.State) -> i32 {

	img_ := cast(^img.ImageData)lua.L_checkudata(L, 1, "ImageMT")
	texture_ := rl.LoadTextureFromImage(img_.image)

	newtext := cast(^TextureData)lua.newuserdata(L, size_of(TextureData))
	newtext.texture = texture_
	lua.L_setmetatable(L, "TextureMT")
	return 1
}

lua_texture_gc :: proc "c" (L: ^lua.State) -> i32 {


	context = runtime.default_context()
	// Retrieve the handle from the userdata
	//
	handle_ := cast(^Handle_Wrap)lua.L_checkudata(L, 1, "LightTextureMT")

	x := i32(lua.L_checknumber(L, 2))
	y := i32(lua.L_checknumber(L, 3))

	packed := uintptr(handle_.handle)
	handle: hm.Handle16
	handle.idx = u8(packed >> 32)
	handle.gen = u8(packed & 0xFFFFFFFF)

	// unload texture
	texture_system_free(handle)


	return 0
}

lighttexture_meta := []lua.L_Reg {
	/*   {"__index", lua_getpointindex  },
    {"__newindex",  lua_setpoint},

    {"__tostring", lua_image_tostring},
    {"__add", lua_point_add},
    {"__sub", lua_point_sub},
    {"__mul", lua_point_mul}, */
	{"__gc", lua_texture_gc},
	{nil, nil},
}

lua_texturelib := []lua.L_Reg {
	//	{"is_valid", lua_valid_texture},
	//	{"texture_from_image", lua_texture_from_image},
	{"load_texture", lua_load_texture_handle},
	{"draw_texture", lua_texture_draw_handle},

//	{"draw", lua_draw},
//	{"draw_expert", lua_draw_ex},
	//	{"draw_as_spritesheet",lua_draw_as_sprite},
	{nil, nil},
}

lua_opentexture :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()

	lua.L_newmetatable(L, "LightTextureMT")
	lua.L_setfuncs(L, raw_data(lighttexture_meta), 0)
	lua.pop(L, 1)


	lua.L_newlib(L, lua_texturelib)
	return 1

}
