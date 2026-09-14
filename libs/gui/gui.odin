package gui


import "core:fmt"
import lua "vendor:lua/5.4"
import "core:c/libc"
import "base:runtime"
import rl "vendor:raylib"
import "core:strings"
import "core:os"

import shapes "../shapes"
import colors "../colors"

lua_colorpicker :: proc"c"(L: ^lua.State) -> i32{


	context = runtime.default_context()
    rect_ := cast(^shapes.rectangle)lua.L_checkudata(L, 1, "RectangleMT")
   // lua.L_argcheck(L, rect_ != nil, 1, "Rectangle Expected")
    text := lua.L_checkstring(L, 2)

    col_ := i32(lua.L_checknumber(L,3))
    COLOR_ARRAY := colors.COLOR_ARRAY
    rect := rl.Rectangle{rect_.x,rect_.y,rect_.width,rect_.height}


    color_ := COLOR_ARRAY[col_]
    pick:= rl.GuiColorPicker(rect,text,&color_)

    return 1

}

lua_checkbox :: proc"c"(L: ^lua.State) -> i32{


	context = runtime.default_context()
    rect_ := cast(^shapes.rectangle)lua.L_checkudata(L, 1, "RectangleMT")
   // lua.L_argcheck(L, rect_ != nil, 1, "Rectangle Expected")
    text := lua.L_checkstring(L, 2)
    buul := bool(lua.toboolean(L, 3))
    rect := rl.Rectangle{rect_.x,rect_.y,rect_.width,rect_.height}
    res :=  rl.GuiCheckBox(rect,text, &buul)

    lua.pushboolean(L,b32(buul))


    return 1

}


// draw rectangle as button
// reuturns true if clicked
lua_button :: proc"c"(L: ^lua.State) -> i32{


	context = runtime.default_context()
    rect_ := cast(^shapes.rectangle)lua.L_checkudata(L, 1, "RectangleMT")
   // lua.L_argcheck(L, rect_ != nil, 1, "Rectangle Expected")
    text := lua.L_checkstring(L, 2)
    rect := rl.Rectangle{rect_.x,rect_.y,rect_.width,rect_.height}
    res :=  rl.GuiButton(rect,text)
    lua.pushboolean(L,b32(rl.GuiButton(rect,text)))
    return 1

}


lua_guilib := []lua.L_Reg{
	{"colorpicker", lua_colorpicker},
	{"checkbox", lua_checkbox},
	{"button", lua_button},
    {nil, nil},
}

luagui_open :: proc "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()
    lua.L_newlib(L, lua_guilib)

    return 1
}
