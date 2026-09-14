package shader


import "core:fmt"
import lua "vendor:lua/5.4"

import "base:runtime"
import rl "vendor:raylib"
import "core:strings"
import "core:os"
import "core:math/linalg"



ShaderWrap :: struct {
	shader : rl.Shader,
}

newmat3x3 :: struct{
	mat:linalg.Matrix3f32,
}

lua_end_shader_mode :: proc "c"(L: ^lua.State) -> i32 {

	rl.EndShaderMode()
	return 0
}

lua_begin_shader_mode :: proc "c"(L: ^lua.State) -> i32 {

	shd:= cast(^ShaderWrap)lua.L_checkudata(L, 1 , "ShaderMT")
	rl.BeginShaderMode(shd.shader)
	return 0
}

lua_load_shader :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	vs := lua.isnoneornil(L,1)
	fs := lua.isnoneornil(L,2)

	// if both nil
	if vs && fs {
		lua.L_error(L,"no valid parameters for load shader")
		return 0
	}
	else {
		// if vs is not nil
		if !(vs){
			file := lua.L_checkstring(L,1)
			if os.is_file(strings.clone_from_cstring(file)) {
				vs_shader := rl.LoadShader(file,nil)
				if rl.IsShaderValid(vs_shader){
					fmt.printfln("succesfully loaded shader %s", file)
					shd:= cast(^ShaderWrap)lua.newuserdata(L, size_of(ShaderWrap))
					shd.shader = vs_shader
					lua.L_setmetatable(L, "ShaderMT")
					// return shader
					return 1
				}else{

					lua.L_error(L, "invalid shader %s ", file)
					return 0
				}
			}else{

				lua.L_error(L, "invalid file  %s" , file)
				return 0
			}
		}else if vs && !fs { // if only fs (is this relevant?)
			file := lua.L_checkstring(L,2)
			if os.is_file(strings.clone_from_cstring(file)) {
				fs_shader := rl.LoadShader(nil,file)
				if rl.IsShaderValid(fs_shader){
					fmt.printfln("succesfully loaded shader %s", file)
					shd:= cast(^ShaderWrap)lua.newuserdata(L, size_of(ShaderWrap))
					shd.shader = fs_shader
					lua.L_setmetatable(L, "ShaderMT")
					return 1
				}else{

					lua.L_error(L, "invalid shader %s ", file)
					return 0
				}
			}else{

				lua.L_error(L, "invalid file  %s" , file)
				return 0
			}
		}else { //
			filevs := lua.L_checkstring(L,1)
			filefs := lua.L_checkstring(L,2)
			if os.is_file(strings.clone_from_cstring(filevs)) && os.is_file(strings.clone_from_cstring(filefs))  {
				fsvs_shader := rl.LoadShader(filevs,filefs)
				if rl.IsShaderValid(fsvs_shader){
					fmt.printfln("succesfully loaded shader %s %s", filevs, filefs)
					shd:= cast(^ShaderWrap)lua.newuserdata(L, size_of(ShaderWrap))
					shd.shader = fsvs_shader
					lua.L_setmetatable(L, "ShaderMT")
					return 1
				}else{

					lua.L_error(L, "invalid shader %s %s", filevs , filefs)
					return 0
				}
			}else{

				lua.L_error(L, "invalid files %s %s" , filevs , filefs)
				return 0
			}
		}

	}
	return 0

}


lua_shader_valid :: proc "c"(L: ^lua.State) -> i32 {

	shd:= cast(^ShaderWrap)lua.L_checkudata(L, 1 , "ShaderMT")
	res := rl.IsShaderValid(shd.shader)
	lua.pushboolean(L,b32(res))
	return 1
}

lua_get_shader_location :: proc "c"(L: ^lua.State) -> i32 {

	shd:= cast(^ShaderWrap)lua.L_checkudata(L, 1 , "ShaderMT")
	uniform := lua.L_checkstring(L,2)
	res := rl.GetShaderLocation(shd.shader, uniform)
	lua.pushinteger(L, lua.Integer(res))
	return 1
}

lua_get_shader_location_attribute :: proc "c"(L: ^lua.State) -> i32 {

	shd:= cast(^ShaderWrap)lua.L_checkudata(L, 1 , "ShaderMT")
	uniform := lua.L_checkstring(L,2)
	res := rl.GetShaderLocationAttrib(shd.shader, uniform)
	lua.pushinteger(L, lua.Integer(res))
	return 1
}


lua_shader_gc :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	shd:= cast(^ShaderWrap)lua.L_checkudata(L, 1 , "ShaderMT")
	rl.UnloadShader(shd.shader)
	return 0
}

