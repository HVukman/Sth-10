package images

// draw stuff
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

// jarvis-Judice-Ninke
jarvis_judice_ninke_dither :: proc (image : rl.Image, palette_int : i32,
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

            weight :f32 = 1.0/48.0

            /*
            * is the current point


                          *   7   5
           1/48* .. 3  5  7   5   3
                 .. 1  3  5   3   1

             12 points dither

            */
            // right pixel 7/48
            newindex :int


            	weight1 := 7 *weight
                newindex = (i * int(image.width) + (j+1))%int(image.width)
                r := f32(imagecolors[newindex].r)
                r += err_r * weight1
                r = math.clamp(r, 0, 255)
                imagecolors[newindex].r = u8(r)

                g := f32(imagecolors[newindex].g)
                g += err_g * weight1
                g = math.clamp(g, 0, 255)
                imagecolors[newindex].g = u8(g)

                b := f32(imagecolors[newindex].b)
                b += err_b * weight1
                b = math.clamp(b, 0, 255)
                imagecolors[newindex].b = u8(b)

            // second right pixel (5/48)

            	weight2 := 5* weight
                newindex = (i * int(image.width) + (j+2) )%int(image.width)
                r = f32(imagecolors[newindex].r)
                r += err_r * weight
                r = math.clamp(r, 0, 255)
                imagecolors[newindex].r = u8(r)

                g = f32(imagecolors[newindex].g)
                g += err_g * weight
                g = math.clamp(g, 0, 255)
                imagecolors[newindex].g = u8(g)

                b = f32(imagecolors[newindex].b)
                b += err_b * weight
                b = math.clamp(b, 0, 255)
                imagecolors[newindex].b = u8(b)


            // bottom left (3/48)

            	newindex = ( (i+1) * int(image.width)%int(image.width) + (j-2)%int(image.height) )
             	weight3 := 3* weight
                r = f32(imagecolors[newindex].r)
                r += err_r * weight3
                r = math.clamp(r, 0, 255)
                imagecolors[newindex].r = u8(r)

                g = f32(imagecolors[newindex].g)
                g += err_g * weight
                g = math.clamp(g, 0, 255)
                imagecolors[newindex].g = u8(g)

                b = f32(imagecolors[newindex].b)
                b += err_b * weight3
                b = math.clamp(b, 0, 255)
                imagecolors[newindex].b = u8(b)

                // bottom left (5/48)

               	newindex = ( (i+1) * int(image.width)%int(image.width) + (j-2)%int(image.height) )
                weight4 := 5* weight
                r = f32(imagecolors[newindex].r)
                r += err_r * weight4
                r = math.clamp(r, 0, 255)
                imagecolors[newindex].r = u8(r)

                g = f32(imagecolors[newindex].g)
                g += err_g * weight4
                g = math.clamp(g, 0, 255)
                imagecolors[newindex].g = u8(g)

                b = f32(imagecolors[newindex].b)
                b += err_b * weight4
                b = math.clamp(b, 0, 255)
                imagecolors[newindex].b = u8(b)

                // bottom (7/48)

                weight5 := 7* weight
                newindex = ( (i+1) * int(image.width)%int(image.width) + (j)%int(image.height) )

                r = f32(imagecolors[newindex].r)
                r = err_r * weight5
                r = math.clamp(r, 0, 255)
                imagecolors[newindex].r = u8(r)

                g = f32(imagecolors[newindex].g)
                g = err_g * weight5
                g = math.clamp(g, 0, 255)
                imagecolors[newindex].g = u8(g)

                b = f32(imagecolors[newindex].b)
                b = err_b * weight5
                b = math.clamp(b, 0, 255)
                imagecolors[newindex].b = u8(b)

                // bottom right (5/48)

                weight6 := 5* weight
                newindex = ( (i+1) * int(image.width)%int(image.width) + (j+1)%int(image.height) )


                r = f32(imagecolors[newindex].r)
                r += err_r * weight6
                r = math.clamp(r, 0, 255)
                imagecolors[newindex].r = u8(r)

                g = f32(imagecolors[newindex].g)
                g += err_g * weight6
                g = math.clamp(g, 0, 255)
                imagecolors[newindex].g = u8(g)

                b = f32(imagecolors[newindex].b)
                b += err_b * weight6
                b = math.clamp(b, 0, 255)
                imagecolors[newindex].b = u8(b)

                // bottom right (3/48)

                weight7 := 3* weight
                newindex = ( (i+1) * int(image.width)%int(image.width) + (j+2)%int(image.height) )

                r = f32(imagecolors[newindex].r)
                r += err_r * weight7
                r = math.clamp(r, 0, 255)
                imagecolors[newindex].r = u8(r)

                g = f32(imagecolors[newindex].g)
                g += err_g * weight7
                g = math.clamp(g, 0, 255)
                imagecolors[newindex].g = u8(g)

                b = f32(imagecolors[newindex].b)
                b += err_b * weight7
                b = math.clamp(b, 0, 255)
                imagecolors[newindex].b = u8(b)

                //second  bottom right (1/48)

                weight8 := weight
                newindex = ( (i+2) * int(image.width)%int(image.width) + (j-2)%int(image.height) )

                r = f32(imagecolors[newindex].r)
                r += err_r * weight8
                r = math.clamp(r, 0, 255)
                imagecolors[newindex].r = u8(r)

                g = f32(imagecolors[newindex].g)
                g += err_g * weight8
                g = math.clamp(g, 0, 255)
                imagecolors[newindex].g = u8(g)

                b = f32(imagecolors[newindex].b)
                b += err_b * weight8
                b = math.clamp(b, 0, 255)
                imagecolors[newindex].b = u8(b)

                //second  bottom right (3/48)

                weight9 := 3*weight
                newindex = ( (i+2) * int(image.width)%int(image.width) + (j-1)%int(image.height) )

                r = f32(imagecolors[newindex].r)
                r += err_r * weight9
                r = math.clamp(r, 0, 255)
                imagecolors[newindex].r = u8(r)

                g = f32(imagecolors[newindex].g)
                g += err_g * weight9
                g = math.clamp(g, 0, 255)
                imagecolors[newindex].g = u8(g)

                b = f32(imagecolors[newindex].b)
                b += err_b * weight9
                b = math.clamp(b, 0, 255)
                imagecolors[newindex].b = u8(b)

                //second  bottom (5/48)

                weight10 := 5*weight
                newindex = ( (i+2) * int(image.width)%int(image.width) + (j)%int(image.height) )

                r = f32(imagecolors[newindex].r)
                r += err_r * weight10
                r = math.clamp(r, 0, 255)
                imagecolors[newindex].r = u8(r)

                g = f32(imagecolors[newindex].g)
                g += err_g * weight10
                g = math.clamp(g, 0, 255)
                imagecolors[newindex].g = u8(g)

                b = f32(imagecolors[newindex].b)
                b += err_b * weight10
                b = math.clamp(b, 0, 255)
                imagecolors[newindex].b = u8(b)


                //second  bottom right(3/48)

                weight11 := 3*weight
                newindex = ( (i+2) * int(image.width)%int(image.width) + (j+1)%int(image.height) )

                r = f32(imagecolors[newindex].r)
                r += err_r * weight11
                r = math.clamp(r, 0, 255)
                imagecolors[newindex].r = u8(r)

                g = f32(imagecolors[newindex].g)
                g += err_g * weight11
                g = math.clamp(g, 0, 255)
                imagecolors[newindex].g = u8(g)

                b = f32(imagecolors[newindex].b)
                b += err_b * weight11
                b = math.clamp(b, 0, 255)
                imagecolors[newindex].b = u8(b)

                 //second  bottom right and one (1/48)
                 //
                weight12 := weight
                newindex = ( (i+2) * int(image.width)%int(image.width) + (j+2)%int(image.height) )

                r = f32(imagecolors[newindex].r)
                r += err_r * weight12
                r = math.clamp(r, 0, 255)
                imagecolors[newindex].r = u8(r)

                g = f32(imagecolors[newindex].g)
                g += err_g * weight12
                g = math.clamp(g, 0, 255)
                imagecolors[newindex].g = u8(g)

                b = f32(imagecolors[newindex].b)
                b += err_b * weight12
                b = math.clamp(b, 0, 255)
                imagecolors[newindex].b = u8(b)


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

lua_jarvis_dither :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	COLOR_ARRAY := colors.COLOR_ARRAY

	img:= cast(^ImageData)lua.L_checkudata(L,1,"ImageMT")

	palettebool := lua.isnoneornil(L,2)

	palette: i32

	if !(palettebool){
		palette= i32(lua.L_checkinteger(L,2))
	}else{
		palette = 0
	}

	img2 := cast(^ImageData)lua.newuserdata(L, size_of(ImageData))
	img2.image = jarvis_judice_ninke_dither(img.image,palette)
	lua.L_setmetatable(L, "ImageMT")
	return 1
}


lua_atkinson_dither :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	COLOR_ARRAY := colors.COLOR_ARRAY

	img:= cast(^ImageData)lua.L_checkudata(L,1,"ImageMT")

	palettebool := lua.isnoneornil(L,2)

	palette: i32

	if !(palettebool){
		palette= i32(lua.L_checkinteger(L,2))
	}else{
		palette = 0
	}

	img2 := cast(^ImageData)lua.newuserdata(L, size_of(ImageData))
	img2.image = atkinson_dither(img.image,palette)
	lua.L_setmetatable(L, "ImageMT")
	return 1
}

lua_dither :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	COLOR_ARRAY := colors.COLOR_ARRAY

	img:= cast(^ImageData)lua.L_checkudata(L,1,"ImageMT")

	palettebool := lua.isnoneornil(L,2)

	palette: i32

	if !(palettebool){
		palette= i32(lua.L_checkinteger(L,2))
	}else{
		palette = 0
	}

	img2 := cast(^ImageData)lua.newuserdata(L, size_of(ImageData))
	img2.image = dithered(img.image,palette)
	lua.L_setmetatable(L, "ImageMT")
	return 1
}
