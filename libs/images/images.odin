package images


import "core:fmt"
import lua "vendor:lua/5.4"
import "core:c/libc"
import "base:runtime"
import rl "vendor:raylib"
import "core:strings"
import "core:os"
import "core:math"
import "../colors"
import shapes "../shapes"



// Image userdata wrapper
ImageData :: struct {
    image: rl.Image,
}

lua_resize_image :: proc "c" (L: ^lua.State) -> i32 {


    context = runtime.default_context()
    img:= cast(^ImageData)lua.L_checkudata(L,1,"ImageMT")
    w:= lua.L_checknumber(L,2)
    h:= lua.L_checknumber(L,3)
    rl.ImageResize(&img.image,i32(w),i32(h))
    return 0

}

lua_rotate_image :: proc "c" (L: ^lua.State) -> i32 {


    context = runtime.default_context()
    img:= cast(^ImageData)lua.L_checkudata(L,1,"ImageMT")
    r:= lua.L_checknumber(L,2)
    rl.ImageRotate(&img.image, i32(r))
    return 0

}

lua_rotate_imagecw :: proc "c" (L: ^lua.State) -> i32 {


    context = runtime.default_context()
    img:= cast(^ImageData)lua.L_checkudata(L,1,"ImageMT")

    rl.ImageRotateCW(&img.image)
    return 0

}

lua_rotate_imageccw :: proc "c" (L: ^lua.State) -> i32 {


    context = runtime.default_context()
    img:= cast(^ImageData)lua.L_checkudata(L,1,"ImageMT")

    rl.ImageRotateCCW(&img.image)
    return 0

}


lua_flip_image_vertical :: proc "c" (L: ^lua.State) -> i32 {


    context = runtime.default_context()
    img:= cast(^ImageData)lua.L_checkudata(L,1,"ImageMT")

    rl.ImageFlipVertical(&img.image)
    return 0

}

lua_flip_image_horizontal :: proc "c" (L: ^lua.State) -> i32 {


    context = runtime.default_context()
    img:= cast(^ImageData)lua.L_checkudata(L,1,"ImageMT")
    rl.ImageFlipHorizontal(&img.image)
    return 0

}

lua_blur_image :: proc "c" (L: ^lua.State) -> i32 {


    context = runtime.default_context()
    img:= cast(^ImageData)lua.L_checkudata(L,1,"ImageMT")
    blur := lua.L_checknumber(L,2)
    rl.ImageBlurGaussian(&img.image, i32(blur))
    return 0

}

lua_crop_image :: proc "c" (L: ^lua.State) -> i32 {


	context = runtime.default_context()
	COLOR_ARRAY := colors.COLOR_ARRAY

	img:= cast(^ImageData)lua.L_checkudata(L,1,"ImageMT")
	rect := cast(^shapes.rectangle)lua.L_checkudata(L,2,"RectangleMT")

	rec : rl.Rectangle
	rec.height = rect.height
	rec.width = rect.width
	rec.x = rect.x
	rec.y = rect.y
	rl.ImageCrop(&img.image , rec)

	return 0

}


lua_copy_image :: proc "c" (L: ^lua.State) -> i32 {


	context = runtime.default_context()
	COLOR_ARRAY := colors.COLOR_ARRAY

	img:= cast(^ImageData)lua.L_checkudata(L,1,"ImageMT")

	img2 := cast(^ImageData)lua.newuserdata(L, size_of(ImageData))
	img2.image = rl.ImageCopy(img.image)
	lua.L_setmetatable(L, "ImageMT")
	return 1

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
			fmt.println(" invalid image  %s ", file)
			lua.L_error(L, "invalid image")
			return 0
		}
	}else{

		lua.L_error(L, "invalid file  %s" , file)
		return 0
	}

}

lua_save_image :: proc "c" (L: ^lua.State) -> i32 {


	context = runtime.default_context()
	COLOR_ARRAY := colors.COLOR_ARRAY

	img:= cast(^ImageData)lua.L_checkudata(L,1,"ImageMT")

	file := lua.L_checkstring(L,2)
	res := rl.ExportImage(img.image, file)
	lua.pushboolean(L, b32(res))
	return 1

}


// helper to calculate distance between colors
difference_color :: proc(c1,c2: rl.Color) -> i32 {

    dr := i32(c1.r) - i32(c2.r)
    dg := i32(c1.g) - i32(c2.g)
    db := i32(c1.b) - i32(c2.b)


    dist_ := dr*dr + dg*dg + db*db
    return dist_
}


// checkered pattern
// gen_checkered_image (width, height, checksx, checksy, color, color2 )
lua_gen_checkered_image :: proc "c" (L: ^lua.State) -> i32 {

    context = runtime.default_context()
    COLOR_ARRAY := colors.COLOR_ARRAY
    width_:= i32(lua.L_checkinteger(L,1))
    height_:= i32(lua.L_checkinteger(L,2))
    checksx_:= i32(lua.L_checkinteger(L,3))
    checksy_:= i32(lua.L_checkinteger(L,4))
    color1_:= i32(lua.L_checkinteger(L,5))
    color2_:= i32(lua.L_checkinteger(L,6))

   	img2 := cast(^ImageData)lua.newuserdata(L, size_of(ImageData))
	img2.image = rl.GenImageChecked(width_,height_,checksx_,checksy_,
		COLOR_ARRAY[color1_],COLOR_ARRAY[color2_])
	lua.L_setmetatable(L, "ImageMT")

    return 1

}

