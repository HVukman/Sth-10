package gamepad

import "base:runtime"
import "core:fmt"
import lua "vendor:lua/5.4"
import rl "vendor:raylib"


GamepadEnum :: enum {
	LEFT_FACE_UP = int(rl.GamepadButton.LEFT_FACE_UP),
	RIGHT_FACE_UP = int(rl.GamepadButton.RIGHT_FACE_UP),
	LEFT_FACE_DOWN = int(rl.GamepadButton.LEFT_FACE_DOWN),
	RIGHT_FACE_DOWN = int(rl.GamepadButton.RIGHT_FACE_DOWN),
	LEFT_FACE_LEFT = int(rl.GamepadButton.LEFT_FACE_LEFT),
	RIGHT_FACE_LEFT = int(rl.GamepadButton.RIGHT_FACE_LEFT),
	LEFT_FACE_RIGHT= int(rl.GamepadButton.LEFT_FACE_RIGHT),
	RIGHT_FACE_RIGHT = int(rl.GamepadButton.RIGHT_FACE_RIGHT),
	LEFT_TRIGGER_1 = int(rl.GamepadButton.LEFT_TRIGGER_1),
	LEFT_TRIGGER_2 = int(rl.GamepadButton.LEFT_TRIGGER_2),
	RIGHT_TRIGGER_1 = int(rl.GamepadButton.RIGHT_TRIGGER_1),
	RIGHT_TRIGGER_2 = int(rl.GamepadButton.RIGHT_TRIGGER_2),
	MIDDLE_LEFT = int(rl.GamepadButton.MIDDLE_LEFT),
	MIDDLE_RIGHT = int(rl.GamepadButton.MIDDLE_RIGHT),
	MIDDLE = int(rl.GamepadButton.MIDDLE),
	LEFT_THUMB = int(rl.GamepadButton.LEFT_THUMB),
	RIGHT_THUMB = int(rl.GamepadButton.RIGHT_THUMB),

}

lua_keyrepeat :: proc "c" (L: ^lua.State) -> i32 {


	key := lua.L_checkinteger(L, 1)

	is_pressed := rl.IsKeyPressedRepeat(rl.KeyboardKey(key))
	lua.pushboolean(L, b32(is_pressed))

	return 1
}

lua_gamepad_released:: proc "c" (L: ^lua.State) -> i32 {


	input := i32(lua.L_checkinteger(L,2))
    gamepad := i32(lua.L_checkinteger(L,1))
    res_ := rl.IsGamepadButtonReleased(gamepad,rl.GamepadButton(input))
    lua.pushboolean(L,b32(res_))
    return 1
}


lua_gamepad_up :: proc "c" (L: ^lua.State) -> i32 {


	input := i32(lua.L_checkinteger(L,2))
    gamepad := i32(lua.L_checkinteger(L,1))
    res_ := rl.IsGamepadButtonUp(gamepad,rl.GamepadButton(input))
    lua.pushboolean(L,b32(res_))
    return 1

}



lua_gamepad_down :: proc "c" (L: ^lua.State) -> i32 {


	input := i32(lua.L_checkinteger(L,2))
    gamepad := i32(lua.L_checkinteger(L,1))
    res_ := rl.IsGamepadButtonDown(gamepad,rl.GamepadButton(input))
    lua.pushboolean(L,b32(res_))
    return 1

}

lua_gamepad_pressed :: proc "c" (L: ^lua.State) -> i32 {

	input := i32(lua.L_checkinteger(L,2))
    gamepad := i32(lua.L_checkinteger(L,1))
    res_ := rl.IsGamepadButtonPressed(gamepad,rl.GamepadButton(input))
    lua.pushboolean(L,b32(res_))
    return 1
}

// get the button pressed of any gamepad
lua_get_gamepad_button_pressed :: proc "c" (L:^lua.State) -> i32 {

    lua.pushinteger(L, lua.Integer(rl.GetGamepadButtonPressed()))
    return 1
}

// get internal name of gamepad
lua_get_gamepad_name :: proc "c" (L:^lua.State) -> i32 {
    inp:=i32(lua.L_checkinteger(L,-1))
    res:= rl.GetGamepadName(inp)
    lua.pushstring(L,res)
    return 1
}

// is any gamepad available
lua_is_gamepad_available :: proc "c" (L:^lua.State) -> i32 {

    inp:=lua.L_checkinteger(L,-1)
    res:= rl.IsGamepadAvailable(i32(inp))
    lua.pushboolean(L, b32(res))
    return 1
}

// get axis left strick x of gamepad (integer)
lua_get_gamepad_axis_right_y :: proc "c" (L: ^lua.State) -> i32  {

    gamepad := lua.L_checkinteger(L,-1)
    axis_y := rl.GetGamepadAxisMovement(i32(gamepad), rl.GamepadAxis.RIGHT_Y)
    lua.pushnumber(L, lua.Number(axis_y))
    return 1
}

