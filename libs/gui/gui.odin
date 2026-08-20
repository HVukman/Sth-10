package gui


import "core:fmt"
import lua "vendor:lua/5.4"
import "core:c/libc"
import "base:runtime"
import rl "vendor:raylib"
import "core:strings"
import "core:os"

import shapes "../shapes"
// draw rectangle as button
// reuturns true if clicked
//
lua_button :: proc"c"(L: ^lua.State) -> i32{


	context = runtime.default_context()
	fmt.println("butt1")

    rect_ := cast(^shapes.rectangle)lua.L_checkudata(L, 1, "RectMT")

    lua.L_argcheck(L, rect_ != nil, 1, "Rectangle Expected")
    fmt.println("butt2")
    text := lua.L_checkstring(L, 2)
    rect := rl.Rectangle{rect_.x,rect_.y,rect_.width,rect_.height}
    fmt.println("butt")
    res := rl.GuiButton(rect,text)
    fmt.println("butt2")
    lua.pushboolean(L,b32(rl.GuiButton(rect,text)))
    return 1

}


lua_guilib := []lua.L_Reg{
	{"button", lua_button},
    {nil, nil},
}

luagui_open :: proc "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()
    lua.L_newlib(L, lua_guilib)

    return 1
}
