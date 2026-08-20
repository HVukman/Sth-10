package colors

import rl "vendor:raylib"
import lua "vendor:lua/5.4"
import "base:runtime"



// colors
//
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
       lua.pushinteger(L, lua.Integer(ColorEnum.WHITE))
       lua.setfield(L, -2, "WHITE")

       lua.pushinteger(L, lua.Integer(ColorEnum.BLACK))
       lua.setfield(L, -2, "BLACK")

    	lua.pushinteger(L, lua.Integer(ColorEnum.RAYWHITE))
        lua.setfield(L, -2, "RAYWHITE")

        lua.pushinteger(L, lua.Integer(ColorEnum.LIGHTGRAY))
        lua.setfield(L, -2, "LIGHTGRAY")

        lua.pushinteger(L, lua.Integer(ColorEnum.GRAY))
        lua.setfield(L, -2, "GRAY")

        lua.pushinteger(L, lua.Integer(ColorEnum.DARKGRAY))
        lua.setfield(L, -2, "DARKGRAY")

        lua.pushinteger(L, lua.Integer(ColorEnum.GOLD))
        lua.setfield(L, -2, "GOLD")

        lua.pushinteger(L, lua.Integer(ColorEnum.ORANGE))
        lua.setfield(L, -2, "ORANGE")

        lua.pushinteger(L, lua.Integer(ColorEnum.PINK))
        lua.setfield(L, -2, "PINK")

        lua.pushinteger(L, lua.Integer(ColorEnum.RED))
        lua.setfield(L, -2, "RED")

        lua.pushinteger(L, lua.Integer(ColorEnum.MAROON))
        lua.setfield(L, -2, "MAROON")

        lua.pushinteger(L, lua.Integer(ColorEnum.LIME))
        lua.setfield(L, -2, "LIME")

        lua.pushinteger(L, lua.Integer(ColorEnum.DARKGREEN))
        lua.setfield(L, -2, "DARKGREEN")

        lua.pushinteger(L, lua.Integer(ColorEnum.GREEN))
        lua.setfield(L, -2, "GREEN")

        lua.pushinteger(L, lua.Integer(ColorEnum.SKYBLUE))
        lua.setfield(L, -2, "SKYBLUE")

        lua.pushinteger(L, lua.Integer(ColorEnum.DARKBLUE))
        lua.setfield(L, -2, "DARKBLUE")

        lua.pushinteger(L, lua.Integer(ColorEnum.BLUE))
        lua.setfield(L, -2, "BLUE")

        lua.pushinteger(L, lua.Integer(ColorEnum.YELLOW))
        lua.setfield(L, -2, "YELLOW")

        lua.pushinteger(L, lua.Integer(ColorEnum.PURPLE))
        lua.setfield(L, -2, "PURPLE")

        lua.pushinteger(L, lua.Integer(ColorEnum.BEIGE))
        lua.setfield(L, -2, "BEUIGE")

        lua.pushinteger(L, lua.Integer(ColorEnum.BLANK))
        lua.setfield(L, -2, "BLANK")

        lua.pushinteger(L, lua.Integer(ColorEnum.DARKPURPLE))
        lua.setfield(L, -2, "DARKPURPLE")

        lua.pushinteger(L, lua.Integer(ColorEnum.DARKBROWN))
        lua.setfield(L, -2, "DARKBROWN")

        lua.pushinteger(L, lua.Integer(ColorEnum.MAGENTA))
        lua.setfield(L, -2, "MAGENTA")

        lua.pushinteger(L, lua.Integer(ColorEnum.GB_COLOR1))
        lua.setfield(L, -2, "GB_COLOR1")

        lua.pushinteger(L, lua.Integer(ColorEnum.GB_COLOR2))
        lua.setfield(L, -2, "GB_COLOR2")

        lua.pushinteger(L, lua.Integer(ColorEnum.GB_COLOR3))
        lua.setfield(L, -2, "GB_COLOR3")

        lua.pushinteger(L, lua.Integer(ColorEnum.GB_COLOR4))
        lua.setfield(L, -2, "GB_COLOR4")

    return 1
}