// get axis left strick x of gamepad (integer)
lua_get_gamepad_axis_right_x :: proc "c" (L: ^lua.State) -> i32  {

    gamepad := lua.L_checkinteger(L,-1)
    axis_x := rl.GetGamepadAxisMovement(i32(gamepad), rl.GamepadAxis.RIGHT_X)
    lua.pushnumber(L, lua.Number(axis_x))
    return 1
}
// get axis left strick x of gamepad "c" (integer)
lua_get_gamepad_axis_left_y :: proc "c" (L: ^lua.State) -> i32  {

    gamepad := lua.L_checkinteger(L,-1)
    axis_y := rl.GetGamepadAxisMovement(i32(gamepad), rl.GamepadAxis.LEFT_Y)
   lua.pushnumber(L, lua.Number(axis_y))
    return 1
}

// get axis left strick x of gamepad (integer)
lua_get_gamepad_axis_left_x :: proc "c" (L: ^lua.State) -> i32  {

    gamepad := lua.L_checkinteger(L,-1)
    axis_x := rl.GetGamepadAxisMovement(i32(gamepad), rl.GamepadAxis.LEFT_X)
    lua.pushnumber(L, lua.Number(axis_x))
    return 1
}


lua_gamepadlib := []lua.L_Reg{
	{"pressed", lua_gamepad_pressed},
	{"down", lua_gamepad_down},
	{"up", lua_gamepad_up},
	{"released", lua_gamepad_released},
	{"get_button_pressed", lua_get_gamepad_button_pressed},
	{"get_name", lua_get_gamepad_name},
	{"get_axis_right_y",lua_get_gamepad_axis_right_y},
	{"get_axis_right_x",lua_get_gamepad_axis_right_x},
	{"get_axis_left_y",lua_get_gamepad_axis_left_y},
	{"get_axis_left_x",lua_get_gamepad_axis_left_x},
	{"is_available",lua_is_gamepad_available},
 	{nil, nil}
}

luagamepad_open :: proc "c" (L: ^lua.State) -> i32 {
	context = runtime.default_context()

	lua.L_newlib(L, lua_gamepadlib )

	// Add enum constants as integers
	lua.pushinteger(L, lua.Integer(GamepadEnum.LEFT_FACE_UP))
	lua.setfield(L, -2, "LEFT_FACE_UP")

	lua.pushinteger(L, lua.Integer(GamepadEnum.LEFT_FACE_DOWN))
	lua.setfield(L, -2, "LEFT_FACE_DOWN")

	lua.pushinteger(L, lua.Integer(GamepadEnum.LEFT_FACE_LEFT))
	lua.setfield(L, -2, "LEFT_FACE_LEFT")

	lua.pushinteger(L, lua.Integer(GamepadEnum.LEFT_FACE_RIGHT))
	lua.setfield(L, -2, "LEFT_FACE_RIGHT")

	lua.pushinteger(L, lua.Integer(GamepadEnum.RIGHT_FACE_UP))
	lua.setfield(L, -2, "RIGHT_FACE_UP")

	lua.pushinteger(L, lua.Integer(GamepadEnum.RIGHT_FACE_DOWN))
	lua.setfield(L, -2, "RIGHT_FACE_DOWN")

	lua.pushinteger(L, lua.Integer(GamepadEnum.RIGHT_FACE_LEFT))
	lua.setfield(L, -2, "RIGHT_FACE_LEFT")

	lua.pushinteger(L, lua.Integer(GamepadEnum.RIGHT_FACE_RIGHT))
	lua.setfield(L, -2, "RIGHT_FACE_RIGHT")

	lua.pushinteger(L, lua.Integer(GamepadEnum.LEFT_TRIGGER_1))
	lua.setfield(L, -2, "LEFT_TRIGGER_1")

	lua.pushinteger(L, lua.Integer(GamepadEnum.LEFT_TRIGGER_2))
	lua.setfield(L, -2, "LEFT_TRIGGER_2")

	lua.pushinteger(L, lua.Integer(GamepadEnum.RIGHT_TRIGGER_1))
	lua.setfield(L, -2, "RIGHT_TRIGGER_1")

	lua.pushinteger(L, lua.Integer(GamepadEnum.RIGHT_TRIGGER_2))
	lua.setfield(L, -2, "RIGHT_TRIGGER_2")

	lua.pushinteger(L, lua.Integer(GamepadEnum.MIDDLE))
	lua.setfield(L, -2, "MIDDLE")

	lua.pushinteger(L, lua.Integer(GamepadEnum.MIDDLE_LEFT))
	lua.setfield(L, -2, "MIDDLE_LEFT")

	lua.pushinteger(L, lua.Integer(GamepadEnum.MIDDLE_RIGHT))
	lua.setfield(L, -2, "MIDDLE_RIGHT")

	lua.pushinteger(L, lua.Integer(GamepadEnum.LEFT_THUMB))
	lua.setfield(L, -2, "LEFT_THUMB")

	lua.pushinteger(L, lua.Integer(GamepadEnum.RIGHT_THUMB))
	lua.setfield(L, -2, "RIGHT_THUMB")


	return 1
}
