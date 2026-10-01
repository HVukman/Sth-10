package lightarray


import "core:fmt"
import lua "vendor:lua/5.4" // or whatever version you want

import "base:runtime"

import hm "core:container/handle_map"

Handle :: hm.Handle16
// array
array :: struct {
    size: int,
    data: [^]f64,  // Raw pointer for faster access
}

Entity :: struct {
	handle:      Handle,
	array_:    array,
}

entities: hm.Dynamic_Handle_Map(Entity, Handle)
// Creates a texture from an image and returns a handle
//

// free array
//
lua_free :: proc "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()
    // Retrieve the handle from the light userdata
    packed := uintptr(lua.touserdata(L, 1))
    handle : hm.Handle16
    handle.idx = u8(packed >> 32)
    handle.gen = u8(packed & 0xFFFFFFFF)
    x := i32(lua.L_checknumber(L, 2))
    y := i32(lua.L_checknumber(L, 3))

    // Convert handle to a safe pointer
   array_system_free(handle)

    return 0
}

array_system_free :: proc(handle: hm.Handle16 )  {
	if e, ok := hm.dynamic_get(&entities, handle); ok {
			free(e.array_.data)
		}else{
			fmt.println("not ok")
		}
}



// get index from array
//
array_get :: proc(handle: hm.Handle16, x:i32 ) -> f64{
	if e, ok := hm.dynamic_get(&entities, handle); ok {
			return e.array_.data[x]
		}else{
			fmt.println("not ok")
			return 0
		}
}

lua_get :: proc "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()
    // Retrieve the handle from the light userdata
    packed := uintptr(lua.touserdata(L, 1))
    handle : hm.Handle16
    handle.idx = u8(packed >> 32)
    handle.gen = u8(packed & 0xFFFFFFFF)
    x := i32(lua.L_checknumber(L, 2))

    // Convert handle to a safe pointer
    val := array_get(handle,x)

    lua.pushnumber(L,lua.Number(val))
    return 1
}


// set index from array
//
array_set :: proc(handle: hm.Handle16, idx:i32, val:f64 ) {
	if e, ok := hm.dynamic_get(&entities, handle); ok {
			e.array_.data[idx] = val
		}else{
			fmt.println("not ok")

		}
}

lua_set :: proc "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()
    // Retrieve the handle from the light userdata
    packed := uintptr(lua.touserdata(L, 1))
    handle : hm.Handle16
    handle.idx = u8(packed >> 32)
    handle.gen = u8(packed & 0xFFFFFFFF)
    idx := i32(lua.L_checknumber(L, 2))
    val := f64(lua.L_checknumber(L, 3))
    // Convert handle to a safe pointer
    array_set(handle,idx,val)


    return 0
}



arraylib := []lua.L_Reg{
    {"new",  luaarray_new},
    {"set",  lua_set},
    {"get",  lua_get},
    {"free",  lua_free},
    {nil, nil},
}



array_delete :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	a := cast(^array)lua.touserdata(L, 1)
    free(a.data)
	return 0
}

// Creates new array
array_new :: proc(n:int) -> hm.Handle16 {

	a:array
	a.data = make([^]f64, n)
    a.size= n

    h1 := hm.add(&entities, Entity{array_ = a})

    return h1
}

luaarray_new :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	n:= lua.L_checkinteger(L,1)
    handle := array_new(int(n))
    // Push the handle as a light userdata (or integer) to Lua
    packed := (u64(handle.idx) << 32) | u64(handle.gen)
    lua.pushlightuserdata(L,cast(rawptr)uintptr(packed))
    return 1

}



lualightarray_open :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
    lua.L_newlib(L, arraylib)
	return 1
}