shader_elem_count :: proc ( type: int) -> int {
	type := rl.ShaderUniformDataType(type)
    #partial switch (type) {

        case rl.ShaderUniformDataType.VEC2:
        	fallthrough
        case rl.ShaderUniformDataType.IVEC2:
        	return 2
        case rl.ShaderUniformDataType.VEC3:
        	fallthrough
        case rl.ShaderUniformDataType.IVEC3:
        	return 3;
        case rl.ShaderUniformDataType.VEC4:
        	fallthrough
        case rl.ShaderUniformDataType.IVEC4:
        	return 4;
        case:
        	return 1;
        // FLOAT, INT, SAMPLER2D
    }
}

shader_is_int :: proc( type:int) -> bool{
	type := rl.ShaderUniformDataType(type)
    val:= (type == rl.ShaderUniformDataType.INT || type == rl.ShaderUniformDataType.IVEC2 ||
            type == rl.ShaderUniformDataType.IVEC3 || type == rl.ShaderUniformDataType.IVEC4 ||
            type ==  rl.ShaderUniformDataType.SAMPLER2D)
    return val
}


// void SetShaderValue(Shader shader, int locIndex, const void *value, int uniformType);
lua_set_shader_value :: proc "c"(L: ^lua.State) -> i32 {

	context = runtime.default_context()
	shd:= cast(^ShaderWrap)lua.L_checkudata(L, 1 , "ShaderMT")

	loc := lua.L_checknumber(L,2)
	type := lua.L_checknumber(L,4)

	n := shader_elem_count(int(type))

	if (shader_is_int(int(type))) {
        buf := [4]int{0, 0, 0, 0}
        if (lua.istable(L, 3)) {
            for i := 0; i < n; i+=1 {
            lua.rawgeti(L, 3, lua.Integer(i + 1))
            buf[i] = int(lua.L_checkinteger(L,3))
            lua.pop(L, 1)
            }
        } else {
        	buf[0] = int(lua.L_checkinteger(L, 3))
        }
        buf_ := raw_data(buf[:])
        rl.SetShaderValue(shd.shader, i32(loc), buf_, rl.ShaderUniformDataType(type))
    } else {
        buf := [4]f32{0, 0, 0, 0}
        if (lua.istable(L, 3)) {
            for i := 0; i < n; i+=1 {
            lua.rawgeti(L, 3, lua.Integer(i + 1))
            buf[i] = f32(lua.L_checknumber(L, -1))
            lua.pop(L, 1); }
        } else { buf[0] = f32(lua.L_checknumber(L, 3))}
         buf_ := raw_data(buf[:])
        rl.SetShaderValue(shd.shader, i32(loc), buf_, rl.ShaderUniformDataType(type))
    }
	return 0

	/*
	github.com/legendaryredfox/raylib-lua-bindings/blob/00bc677a4295084f5065e4cda3b182961dfff73b/src/lua_raylib_extra.c
	Shader *shader = luaL_checkudata(L, 1, "Shader");
    int loc  = (int)luaL_checkinteger(L, 2);
    int type = (int)luaL_checkinteger(L, 4);
    int n = shader_elem_count(type);
    if (n > 4) n = 4;
    if (shader_is_int(type)) {
        int buf[4] = {0, 0, 0, 0};
        if (lua_istable(L, 3)) {
            for (int i = 0; i < n; i++) { lua_rawgeti(L, 3, i + 1); buf[i] = (int)luaL_checkinteger(L, -1); lua_pop(L, 1); }
        } else { buf[0] = (int)luaL_checkinteger(L, 3); }
        SetShaderValue(*shader, loc, buf, type);
    } else {
        float buf[4] = {0, 0, 0, 0};
        if (lua_istable(L, 3)) {
            for (int i = 0; i < n; i++) { lua_rawgeti(L, 3, i + 1); buf[i] = (float)luaL_checknumber(L, -1); lua_pop(L, 1); }
        } else { buf[0] = (float)luaL_checknumber(L, 3); }
        SetShaderValue(*shader, loc, buf, type);
    }
    return 0;
    */
}



shader_meta := []lua.L_Reg{
 /*   {"__index", lua_getpointindex  },
    {"__newindex",  lua_setpoint},

    {"__tostring", lua_image_tostring},
   {"__add", lua_point_add},
    {"__sub", lua_point_sub},
    {"__mul", lua_point_mul}, */
    {"__gc", lua_shader_gc},
    {nil, nil},
}


lua_shaderlib := []lua.L_Reg{
	{"end_shader_mode", lua_end_shader_mode},
	{"begin_shader_mode", lua_begin_shader_mode},
	{"load_shader", lua_load_shader},
    {nil, nil},
}

luashader_open :: proc "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()

    lua.L_newmetatable(L, "ShaderMT")
    lua.L_setfuncs(L, raw_data(shader_meta), 0)
    lua.pop(L, 1)

    lua.L_newlib(L,  lua_shaderlib)

    return 1

}
