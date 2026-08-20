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


BLACK_WHITE :: 4
BLACk_WHITE_PALETTE :: [BLACK_WHITE] rl.Color{rl.BLACK,rl.WHITE, rl.RAYWHITE , rl.BLANK}

// https://www.color-hex.com/color-palette/45299
GB_COLORS :: 5
GB_COLOR_ARRAY :: [GB_COLORS]rl.Color { rl.Color{155,188,15,255},rl.Color{139,172,15,255},
        rl.Color{48,98,48,255}, rl.Color{15,56,15,255} , rl.BLANK }



color_enum :: enum{
    COLOR_STANDARD = 0,
    COLOR_BLACK_WHITE = 1,
    COLOR_GB = 2,
}

COLORS_DITHER :: 26
COLOR_ARRAY_DITHER :: [COLORS_DITHER]rl.Color{
    rl.WHITE,rl.BLACK,
    rl.GREEN,rl.LIGHTGRAY,
    rl.GRAY,rl.DARKGRAY,
    rl.YELLOW, rl.GOLD,
    rl.ORANGE, rl.PINK,
    rl.RED,rl.MAROON,
    rl.GREEN,rl.LIME,
    rl.DARKGREEN,rl.SKYBLUE,
    rl.BLUE,rl.DARKBLUE,
    rl.PURPLE,
    rl.VIOLET,rl.DARKPURPLE,
    rl.BEIGE,rl.DARKBROWN,
    rl.BLANK,rl.MAGENTA,
    rl.RAYWHITE,
   /* // 4 gameboy colors
    rl.Color{155,188,15,255},
    rl.Color{139,172,15,255},
    rl.Color{48,98,48,255},
    rl.Color{15,56,15,255}
    */
}


// Image userdata wrapper
ImageData :: struct {
    image: rl.Image,
}

lua_resize_image :: proc "c" (L: ^lua.State) -> i32 {


    context = runtime.default_context()
    img:= cast(^ImageData)lua.L_checkudata(L,1,"ImageMT")
    w:= lua.L_checknumber(L,2)
    h:= lua.L_checknumber(L,2)
    rl.ImageResize(&img.image,i32(w),i32(h))
    return 0

}

lua_blur_image :: proc "c" (L: ^lua.State) -> i32 {


    context = runtime.default_context()
    img:= cast(^ImageData)lua.L_checkudata(L,1,"ImageMT")
    blur := lua.L_checknumber(L,2)
    rl.ImageBlurGaussian(&img.image, i32(blur))
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
			fmt.println("invalid image  %s ", file)
			lua.L_error(L, "invalid image")
			return 0
		}
	}else{

		lua.L_error(L, "invalid file  %s" , file)
		return 0
	}


}

// helper to calculate distance between colors
difference_color :: proc(c1,c2: rl.Color) -> i32 {

    dr := i32(c1.r) - i32(c2.r)
    dg := i32(c1.g) - i32(c2.g)
    db := i32(c1.b) - i32(c2.b)


    dist_ := dr*dr + dg*dg + db*db
    return dist_
}

// find closest palette helper for dither
find_closest_palette_color :: proc (old_: rl.Color, palette: []rl.Color) -> rl.Color{


    palette_len_ := len(palette)
    closest_index := 0
    for i:=0;i<palette_len_;i+=1{

        if difference_color(palette[i],old_) < difference_color(palette[closest_index],old_){
            closest_index = i
        }
    }


    return palette[closest_index]
}