// radial gradient
// gen_radial_gradient_image (width, height,density, color, color2 )
lua_gen_radial_gradient_image :: proc "c" (L: ^lua.State) -> i32 {

    context = runtime.default_context()
    COLOR_ARRAY := colors.COLOR_ARRAY
    width_:= i32(lua.L_checkinteger(L,1))
    height_:= i32(lua.L_checkinteger(L,2))
    density:= f32(lua.L_checknumber(L,3))

    color1_:= i32(lua.L_checkinteger(L,4))
    color2_:= i32(lua.L_checkinteger(L,5))

   	img2 := cast(^ImageData)lua.newuserdata(L, size_of(ImageData))
	img2.image = rl.GenImageGradientRadial(width_,height_,density,
		COLOR_ARRAY[color1_],COLOR_ARRAY[color2_])
	lua.L_setmetatable(L, "ImageMT")

    return 1

}

// image cellular
// gen_image_cellular (width, height, tilesize)
l_gen_cellular_image :: proc "c" (L: ^lua.State) -> i32 {

    context = runtime.default_context()

    width_:= i32(lua.L_checkinteger(L,1))
    height_:= i32(lua.L_checkinteger(L,2))
    tilesize:= i32(lua.L_checkinteger(L,3))

   	img2 := cast(^ImageData)lua.newuserdata(L, size_of(ImageData))
	img2.image = rl.GenImageCellular(width_,height_,tilesize)
	lua.L_setmetatable(L, "ImageMT")


    return 1

}

// square gradient
// gen_square_gradient_image (width, height,density, color, color2 )
lua_gen_square_gradient_image :: proc "c" (L: ^lua.State) -> i32 {

    context = runtime.default_context()
    COLOR_ARRAY := colors.COLOR_ARRAY
    width_:= i32(lua.L_checkinteger(L,1))
    height_:= i32(lua.L_checkinteger(L,2))
    density:= f32(lua.L_checknumber(L,3))

    color1_:= i32(lua.L_checkinteger(L,4))
    color2_:= i32(lua.L_checkinteger(L,5))

   	img2 := cast(^ImageData)lua.newuserdata(L, size_of(ImageData))
	img2.image = rl.GenImageGradientSquare(width_,height_,density,
		COLOR_ARRAY[color1_],COLOR_ARRAY[color2_])
	lua.L_setmetatable(L, "ImageMT")

    return 1

}

// crop image
lua_crop :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	COLOR_ARRAY := colors.COLOR_ARRAY

	img:= cast(^ImageData)lua.L_checkudata(L,1,"ImageMT")
	rect:= cast(^shapes.rectangle)lua.L_checkudata(L,2,"RectangleMT")

	rl_:rl.Rectangle
	rl_.height = rect.height
	rl_.width = rect.width
	rl_.x= rect.x
	rl_.y= rect.y

	rl.ImageCrop(&img.image, rl_)
	return 0
}

lua_gen_image_text :: proc "c" (L: ^lua.State) -> i32 {

    context = runtime.default_context()

    width_:= i32(lua.L_checkinteger(L,1))
    height_:= i32(lua.L_checkinteger(L,2))
    text_:= (lua.L_checkstring(L, 3))

   	img2 := cast(^ImageData)lua.newuserdata(L, size_of(ImageData))
	img2.image = rl.GenImageText(width_,height_,text_)
	lua.L_setmetatable(L, "ImageMT")

    return 1

}


lua_gen_image_color :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
		COLOR_ARRAY := colors.COLOR_ARRAY
	img:= cast(^ImageData)lua.newuserdata(L, size_of(ImageData))
	wid:= lua.L_checkinteger(L,1)
	height:= lua.L_checkinteger(L,2)
	col_:= lua.L_checkinteger(L,3)
	image := rl.GenImageColor(i32(wid),i32(height),COLOR_ARRAY[col_])
	img.image = image
	lua.L_getmetatable(L, "ImageMT")
    lua.setmetatable(L, -2)
	return 1
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
	{"save_image", lua_save_image},
	{"gen_image_color", lua_gen_image_color},
	{"dither", lua_dither},
	{"dither_atkinson", lua_atkinson_dither},
	{"dither_jarvis",lua_jarvis_dither},
	{"copy_image", lua_copy_image},
	{"crop_image", lua_crop_image},
	{"flip_image_horizontal", lua_flip_image_horizontal},
	{"flip_image_vertical", lua_flip_image_vertical},
	{"resize_image", lua_resize_image},
	{"rotate_image", lua_rotate_image},
	{"rotate_image_cw", lua_rotate_imagecw},
	{"rotate_image_ccw", lua_rotate_imageccw},
	{"gen_checkered_image", lua_gen_checkered_image },
	{"gen_square_gradient", lua_gen_square_gradient_image },
	{"gen_radial_gradient", lua_gen_radial_gradient_image },
	{"gen_cellular", l_gen_cellular_image  },
	{"gen_text", lua_gen_image_text  },
	// draw
	{"gen_image_blank", lua_gen_image_blank}, // for conveniance
	{"draw_pixel", lua_draw_pixel},
	{"draw_line", lua_draw_line},
	{"draw_circle", lua_draw_circle},
	{"draw_circle_lines", lua_draw_circle_lines},
	{"draw_rectangle", lua_draw_rect},
	{"draw_rectangle_lines", lua_draw_rect_lines},
	{"draw_text", lua_draw_text},
	{"draw_image", lua_draw_image},
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
