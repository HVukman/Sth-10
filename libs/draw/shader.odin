package drawing

import "../colors"
import shapes "../shapes"
import "base:runtime"
import "core:fmt"
import "core:os"
import "core:strings"
import lua "vendor:lua/5.4"
import rl "vendor:raylib"

lua_shader_gc :: proc "c" (L: ^lua.State) -> i32 {

	shader := cast(^rl.Shader)lua.L_checkudata(L, 1, "ShaderMT")
	rl.UnloadShader(shader^)
	return 0

}

// load shader from file
lua_load_shader :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()

	vs_ := lua.isnil(L, 1)
	fs_ := lua.isnil(L, 2)

	if vs_ && fs_ {
		lua.L_error(L, "both arguments nil")
		return 0
	}else if vs_ {
		file := lua.L_checkstring(L, 2)
		if os.is_file(strings.clone_from_cstring(file)) {
			shader := rl.LoadShader(nil,file)
			if rl.IsShaderValid(shader) {
				fmt.printfln("succesfully loaded shader %s", file)
				shader := cast(^rl.Shader)lua.newuserdata(L, size_of(rl.Shader))
				lua.L_setmetatable(L, "ShaderMT")
				return 1
			} else {
				fmt.println(" invalid shader  %s ", file)
				lua.L_error(L, "invalid shader")
				return 0
			}
		} else {

			lua.L_error(L, "invalid file  %s", file)
			return 0
		}

	}else if fs_{
		file := lua.L_checkstring(L, 1)
		if os.is_file(strings.clone_from_cstring(file)) {
			shader := rl.LoadShader(file,nil)
			if rl.IsShaderValid(shader) {
				fmt.printfln("succesfully loaded shader %s", file)
				shader := cast(^rl.Shader)lua.newuserdata(L, size_of(rl.Shader))
				lua.L_setmetatable(L, "ShaderMT")
				return 1
			} else {
				fmt.println(" invalid shader  %s ", file)
				lua.L_error(L, "invalid shader")
				return 0
			}
		} else {

			lua.L_error(L, "invalid file  %s", file)
			return 0
		}
	}else{

		file := lua.L_checkstring(L, 1)
		file2 := lua.L_checkstring(L, 2)
		if os.is_file(strings.clone_from_cstring(file)) {
			shader := rl.LoadShader(file,file2)
			if rl.IsShaderValid(shader) {
				fmt.printfln("succesfully loaded shader %s", file)
				shader := cast(^rl.Shader)lua.newuserdata(L, size_of(rl.Shader))
				lua.L_setmetatable(L, "ShaderMT")
				return 1
			} else {
				fmt.println(" invalid shader  %s ", file)
				lua.L_error(L, "invalid shader")
				return 0
			}
		} else {

			lua.L_error(L, "invalid file  %s", file)
			return 0
		}
	}
	return 1

}


shader_meta := []lua.L_Reg {
	//	{"point", l_draw_point},
	{"__gc", lua_shader_gc},
	{nil, nil},
}
