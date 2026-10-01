package array

// arrray library
// Source:
// https://martin-fieber.de/blog/cpp-and-lua/#user-data


import lua "vendor:lua/5.4"
import "base:runtime"
import rand "core:math/rand"


intarray_delete :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	a := cast(^intarray)lua.touserdata(L, 1)
    free(a.data)
	return 0
}

// get index from array
intarray_index :: proc "c" (L: ^lua.State ) -> i32 {

	context = runtime.default_context()
	a := cast(^intarray)lua.touserdata(L, 1)
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


// batch change array
// array.array_change(A,1)
 lua_int_array_change :: proc "c" (L: ^lua.State ) -> i32 {

	context = runtime.default_context()

	a := cast(^intarray)lua.touserdata(L, 1)
	b := int(lua.L_checknumber(L,2))
   // lua.L_argcheck(L, a != nil, 1, "array expected")

   av := a.data[0:a.size]
   for i:=0;i<len(av);i+=1{
   		num := rand.int_range(-1,b+1)
     	a.data[i] = a.data[i] + i32(num)
   }



    return 0

}


lua_int_array_new :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	n := int(lua.L_checkinteger(L, 1))
    nbytes :uint= uint(size_of(intarray) + (n - 1) * size_of(i32))

    a := cast(^intarray)lua.newuserdata(L, nbytes)
    a.data = make([^]i32, n)
    a.size= n
    // userdata is already on the Lua stack
	lua.L_setmetatable(L, "IntArrayMT")
	return 1
}

intarray_newindex :: proc "c" (L: ^lua.State ) -> i32 {

	context = runtime.default_context()

	a := cast(^intarray)lua.touserdata(L, 1)
    //lua.L_argcheck(L, a != nil, 1, "array expected")
    index := int(lua.L_checkinteger(L, 2))
	val := i32(lua.L_checknumber(L, 3))
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

int_meta := []lua.L_Reg{
    {"__index",  intarray_index},
    {"__newindex",  intarray_newindex},
    { "__gc", intarray_delete },

    {nil, nil},
}

intarraylib := []lua.L_Reg{
    {"new",  lua_int_array_new},

    {nil, nil},
}

//
// int array sub library
create_intarray_sublib :: proc(L: ^lua.State) {

	context = runtime.default_context()

    // Create a new table for the easing sublibrary

    lua.L_newmetatable(L, "IntArrayMT")
    lua.L_setfuncs(L, raw_data(int_meta), 0)

    lua.L_newlib(L, intarraylib)

 //   lua.pushcfunction(L, l_ease_expo_in_out )
 //   lua.setfield(L, -2, "ease_expo_in_out")

}
