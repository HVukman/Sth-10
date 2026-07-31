package sth10

// Source:
// https://martin-fieber.de/blog/cpp-and-lua/#user-data

import "core:fmt"
import lua "vendor:lua/5.4" // or whatever version you want
import "core:c/libc"
import "base:runtime"
import rl "vendor:raylib"

point :: distinct rl.Vector2
rectangle :: distinct rl.Rectangle
circle :: struct {
	x:f32,
	y:f32,
	radius:f32,
}
triangle :: struct {
	p1:point,
	p2:point,
	p3:point,
}

mat2 :: distinct matrix[2, 2]f32
mat4 :: distinct matrix[4, 4]f32


lua_newpoint :: proc "c" (L: ^lua.State) -> i32  {

	return 0
}

lua_openpoint :: proc "c" (L: ^lua.State) -> i32  {


	lua.newtable(L)
	lua.pushvalue(L,-1)
	lua.setfield(L,-2,"__index")


	return 0
}