// 4x4 bayered ordered dithering
dithered :: proc (image : rl.Image, palette_int : i32,
    blank_:i32 = 22) -> rl.Image{


    // slicing constants

    col_array := COLOR_ARRAY_DITHER
    bw_palette := BLACk_WHITE_PALETTE
    gb_palette := GB_COLOR_ARRAY

    newcol: rl.Color
    palette : []rl.Color

    switch palette_int{
        case i32(color_enum.COLOR_STANDARD):
            palette = col_array[:]
        case i32(color_enum.COLOR_BLACK_WHITE):
            palette = bw_palette[:]
        case i32(color_enum.COLOR_GB):
            palette = gb_palette[:]
        case :
            palette = col_array[:]
    }


    imagecolors := rl.LoadImageColors(image)
    new_image := rl.GenImageColor(image.width, image.height, rl.BLACK)
    blank_color := col_array[blank_]

    for i:=0;i<int(image.height);i+=1{

        for j:=0;j<int(image.width);j+=1{

            // Calculate index (row-major order)
            index := i * int(image.width) + j

            old_color := imagecolors[index]

            new_col: rl.Color


            new_col = find_closest_palette_color(old_color,  palette)
            imagecolors[index] = new_col
            if (new_col != blank_color){

            quant_error := old_color - new_col
            err_r := f32(old_color.r) - f32(new_col.r)
            err_g := f32(old_color.g) - f32(new_col.g)
            err_b := f32(old_color.b) - f32(new_col.b)

            // right pixel (7/16)
            if j+1<int(image.width){
                weight :f32= 7.0/16.0
                newindex := i * int(image.width) + (j+1)

                r := f32(imagecolors[newindex].r)
                r += err_r * weight
                r = math.clamp(r, 0, 255)
                imagecolors[newindex].r = u8(r)

                g := f32(imagecolors[newindex].g)
                g += err_g * weight
                g = math.clamp(g, 0, 255)
                imagecolors[newindex].g = u8(g)

                b := f32(imagecolors[newindex].b)
                b += err_b * weight
                b = math.clamp(b, 0, 255)
                imagecolors[newindex].b = u8(b)
            }
            // bottom right (1/16)
            if i+1<int(image.height) && j+1<int(image.width){

                weight :f32= 1.0/16.0
                newindex := (i+1) * int(image.width) + (j+1)
                r := f32(imagecolors[newindex].r)
                r += err_r * weight
                r = math.clamp(r, 0, 255)
                imagecolors[newindex].r = u8(r)

                g := f32(imagecolors[newindex].g)
                g += err_g * weight
                g = math.clamp(g, 0, 255)
                imagecolors[newindex].g = u8(g)

                b := f32(imagecolors[newindex].b)
                b += err_b * weight
                b = math.clamp(b, 0, 255)
                imagecolors[newindex].b = u8(b)
            }
            // bottom (5/16)
             if i+1<int(image.height){
                weight :f32= 5.0/16.0
                newindex := (i+1) * int(image.width) + (j)
                r := f32(imagecolors[newindex].r)
                r += err_r * weight
                r = math.clamp(r, 0, 255)
                imagecolors[newindex].r = u8(r)

                g := f32(imagecolors[newindex].g)
                g += err_g * weight
                g = math.clamp(g, 0, 255)
                imagecolors[newindex].g = u8(g)

                b := f32(imagecolors[newindex].b)
                b += err_b * weight
                b = math.clamp(b, 0, 255)
                imagecolors[newindex].b = u8(b)
            }
            // bottom left (3/16)
            if i+1 < int(image.height) && j-1 > 0{
                weight :f32= 3.0/16.0
                newindex := (i+1) * int(image.width) + (j-1)

                r := f32(imagecolors[newindex].r)
                r += err_r * weight
                r = math.clamp(r, 0, 255)
                imagecolors[newindex].r = u8(r)

                g := f32(imagecolors[newindex].g)
                g += err_g * weight
                g = math.clamp(g, 0, 255)
                imagecolors[newindex].g = u8(g)

                b := f32(imagecolors[newindex].b)
                b += err_b * weight
                b = math.clamp(b, 0, 255)
                imagecolors[newindex].b = u8(b)
            }

            }else{
                imagecolors[index] = rl.BLANK
            }

    }
    }

    for i := 0; i < int(new_image.height); i += 1 {
       // fmt.println("i write new", i)
        for j := 0; j < int(new_image.width); j += 1
        {
            index := i * int(new_image.width) + j
            rl.ImageDrawPixel(&new_image, i32(j), i32(i), imagecolors[index])
        }
    }


	return new_image
}

