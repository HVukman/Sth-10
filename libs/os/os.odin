package os_

import "core:fmt"
import lua "vendor:lua/5.4"

import "base:runtime"
import rl "vendor:raylib"
import "core:strings"
import "core:os"
import "core:time"


// checks if file exists, returns bool
lua_exist_file :: proc "c" (L: ^lua.State) -> i32{

    context = runtime.default_context()
    input_ := lua.L_checkstring(L,1)
    bool_file := os.exists(string(input_))

    lua.pushboolean(L, b32(bool_file))
    return 1

}

// glob pattern returns a table
//
lua_glob :: proc "c" (L: ^lua.State) -> i32{

    context = runtime.default_context()
    name_:= lua.L_checkstring(L,1)
    pattern_ := strings.clone_from_cstring(name_)

    matches, err := os.glob(pattern_)

    // put table on stack
    lua.newtable(L)

    i:=1
    for match in matches {
        lua.pushinteger(L,lua.Integer(i)) // push index from 1
        lua.pushstring(L, strings.clone_to_cstring(match)) // push match string
        lua.settable(L,-3) // set table on stack
        i +=1
    }

   // return table on top of stack
    return 1
}


lua_getinfo ::  proc "c" (L: ^lua.State) -> i32{

	context = runtime.default_context()
	info_ := cast(^os.File_Info)lua.L_checkudata(L, 1, "FileInfoMT")
	ind := lua.L_checkstring(L,2)

	if ind == "Access" || ind == "access" {
		lua.pushnumber(L,lua.Number(info_.access_time._nsec))
		return 1
	}else if ind == "Creation" || ind == "creation" {
		lua.pushnumber(L,lua.Number(info_.creation_time._nsec))
		return 1
	}else if ind == "size" || ind == "Size" {
		lua.pushnumber(L,lua.Number(info_.size))
		return 1
	}else if ind == "Modification" || ind == "modification" || ind =="Mod" || ind == "mod" {
		lua.pushnumber(L,lua.Number(info_.modification_time._nsec))
		return 1
	}else if ind == "Path" || ind == "path" {
		lua.pushstring(L, strings.clone_to_cstring( info_.fullpath))
		return 1
	}else if ind == "name" || ind == "Name" {
		lua.pushstring(L, strings.clone_to_cstring( info_.name))
		return 1

}
	return 0
	}

lua_file_info ::  proc "c" (L: ^lua.State) -> i32{

    context = runtime.default_context()
    file_ := lua.L_checkstring(L,1)
    fd, err := os.open(string(file_))
    defer os.close(fd)
    if err != nil{

    	lua.L_error(L , "error in opening")
        return 0
    }
    else{

      alloc := runtime.default_allocator()
        info_, err := os.fstat(fd, alloc)
        if err != nil{

        lua.L_error(L, " could not read file %s ", file_)
        return 0
    }
    else{
    		info := cast(^os.File_Info)lua.newuserdata(L, size_of(os.File_Info))
    		lua.L_setmetatable(L, "FileInfoMT")
    		info = &info_
            return 1
        }
    }

    return 0
}

info_meta := []lua.L_Reg{
 /*   {"__index", lua_getpointindex  },
    {"__newindex",  lua_setpoint},

   // {"__tostring", lua_texture_tostring},

   {"__add", lua_point_add},
    {"__sub", lua_point_sub},
    {"__mul", lua_point_mul},
    {"__gc", lua_text_gc}, */
    {"__index", lua_getinfo},
    {nil, nil},
}

os_meta := []lua.L_Reg{
 /*   {"__index", lua_getpointindex  },
    {"__newindex",  lua_setpoint},

   // {"__tostring", lua_texture_tostring},

   {"__add", lua_point_add},
    {"__sub", lua_point_sub},
    {"__mul", lua_point_mul},
    {"__gc", lua_text_gc}, */
    {nil, nil},
}

lua_oslib := []lua.L_Reg{
	{"exist_file" , lua_exist_file},
	{"glob" , lua_glob},
	{"file_info" , lua_file_info} ,
    {nil, nil},
}

luaos_open :: proc "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()

   	lua.L_newmetatable(L, "FileInfoMT")
	lua.L_setfuncs(L, raw_data(info_meta), 0)

    lua.L_newmetatable(L, "OsMT")
    lua.L_setfuncs(L, raw_data(os_meta), 0)
    lua.pop(L, 1)


    lua.L_newlib(L, lua_oslib)
    return 1
}
