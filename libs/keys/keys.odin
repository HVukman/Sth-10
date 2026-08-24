package keys

import "base:runtime"
import "core:fmt"
import lua "vendor:lua/5.4"
import rl "vendor:raylib"


KeyEnum :: enum {
	Up    = int(rl.KeyboardKey.UP),
	Down  = int(rl.KeyboardKey.DOWN),
	Left  = int(rl.KeyboardKey.LEFT),
	Right = int(rl.KeyboardKey.RIGHT),
	X     = int(rl.KeyboardKey.X),
	Y     = int(rl.KeyboardKey.Y),
	Z     = int(rl.KeyboardKey.Z),
	A     = int(rl.KeyboardKey.A),
	S     = int(rl.KeyboardKey.S),
	H     = int(rl.KeyboardKey.H),
	P     = int(rl.KeyboardKey.P),
	R    = int(rl.KeyboardKey.R),
	SPACE = int(rl.KeyboardKey.SPACE),
	ENTER = int(rl.KeyboardKey.ENTER),
}

lua_keyrepeat :: proc "c" (L: ^lua.State) -> i32 {


	key := lua.L_checkinteger(L, 1)

	is_pressed := rl.IsKeyPressedRepeat(rl.KeyboardKey(key))
	lua.pushboolean(L, b32(is_pressed))

	return 1
}

lua_keyreleased :: proc "c" (L: ^lua.State) -> i32 {


	key := lua.L_checkinteger(L, 1)

	is_pressed := rl.IsKeyReleased(rl.KeyboardKey(key))
	lua.pushboolean(L, b32(is_pressed))

	return 1
}


lua_keyup :: proc "c" (L: ^lua.State) -> i32 {


	key := lua.L_checkinteger(L, 1)

	is_pressed := rl.IsKeyUp(rl.KeyboardKey(key))
	lua.pushboolean(L, b32(is_pressed))

	return 1
}


lua_keydown :: proc "c" (L: ^lua.State) -> i32 {


	key := lua.L_checkinteger(L, 1)

	is_pressed := rl.IsKeyDown(rl.KeyboardKey(key))
	lua.pushboolean(L, b32(is_pressed))

	return 1
}

lua_keypressed :: proc "c" (L: ^lua.State) -> i32 {


	key := lua.L_checkinteger(L, 1)

	is_pressed := rl.IsKeyPressed(rl.KeyboardKey(key))
	lua.pushboolean(L, b32(is_pressed))

	return 1
}

lua_keylib := []lua.L_Reg{
	{"key_pressed", lua_keypressed},
	{"key_down", lua_keydown},
	{"key_up", lua_keyup},
	{"key_released", lua_keyreleased},
	{"key_repeat", lua_keyrepeat},
 	{nil, nil}
}

luakey_open :: proc "c" (L: ^lua.State) -> i32 {
	context = runtime.default_context()

	lua.L_newlib(L, lua_keylib)

	// Add enum constants as integers
	lua.pushinteger(L, lua.Integer(KeyEnum.Up))
	lua.setfield(L, -2, "UP")

	lua.pushinteger(L, lua.Integer(KeyEnum.Down))
	lua.setfield(L, -2, "DOWN")

	lua.pushinteger(L, lua.Integer(KeyEnum.Left))
	lua.setfield(L, -2, "LEFT")

	lua.pushinteger(L, lua.Integer(KeyEnum.Right))
	lua.setfield(L, -2, "RIGHT")

	lua.pushinteger(L, lua.Integer(KeyEnum.X))
	lua.setfield(L, -2, "X")

	lua.pushinteger(L, lua.Integer(KeyEnum.Y))
	lua.setfield(L, -2, "Y")

	lua.pushinteger(L, lua.Integer(KeyEnum.Z))
	lua.setfield(L, -2, "Z")

	lua.pushinteger(L, lua.Integer(KeyEnum.A))
	lua.setfield(L, -2, "A")

	lua.pushinteger(L, lua.Integer(KeyEnum.S))
	lua.setfield(L, -2, "S")

	lua.pushinteger(L, lua.Integer(KeyEnum.H))
	lua.setfield(L, -2, "H")

	lua.pushinteger(L, lua.Integer(KeyEnum.P))
	lua.setfield(L, -2, "P")

	lua.pushinteger(L, lua.Integer(KeyEnum.R))
	lua.setfield(L, -2, "R")

	lua.pushinteger(L, lua.Integer(KeyEnum.S))
	lua.setfield(L, -2, "S")

	lua.pushinteger(L, lua.Integer(KeyEnum.SPACE))
	lua.setfield(L, -2, "SPACE")

	lua.pushinteger(L, lua.Integer(KeyEnum.ENTER))
	lua.setfield(L, -2, "ENTER")


	return 1
}
