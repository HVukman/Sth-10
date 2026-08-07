package sth10

import rl "vendor:raylib"
import lua "vendor:lua/5.4"
import "core:fmt"
import "base:runtime"

KEY_ARRAY :: [?]rl.KeyboardKey{rl.KeyboardKey.UP,rl.KeyboardKey.DOWN,rl.KeyboardKey.LEFT,rl.KeyboardKey.RIGHT}

KeyEnum :: enum {
	Up = int(rl.KeyboardKey.UP),
	Down = int(rl.KeyboardKey.DOWN),
	Left = int(rl.KeyboardKey.LEFT),
	Right = int(rl.KeyboardKey.RIGHT),
}

lua_keypressed :: proc "c" (L: ^lua.State) -> i32 {


	key := lua.L_checkinteger(L,1)

	is_pressed:= rl.IsKeyPressed(rl.KeyboardKey(key))
	lua.pushboolean(L,b32(is_pressed))

	return 1
}

lua_keylib := []lua.L_Reg{
	{"key_pressed", lua_keypressed},
    {nil, nil},
}

luakey_open :: proc "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()

    lua.L_newlib(L, lua_keylib)

    // Add enum constants as integers
       lua.pushinteger(L, lua.Integer(KeyEnum.Up))
       lua.setfield(L, -2, "UP")

       // Add enum constants as integers
          lua.pushinteger(L, lua.Integer(KeyEnum.Down))
          lua.setfield(L, -2, "DOWN")

          // Add enum constants as integers
             lua.pushinteger(L, lua.Integer(KeyEnum.Left))
             lua.setfield(L, -2, "LEFT")

             // Add enum constants as integers
                lua.pushinteger(L, lua.Integer(KeyEnum.Right))
                lua.setfield(L, -2, "Right")

       return 1
   }
