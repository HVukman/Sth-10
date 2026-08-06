package sth10


import "core:fmt"
import lua "vendor:lua/5.4"
import "core:c/libc"
import "base:runtime"
import rl "vendor:raylib"
import "core:strings"
import "core:os"

// Image userdata wrapper
ImageData :: struct {
    image: rl.Image,
}


lua_load_image :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	file := lua.L_checkstring(L,1)

	if os.is_file(strings.clone_from_cstring(file)) {
		img_ := rl.LoadImage(file)
		if rl.IsImageValid(img_) {
			fmt.printfln("succesfully loaded image %s", file)
			img:= cast(^ImageData)lua.newuserdata(L, size_of(ImageData))
			img.image = img_
			lua.L_setmetatable(L, "ImageMT")
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

lua_image_tostring :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	img:= cast(^ImageData)lua.L_checkudata(L, 1 , "ImageMT")
	res := fmt.tprintf("Image width: %i height %i" , img.image.width , img.image.height)
	lua.pushstring(L, strings.clone_to_cstring(res))
	return 1
}

lua_image_gc :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	img:= cast(^ImageData)lua.L_checkudata(L, 1 , "ImageMT")
	rl.UnloadImage(img.image)
	return 0
}

image_meta := []lua.L_Reg{
 /*   {"__index", lua_getpointindex  },
    {"__newindex",  lua_setpoint},
    */
    {"__tostring", lua_image_tostring},
  /* {"__add", lua_point_add},
    {"__sub", lua_point_sub},
    {"__mul", lua_point_mul}, */
    {"__gc", lua_image_gc},
    {nil, nil},
}


lua_imagelib := []lua.L_Reg{
	{"load_image", lua_load_image},
    {nil, nil},
}

 lua_openimage :: proc "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()

    lua.L_newmetatable(L, "ImageMT")
    lua.L_setfuncs(L, raw_data(image_meta), 0)
    lua.pop(L, 1)

    lua.L_newlib(L,  lua_imagelib)

    return 1

}
