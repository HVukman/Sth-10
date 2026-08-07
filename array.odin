package sth10

// arrray library
// Source:
// https://martin-fieber.de/blog/cpp-and-lua/#user-data

import "core:fmt"
import lua "vendor:lua/5.4" // or whatever version you want
import "core:c/libc"
import "base:runtime"
import rand "core:math/rand"

// Better array structure - use raw memory directly
array :: struct {
    size: int,
    data: [^]f64,  // Raw pointer for faster access
}



array_newindex :: proc "c" (L: ^lua.State ) -> i32 {

	context = runtime.default_context()

	a := cast(^array)lua.touserdata(L, 1)

    //lua.L_argcheck(L, a != nil, 1, "array expected")

    index := int(lua.L_checkinteger(L, 2))
	val := f64(lua.L_checknumber(L, 3))


	/*
    lua.L_argcheck(
        L,
        1 <= index && index <= len(a.values),
        2,
        "index out of range",
    )
    */


    a.data[index-1] = val


    return 0

}

// batch change array
// array.array_change(A,1)
array_change :: proc "c" (L: ^lua.State ) -> i32 {

	context = runtime.default_context()

	a := cast(^array)lua.touserdata(L, 1)
	b := int(lua.L_checknumber(L,2))
   // lua.L_argcheck(L, a != nil, 1, "array expected")

   av := a.data[0:a.size]
   for i:=0;i<len(av);i+=1{
   		num := rand.int_range(-1,b+1)
     	a.data[i] = a.data[i] + f64(num)
   }

   /* lua.L_argcheck(
        L,
        1 <= index && index <= len(a.values),
        2,
        "index out of range",
    )
    */


    return 0

}

// get index from array
array_index :: proc "c" (L: ^lua.State ) -> i32 {

	context = runtime.default_context()

	a := cast(^array)lua.touserdata(L, 1)

   // lua.L_argcheck(L, a != nil, 1, "array expected")

    index := int(lua.L_checkinteger(L, 2))

   /* lua.L_argcheck(
        L,
        1 <= index && index <= len(a.values),
        2,
        "index out of range",
    )
    */

    lua.pushnumber(L, lua.Number(a.data[index-1]))

    return 1

}

array_meta := []lua.L_Reg{
    {"__index",  array_index},
    {"__newindex",  array_newindex},
    { "__gc", array_delete },

    {nil, nil},
}

arraylib := []lua.L_Reg{
    {"new",  luaarray_new},
    {"array_change",  array_change},
    {nil, nil},
}

array_delete :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	a := cast(^array)lua.touserdata(L, 1)
    free(a.data)
	return 0
}

luaarray_new :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	n := int(lua.L_checkinteger(L, 1))
    nbytes :uint= uint(size_of(array) + (n - 1) * size_of(f64))

    a := cast(^array)lua.newuserdata(L, nbytes)
    a.data = make([^]f64, n)
    a.size= n
    // userdata is already on the Lua stack
	lua.L_setmetatable(L, "array")
	return 1
}

luaarray_open :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	lua.L_newmetatable(L, "array")
	lua.L_setfuncs(L, raw_data(array_meta), 0)
	lua.L_newlib(L, arraylib)
	return 1
}
