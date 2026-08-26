package mathlib

import rl "vendor:raylib"
import lua "vendor:lua/5.4"
import "core:fmt"
import "core:math"
import "base:runtime"
import rand "core:math/rand"
import array "../array"
import "core:math/noise"
import shapes "../shapes"

lua_binom :: proc "c" (L: ^lua.State) -> i32 {

	n := lua.L_checknumber(L,1)
	k := lua.L_checknumber(L,2)

	res := math.binomial(int(n), int(k))

	lua.pushinteger(L, lua.Integer(res))
	return 1
}


lua_clamp :: proc "c" (L: ^lua.State) -> i32 {

	val := lua.L_checknumber(L,1)
	min := lua.L_checknumber(L,2)
	max := lua.L_checknumber(L,3)

	res := clamp(val,min,max)

	lua.pushnumber(L, lua.Number(res))
	return 1
}

lua_erf :: proc "c" (L: ^lua.State) -> i32 {

	val := f32(lua.L_checknumber(L,1))
	lua.pushnumber(L, lua.Number(math.erf_f32(val)))
	return 1
}

lua_gamma :: proc "c" (L: ^lua.State) -> i32 {

	val := f32(lua.L_checknumber(L,1))
	lua.pushnumber(L, lua.Number(math.gamma(val)))
	return 1
}

lua_round :: proc "c" (L: ^lua.State) -> i32 {

	val := f32(lua.L_checknumber(L,1))
	lua.pushnumber(L, lua.Number(math.round(val)))
	return 1
}

lua_trunc :: proc "c" (L: ^lua.State) -> i32 {

	val := f32(lua.L_checknumber(L,1))
	lua.pushnumber(L, lua.Number(math.trunc(val)))
	return 1
}

lua_wrap :: proc "c" (L: ^lua.State) -> i32 {

	val := f32(lua.L_checknumber(L,1))
	y:= f32(lua.L_checknumber(L,1))
	lua.pushnumber(L, lua.Number(math.wrap(val,y)))
	return 1
}

lua_gcd:: proc "c" (L: ^lua.State) -> i32 {

	a := int(lua.L_checknumber(L,1))
	b := int(lua.L_checknumber(L,2))
	lua.pushinteger(L, lua.Integer(math.gcd(a,b)))
	return 1
}

lua_lcm :: proc "c" (L: ^lua.State) -> i32 {

	a := int(lua.L_checknumber(L,1))
	b := int(lua.L_checknumber(L,2))
	lua.pushinteger(L, lua.Integer(math.lcm(a,b)))
	return 1
}

lua_sum :: proc "c" (L: ^lua.State) -> i32 {

	a := cast(^array.array)lua.touserdata(L, 1)
    av := a.data[0:a.size]
	lua.pushnumber(L, lua.Number(math.sum(av)))
	return 1
}

mathlib := []lua.L_Reg{

    {nil, nil},
}

// mathlib.random.normal(mean, stddev)
lua_randomnormal:: proc "c" (L: ^lua.State) -> i32 {

    context = runtime.default_context()

    mean := f32(lua.L_checknumber(L, 1))
    dev := f32(lua.L_checknumber(L, 2))
    lua.pushnumber(L, lua.Number(rand.float32_normal(mean,dev)))
    return 1
}

// mathlib.random.pareto(a,b)
lua_randompareto:: proc "c" (L: ^lua.State) -> i32 {

    context = runtime.default_context()

    alpha := f32(lua.L_checknumber(L, 1))
    beta:= f32(lua.L_checknumber(L,2))
    lua.pushnumber(L, lua.Number(rand.float32_pareto(alpha,beta)))
    return 1
}

// mathlib.random.gamma(a,b)
lua_randomgamma:: proc "c" (L: ^lua.State) -> i32 {

    context = runtime.default_context()

    a := f32(lua.L_checknumber(L, 1))
    b := f32(lua.L_checknumber(L, 2))
    lua.pushnumber(L, lua.Number(rand.float32_gamma(a,b)))
    return 1
}

// mathlib.random.laplace(mean, b)
lua_randomlaplace:: proc "c" (L: ^lua.State) -> i32 {

    context = runtime.default_context()

    mean := f64(lua.L_checknumber(L, 1))
    b := f64(lua.L_checknumber(L, 2))
    lua.pushnumber(L, lua.Number(rand.float64_laplace(mean,b)))
    return 1
}

// mathlib.random.seed(seed)
lua_randomseed :: proc "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()

    seed := lua.L_checkinteger(L, 1)
    rand.reset(u64(seed))
    return 0
}

// mathlib.random.i63
lua_randomi63 :: proc "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()
    lua.pushinteger(L, lua.Integer(rand.int63()))
    return 1
}

// mathlib.random.u32
lua_randomu32 :: proc "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()
    lua.pushinteger(L, lua.Integer(rand.uint32()))
    return 1
}

// mathlib.random.u64
lua_randomu64 :: proc "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()
    lua.pushinteger(L, lua.Integer(rand.uint64()))
    return 1
}

