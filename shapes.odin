package sth10

// Source:
// https://martin-fieber.de/blog/cpp-and-lua/#user-data

import "core:fmt"
import lua "vendor:lua/5.4" // or whatever version you want
import "core:c/libc"
import "base:runtime"
import rl "vendor:raylib"
import "core:strings"

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

//
PointArray :: struct {
    size: int,
    data: rawptr,  // pointer to pixel data
}

// array string
//
pointarray_string :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
    a := cast(^PointArray)lua.L_checkudata(L,1,"PointArrayMT")
    points := cast([^]point)a.data
    new_str := fmt.tprintf(" PointArray of Len %i " , a.size)
    lua.pushstring(L, strings.clone_to_cstring(new_str))
	return 1
}

// array size
//
pointarray_size :: proc "c" (L: ^lua.State) -> i32 {


    a := cast(^PointArray)lua.L_checkudata(L,1,"PointArrayMT")
    points := cast([^]point)a.data
    lua.pushinteger(L, lua.Integer(a.size) )
	return 1
}

// new point array
pointarray_new :: proc "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()

    n := int(lua.L_checkinteger(L, 1))
    if n < 0 {
        lua.L_argerror(L, 1, "size must be positive")
        return 0
    }

    // Allocate the PixelArray struct
    a := cast(^PointArray)lua.newuserdata(L, size_of(PointArray))
    a.size = n
    a.data = raw_data(make([]point, n))

    lua.L_getmetatable(L, "PointArrayMT")
    lua.setmetatable(L, -2)

    return 1
}

// get point x or y
lua_getpointindex :: proc "c" (L: ^lua.State ) -> i32 {

	context = runtime.default_context()
	point_:= cast(^point)lua.L_checkudata(L,1,"PointMT")
	ind := lua.L_checkstring(L,2)

	if ind == "x" {

		lua.pushnumber(L,lua.Number(point_.x))
		return 1
	}
	else if ind == "y" {

		lua.pushnumber(L,lua.Number(point_.y))
		return 1
	}else{
		lua.pushnil(L)
		return 1
	}


}
lua_point_tostring :: proc "c" (L: ^lua.State) -> i32  {

	context = runtime.default_context()

    point_ := cast(^point)lua.L_checkudata(L, 1, "PointMT")

    // Format as string
    buf: [64]byte
    result := fmt.bprintf(buf[:], "Point(%.2f, %.2f)", point_.x, point_.y)
    lua.pushstring(L, strings.clone_to_cstring(result))

    return 1

}

// set x y
lua_setpoint :: proc "c" (L: ^lua.State) -> i32  {

	context = runtime.default_context()
	point_:= cast(^point)lua.L_checkudata(L,1,"PointMT")
	ind := lua.L_checkstring(L,2)
	val := lua.L_checknumber(L,3)
	if ind == "x" {
		point_.x = f32(val)

		return 0
	}
	else if ind == "y" {
		point_.y = f32(val)
		return 0
	}else{
		lua.L_error(L, "argument not point")
		return 0
	}
}

// __add for vector addition
lua_point_add :: proc "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()

    p1 := cast(^point)lua.L_checkudata(L, 1, "PointMT")
    p2 := cast(^point)lua.L_checkudata(L, 2, "PointMT")

    // Create new point
    result := cast(^point)lua.newuserdata(L, size_of(point))
    result.x = p1.x + p2.x
    result.y = p1.y + p2.y

    lua.L_setmetatable(L, "PointMT")
    return 1
}

// __sub for vector subtraction
lua_point_sub :: proc "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()

    p1 := cast(^point)lua.L_checkudata(L, 1, "PointMT")
    p2 := cast(^point)lua.L_checkudata(L, 2, "PointMT")

    result := cast(^point)lua.newuserdata(L, size_of(point))
    result.x = p1.x - p2.x
    result.y = p1.y - p2.y

    lua.L_setmetatable(L, "PointMT")
    return 1
}

// __mul for scalar multiplication
lua_point_mul :: proc "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()

    p := cast(^point)lua.L_checkudata(L, 1, "PointMT")
    scalar := lua.L_checknumber(L, 2)

    result := cast(^point)lua.newuserdata(L, size_of(point))
    result.x = p.x * f32(scalar)
    result.y = p.y * f32(scalar)

    lua.L_setmetatable(L, "PointMT")
    return 1
}

// __eq for equality
lua_point_eq :: proc "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()

    p1 := cast(^point)lua.L_checkudata(L, 1, "PointMT")
    p2 := cast(^point)lua.L_checkudata(L, 2, "PointMT")

    result := p1.x == p2.x && p1.y == p2.y
    lua.pushboolean(L, b32(result))
    return 1
}

pointarray_methods := []lua.L_Reg{
    {"size", pointarray_size},

    {nil, nil},
}

pointarray_meta := []lua.L_Reg{
	{"size", pointarray_size},
	  {"__index", nil},  // Will be set to pointarray_methods
	{"__tostring", pointarray_string},
/*    {"__index", lua_getpointindex  },
    {"__newindex",  lua_setpoint},
    {"__add", lua_point_add},
    {"__sub", lua_point_sub},
    {"__mul", lua_point_mul},
    {"__eq", lua_point_eq},
    */
    {nil, nil},
}

point_meta := []lua.L_Reg{
    {"__index", lua_getpointindex  },
    {"__newindex",  lua_setpoint},
    {"__tostring", lua_point_tostring},
    {"__add", lua_point_add},
    {"__sub", lua_point_sub},
    {"__mul", lua_point_mul},
    {"__eq", lua_point_eq},
    {nil, nil},
}

shapeslib := []lua.L_Reg{
    {"newpoint",  lua_newpoint},
    {"newpointarray", pointarray_new},
    {nil, nil},
}

// create new point
lua_newpoint :: proc "c" (L: ^lua.State) -> i32  {

	context = runtime.default_context()
	x := lua.L_checknumber(L,1)
	y := lua.L_checknumber(L,2)


	v:= cast(^point)lua.newuserdata(L, size_of(point))
	v.x = f32(x)
	v.y = f32(y)
	// userdata is already on the Lua stack
	lua.L_setmetatable(L, "PointMT")
	return 1
}

lua_openshapes :: proc "c" (L: ^lua.State) -> i32  {

	context = runtime.default_context()
	lua.L_newmetatable(L, "PointMT")
	lua.L_setfuncs(L, raw_data(point_meta), 0)
	lua.L_newlib(L, shapeslib)


	lua.L_newmetatable(L, "PointArrayMT")
	// Set __index to pointarray_methods
    lua.L_newlib(L, pointarray_methods)
    lua.setfield(L, -2, "__index")

    // Set __tostring
    lua.pushcfunction(L, pointarray_string)
    lua.setfield(L, -2, "__tostring")

	lua.L_newlib(L, shapeslib)

	return 1
}
