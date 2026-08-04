package sth10

import rl "vendor:raylib"
import lua "vendor:lua/5.4"
import "core:fmt"

register :: proc (L: ^lua.State) {


	lua.L_openlibs(L); // Load Lua standard libraries

}
