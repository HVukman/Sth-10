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

lua_gen_image_blank :: proc "c" (L:^lua.State) -> i32 {

	context = runtime.default_context()

    width_:= i32(lua.L_checkinteger(L,1))
    height_:= i32(lua.L_checkinteger(L,2))

   	img := cast(^ImageData)lua.newuserdata(L, size_of(ImageData))
    img.image.width = width_
    img.image.height = height_

    lua.L_setmetatable(L, "ImageMT")

    return 1

}


lua_draw_pixel :: proc "c" (L: ^lua.State) -> i32 {


    context = runtime.default_context()
    img:= cast(^ImageData)lua.L_checkudata(L,1,"ImageMT")
    p_:= cast(^shapes.point)lua.L_checkudata(L,2,"PointMT")

    col_ := lua.L_checknumber(L,3)
    COLOR_ARRAY := colors.COLOR_ARRAY
    rl.ImageDrawPixel(&img.image, i32(p_.x),i32(p_.y), COLOR_ARRAY[int(col_)])

    return 0

}


// draw line between two points
lua_draw_line :: proc "c" (L: ^lua.State) -> i32 {


    context = runtime.default_context()
    img:= cast(^ImageData)lua.L_checkudata(L,1,"ImageMT")
    p_:= cast(^shapes.point)lua.L_checkudata(L,2,"PointMT")
    p2_:= cast(^shapes.point)lua.L_checkudata(L,3,"PointMT")
    col_ := lua.L_checknumber(L,4)


    COLOR_ARRAY := colors.COLOR_ARRAY
    rl.ImageDrawLine(&img.image, i32(p_.x),i32(p_.y),  i32(p2_.x),i32(p2_.y), COLOR_ARRAY[int(col_)])

    return 0

}

// draw circle
lua_draw_circle :: proc "c" (L: ^lua.State) -> i32 {


    context = runtime.default_context()
    img:= cast(^ImageData)lua.L_checkudata(L,1,"ImageMT")
    c_:= cast(^shapes.circle)lua.L_checkudata(L,2,"CircleMT")

    col_ := lua.L_checknumber(L,3)


    COLOR_ARRAY := colors.COLOR_ARRAY
    rl.ImageDrawCircle(&img.image,
    	i32(c_.x),i32(c_.y),  i32(c_.radius), COLOR_ARRAY[int(col_)])

    return 0

}

// draw circle lines
lua_draw_circle_lines :: proc "c" (L: ^lua.State) -> i32 {


    context = runtime.default_context()
    img:= cast(^ImageData)lua.L_checkudata(L,1,"ImageMT")
    c_:= cast(^shapes.circle)lua.L_checkudata(L,2,"CircleMT")

    col_ := lua.L_checknumber(L,3)


    COLOR_ARRAY := colors.COLOR_ARRAY
    rl.ImageDrawCircleLines(&img.image,
    	i32(c_.x),i32(c_.y),  i32(c_.radius), COLOR_ARRAY[int(col_)])

    return 0

}

// draw rect
lua_draw_rect :: proc "c" (L: ^lua.State) -> i32 {


    context = runtime.default_context()
    img:= cast(^ImageData)lua.L_checkudata(L,1,"ImageMT")
    r_:= cast(^shapes.rectangle)lua.L_checkudata(L,2,"RectangleMT")

    col_ := lua.L_checknumber(L,3)


    COLOR_ARRAY := colors.COLOR_ARRAY
    rl.ImageDrawRectangle(&img.image,
    	i32(r_.x),i32(r_.y),  i32(r_.width), i32(r_.height), COLOR_ARRAY[int(col_)])

    return 0

}

// draw rect lines
lua_draw_rect_lines :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
    img:= cast(^ImageData)lua.L_checkudata(L,1,"ImageMT")
    r_:= cast(^shapes.rectangle)lua.L_checkudata(L,2,"RectangleMT")

    thick_ :=  lua.L_checknumber(L,3)
    col_ := lua.L_checknumber(L,4)

    rec: rl.Rectangle

    rec.x = r_.x
    rec.y = r_.y
    rec.width = r_.width
    rec.height = r_.height

    COLOR_ARRAY := colors.COLOR_ARRAY
    rl.ImageDrawRectangleLines(&img.image,
    	rec,i32(thick_), COLOR_ARRAY[int(col_)])

    return 0

}

// draw text at point
lua_draw_text :: proc "c" (L: ^lua.State) -> i32 {


    context = runtime.default_context()
    img:= cast(^ImageData)lua.L_checkudata(L,1,"ImageMT")
    text_ := lua.L_checkstring(L,2)
    p_:= cast(^shapes.point)lua.L_checkudata(L,3,"PointMT")
    fontsize_ := lua.L_checknumber(L,4)
    col_ := lua.L_checknumber(L,5)


    COLOR_ARRAY := colors.COLOR_ARRAY
    rl.ImageDrawText(&img.image, text_, i32(p_.x),i32(p_.y),  i32(fontsize_), COLOR_ARRAY[int(col_)])

    return 0

}

// draw image at point in circle
lua_draw_image :: proc "c" (L: ^lua.State) -> i32 {


    context = runtime.default_context()
    img:= cast(^ImageData)lua.L_checkudata(L,1,"ImageMT")
    sourceimg:= cast(^ImageData)lua.L_checkudata(L,2,"ImageMT")

     r_:= cast(^shapes.rectangle)lua.L_checkudata(L,3,"RectangleMT")
     rdest_:= cast(^shapes.rectangle)lua.L_checkudata(L,4,"RectangleMT")

    col_ := lua.L_checknumber(L,5)

    sourcerect : rl.Rectangle
    sourcerect.x=r_.x
    sourcerect.y = r_.y
    sourcerect.height = r_.height
    sourcerect.width = r_.width

    destrect : rl.Rectangle
    destrect.x = rdest_.x
    destrect.y = rdest_.y
    destrect.width = rdest_.width
    destrect.height = rdest_.height


    COLOR_ARRAY := colors.COLOR_ARRAY
    rl.ImageDraw(&img.image, sourceimg.image, sourcerect,destrect, COLOR_ARRAY[int(col_)])

    return 0

}
