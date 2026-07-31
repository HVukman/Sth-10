package sth10

// Source:
// https://martin-fieber.de/blog/cpp-and-lua/#user-data

import "core:fmt"
import lua "vendor:lua/5.4" // or whatever version you want
import "core:c/libc"
import "base:runtime"


lua_newpoint :: proc "c" (L: ^lua.State) -> i32  {

	return 0
}

lua_openpoint :: proc "c" (L: ^lua.State) -> i32  {


	lua.newtable(L)
	lua.pushvalue(L,-1)
	lua.setfield(L,-2,"__index")


	return 0
}