// atkinson dither
atkinson_dither :: proc (image : rl.Image, palette_int : i32,
    blank_:i32 = 22) -> rl.Image{

    // slicing constants

    col_array := COLOR_ARRAY_DITHER
    bw_palette := BLACk_WHITE_PALETTE
    gb_palette := GB_COLOR_ARRAY

    newcol: rl.Color
    palette : []rl.Color

    switch palette_int{
        case i32(color_enum.COLOR_STANDARD):
            palette = col_array[:]
        case i32(color_enum.COLOR_BLACK_WHITE):
            palette = bw_palette[:]
        case i32(color_enum.COLOR_GB):
            palette = gb_palette[:]
        case :
            palette = col_array[:]
    }


    imagecolors := rl.LoadImageColors(image)
    new_image := rl.GenImageColor(image.width, image.height, rl.BLACK)
    blank_color := col_array[blank_]

    for i:=0;i<int(image.height);i+=1{

        for j:=0;j<int(image.width);j+=1{

            // Calculate index (row-major order)
            index := i * int(image.width) + j

            old_color := imagecolors[index]

            new_col: rl.Color


            new_col = find_closest_palette_color(old_color, palette)
            imagecolors[index] = new_col
            if (new_col != blank_color){

            quant_error := old_color - new_col
            err_r := f32(old_color.r) - f32(new_col.r)
            err_g := f32(old_color.g) - f32(new_col.g)
            err_b := f32(old_color.b) - f32(new_col.b)

            weight :f32= 1.0/8.0
            /*
            * is the current point
                     *   1/8  1/8
            .. 1/8  1/8  1/8  ..
            ..      1/8

             6 points dither

            */
            // right pixel
            if j+1<int(image.width){

                newindex := i * int(image.width) + (j+1)
                r := f32(imagecolors[newindex].r)
                r += err_r * weight
                r = math.clamp(r, 0, 255)
                imagecolors[newindex].r = u8(r)

                g := f32(imagecolors[newindex].g)
                g += err_g * weight
                g = math.clamp(g, 0, 255)
                imagecolors[newindex].g = u8(g)

                b := f32(imagecolors[newindex].b)
                b += err_b * weight
                b = math.clamp(b, 0, 255)
                imagecolors[newindex].b = u8(b)
            }
            // second right pixel (7/16)
            if j+2<int(image.width){

                newindex := i * int(image.width) + (j+2)
                r := f32(imagecolors[newindex].r)
                r += err_r * weight
                r = math.clamp(r, 0, 255)
                imagecolors[newindex].r = u8(r)

                g := f32(imagecolors[newindex].g)
                g += err_g * weight
                g = math.clamp(g, 0, 255)
                imagecolors[newindex].g = u8(g)

                b := f32(imagecolors[newindex].b)
                b += err_b * weight
                b = math.clamp(b, 0, 255)
                imagecolors[newindex].b = u8(b)
            }

            // bottom left
            if i+1<int(image.height) && j-1>0{
                newindex := (i+1) * int(image.width) + (j-1)
                r := f32(imagecolors[newindex].r)
                r += err_r * weight
                r = math.clamp(r, 0, 255)
                imagecolors[newindex].r = u8(r)

                g := f32(imagecolors[newindex].g)
                g += err_g * weight
                g = math.clamp(g, 0, 255)
                imagecolors[newindex].g = u8(g)

                b := f32(imagecolors[newindex].b)
                b += err_b * weight
                b = math.clamp(b, 0, 255)
                imagecolors[newindex].b = u8(b)
            }
             // bottom
            if i+1<int(image.height) {
                newindex := (i+1) * int(image.width) + (j)
                r := f32(imagecolors[newindex].r)
                r += err_r * weight
                r = math.clamp(r, 0, 255)
                imagecolors[newindex].r = u8(r)

                g := f32(imagecolors[newindex].g)
                g += err_g * weight
                g = math.clamp(g, 0, 255)
                imagecolors[newindex].g = u8(g)

                b := f32(imagecolors[newindex].b)
                b += err_b * weight
                b = math.clamp(b, 0, 255)
                imagecolors[newindex].b = u8(b)
            }
            // bottom right
            if i+1<int(image.height) && j+1<int(image.width) {
                newindex := (i+1) * int(image.width) + (j+1)
                r := f32(imagecolors[newindex].r)
                r += err_r * weight
                r = math.clamp(r, 0, 255)
                imagecolors[newindex].r = u8(r)

                g := f32(imagecolors[newindex].g)
                g += err_g * weight
                g = math.clamp(g, 0, 255)
                imagecolors[newindex].g = u8(g)

                b := f32(imagecolors[newindex].b)
                b += err_b * weight
                b = math.clamp(b, 0, 255)
                imagecolors[newindex].b = u8(b)
            }
            // second bottom
            if i+2<int(image.height)  {
                newindex := (i+2) * int(image.width) + (j)
                r := f32(imagecolors[newindex].r)
                r += err_r * weight
                r = math.clamp(r, 0, 255)
                imagecolors[newindex].r = u8(r)

                g := f32(imagecolors[newindex].g)
                g += err_g * weight
                g = math.clamp(g, 0, 255)
                imagecolors[newindex].g = u8(g)

                b := f32(imagecolors[newindex].b)
                b += err_b * weight
                b = math.clamp(b, 0, 255)
                imagecolors[newindex].b = u8(b)
            }
            }else{
                imagecolors[index] = rl.BLANK
            }

    }
    }

    for i := 0; i < int(new_image.height); i += 1 {
       // fmt.println("i write new", i)
        for j := 0; j < int(new_image.width); j += 1
        {
            index := i * int(new_image.width) + j
            rl.ImageDrawPixel(&new_image, i32(j), i32(i), imagecolors[index])
        }
    }


	return new_image
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


    return 0

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

lua_atkinson_dither :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	COLOR_ARRAY := colors.COLOR_ARRAY

	img:= cast(^ImageData)lua.L_checkudata(L,1,"ImageMT")

	img2 := cast(^ImageData)lua.newuserdata(L, size_of(ImageData))
	img2.image = atkinson_dither(img.image,0)
	lua.L_setmetatable(L, "ImageMT")
	return 1
}

lua_dither :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	COLOR_ARRAY := colors.COLOR_ARRAY

	img:= cast(^ImageData)lua.L_checkudata(L,1,"ImageMT")

	img2 := cast(^ImageData)lua.newuserdata(L, size_of(ImageData))
	img2.image = dithered(img.image,0)
	lua.L_setmetatable(L, "ImageMT")
	return 1
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
	{"gen_image_color", lua_gen_image_color},
	{"dither", lua_dither},
	{"dither_atkinson", lua_atkinson_dither},
	{"copy_image", lua_copy_image},
	{"crop_image", lua_copy_image},
	{"resize_image", lua_resize_image},
	{"gen_checkered_image", lua_gen_checkered_image },
	{"gen_square_gradient", lua_gen_square_gradient_image },
	{"gen_radial_gradient", lua_gen_radial_gradient_image },
	{"gen_cellular", l_gen_cellular_image  },
	{"gen_text", lua_gen_image_text  },
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
