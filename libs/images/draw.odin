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
