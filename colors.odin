package sth10

import rl "vendor:raylib"
import lua "vendor:lua/5.4"
import "core:fmt"
import "base:runtime"


COLOR_ARRAY :: [?]rl.Color{rl.WHITE,rl.BLACK,
    rl.GREEN,rl.LIGHTGRAY,
    rl.GRAY,rl.DARKGRAY,
    rl.YELLOW, rl.GOLD,
    rl.ORANGE, rl.PINK,
    rl.RED,rl.MAROON,
    rl.LIME,
    rl.DARKGREEN,rl.SKYBLUE,
    rl.BLUE,rl.DARKBLUE,
    rl.PURPLE,
    rl.VIOLET,rl.DARKPURPLE,
    rl.BEIGE,rl.DARKBROWN,
    rl.BLANK,rl.MAGENTA,
    rl.RAYWHITE,
    rl.Color{155,188,15,255},
    rl.Color{139,172,15,255},
    rl.Color{48,98,48,255},
    rl.Color{15,56,15,255}
}
ColorEnum :: enum {
	WHITE,
	BLACK,
	GREEN,
	LIGHTGRAY,
	GRAY,
	DARKGRAY,
	YELLOW,
	GOLD,
	ORANGE,
	PINK,
	RED,
	MAROON,
	LIME,
	DARKGREEN,
	SKYBLUE,
	BLUE,
	DARKBLUE,
	PURPLE,
	VIOLET,
	DARKPURPLE,
	BEIGE,
	DARKBROWN,
	BLANK,
	MAGENTA,
	RAYWHITE,
	GB_COLOR1,
	GB_COLOR2,
	GB_COLOR3,
	GB_COLOR4,
}

lua_colorlib := []lua.L_Reg{

    {nil, nil},
}

// Pre-create enum values as global light userdata
luacolor_open :: proc "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()

    lua.L_newlib(L, lua_colorlib)

    // Add enum constants as integers
        lua.pushinteger(L, lua.Integer(ColorEnum.RED))
        lua.setfield(L, -2, "RED")

        lua.pushinteger(L, lua.Integer(ColorEnum.GREEN))
        lua.setfield(L, -2, "GREEN")

        lua.pushinteger(L, lua.Integer(ColorEnum.BLUE))
        lua.setfield(L, -2, "BLUE")

        lua.pushinteger(L, lua.Integer(ColorEnum.YELLOW))
        lua.setfield(L, -2, "YELLOW")

        lua.pushinteger(L, lua.Integer(ColorEnum.PURPLE))
        lua.setfield(L, -2, "PURPLE")

    return 1
}