// mathlib.random.shuffle(a,lena)
lua_shufflearray :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	a := cast(^array.array)lua.touserdata(L, 1)

    av := a.data[0:a.size]

    rand.shuffle(av)
    return 0
}

// mathlib.noise.noise_2d
lua_noise2d :: proc "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()
    seed := lua.L_checknumber(L,1)
    point :=  cast(^shapes.point)lua.L_checkudata(L, 2, "PointMT")
    p :[2]f64
    p.x = f64(point.x)
    p.y = f64(point.y)
    lua.pushinteger(L, lua.Integer(noise.noise_2d(i64(seed) , p )))
    return 1
}

// mathlib.noise.noise_2dimprovex
lua_noise2d_improvex :: proc "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()
    seed := lua.L_checknumber(L,1)
    point :=  cast(^shapes.point)lua.L_checkudata(L, 2, "PointMT")
    p :[2]f64
    p.x = f64(point.x)
    p.y = f64(point.y)
    lua.pushinteger(L, lua.Integer(noise.noise_2d_improve_x(i64(seed) , p )))
    return 1
}



// noise sub library
create_noise_sublib :: proc(L: ^lua.State) {

	context = runtime.default_context()

    // Create a new table for the random sublibrary
    lua.newtable(L)

    lua.pushcfunction(L, lua_noise2d )
    lua.setfield(L, -2, "noise_2d")

    lua.pushcfunction(L, lua_noise2d_improvex )
    lua.setfield(L, -2, "noise_2d_improve")


}
// random sub library
create_random_sublib :: proc(L: ^lua.State) {
    context = runtime.default_context()

    // Create a new table for the random sublibrary
    lua.newtable(L)


    lua.pushcfunction(L, lua_randomseed)
    lua.setfield(L, -2, "newseed")


    lua.pushcfunction(L, lua_randomgamma)
    lua.setfield(L, -2, "gamma")


    lua.pushcfunction(L, lua_randomlaplace)
    lua.setfield(L, -2, "laplace")


    lua.pushcfunction(L, lua_randomnormal)
    lua.setfield(L, -2, "normal")


    lua.pushcfunction(L, lua_randompareto)
    lua.setfield(L, -2, "pareto")

    lua.pushcfunction(L, lua_randomi63)
    lua.setfield(L, -2, "i63")

    lua.pushcfunction(L, lua_randomu32)
    lua.setfield(L, -2, "u32")

    lua.pushcfunction(L, lua_randomu64)
    lua.setfield(L, -2, "u64")

    lua.pushcfunction(L, lua_shufflearray)
    lua.setfield(L, -2, "shufflearray")

}

lua_openmath :: proc "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()

    // Create main math table
    lua.newtable(L)

    // Constants
    lua.pushnumber(L, lua.Number(math.E))
    lua.setfield(L, -2, "E")


    lua.pushnumber(L, lua.Number(math.TAU))
    lua.setfield(L, -2, "TAU")


    lua.pushnumber(L, lua.Number(math.F32_EPSILON))
    lua.setfield(L, -2, "F32_EPSILON")

    lua.pushnumber(L, lua.Number(math.F64_EPSILON))
    lua.setfield(L, -2, "F64_EPSILON")

    lua.pushnumber(L, lua.Number(math.F32_MAX))
    lua.setfield(L, -2, "F32_MAX")

    lua.pushnumber(L, lua.Number(math.F64_MAX))
    lua.setfield(L, -2, "F46_MAX")


    lua.pushnumber(L, lua.Number(math.F32_MIN))
    lua.setfield(L, -2, "F32_MIN")

    lua.pushnumber(L, lua.Number(math.F64_MIN))
    lua.setfield(L, -2, "F46_MIN")

    lua.pushnumber(L, lua.Number(math.INF_F32))
    lua.setfield(L, -2, "F32_INF")

    lua.pushnumber(L, lua.Number(math.INF_F64))
    lua.setfield(L, -2, "F64_INF")

    // Functions
    lua.pushcfunction(L, lua_binom)
    lua.setfield(L, -2, "binom")

    lua.pushcfunction(L, lua_clamp)
    lua.setfield(L, -2, "clamp")

    lua.pushcfunction(L, lua_gamma)
    lua.setfield(L, -2, "gamma")

    lua.pushcfunction(L, lua_erf)
    lua.setfield(L, -2, "erf")

    lua.pushcfunction(L, lua_clamp)
    lua.setfield(L, -2, "clamp")

    lua.pushcfunction(L, lua_round)
    lua.setfield(L, -2, "round")


    lua.pushcfunction(L, lua_wrap)
    lua.setfield(L, -2, "wrap")

    lua.pushcfunction(L, lua_gcd)
    lua.setfield(L, -2, "gcd")


    lua.pushcfunction(L, lua_lcm)
    lua.setfield(L, -2, "lcm")


    lua.pushcfunction(L, lua_sum)
    lua.setfield(L, -2, "sum")


    create_random_sublib(L)
    lua.setfield(L, -2, "random")

    create_noise_sublib(L)
    lua.setfield(L, -2, "noise")

	return 1
   }
