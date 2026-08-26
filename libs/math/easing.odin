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

l_ease_expo_in_out :: proc  "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()
    counter:=lua.L_checknumber(L,1)
    start:=lua.L_checknumber(L,2)
    target :=lua.L_checknumber(L,3)
    duration :=lua.L_checknumber(L,4)

    res := rl.EaseExpoInOut(f32(counter),f32(start),f32(target),f32(duration))
    lua.pushnumber(L,lua.Number( res))
    return 1
}


l_ease_expo_in :: proc  "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()
    counter:=lua.L_checknumber(L,1)
    start:=lua.L_checknumber(L,2)
    target :=lua.L_checknumber(L,3)
    duration :=lua.L_checknumber(L,4)

    res := rl.EaseExpoIn(f32(counter),f32(start),f32(target),f32(duration))
    lua.pushnumber(L,lua.Number( res))
    return 1
}

l_ease_expo_out :: proc  "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()
    counter:=lua.L_checknumber(L,1)
    start:=lua.L_checknumber(L,2)
    target :=lua.L_checknumber(L,3)
    duration :=lua.L_checknumber(L,4)

    res := rl.EaseExpoOut(f32(counter),f32(start),f32(target),f32(duration))
    lua.pushnumber(L,lua.Number( res))
    return 1
}


l_ease_linear_in_out :: proc  "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()
    counter:=lua.L_checknumber(L,1)
    start:=lua.L_checknumber(L,2)
    target :=lua.L_checknumber(L,3)
    duration :=lua.L_checknumber(L,4)

    res := rl.EaseLinearInOut(f32(counter),f32(start),f32(target),f32(duration))
    lua.pushnumber(L,lua.Number( res))
    return 1
}


l_ease_linear_in :: proc  "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()
    counter:=lua.L_checknumber(L,1)
    start:=lua.L_checknumber(L,2)
    target :=lua.L_checknumber(L,3)
    duration :=lua.L_checknumber(L,4)

    res := rl.EaseLinearIn(f32(counter),f32(start),f32(target),f32(duration))
    lua.pushnumber(L,lua.Number( res))
    return 1
}

l_ease_linear_out :: proc  "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()
    counter:=lua.L_checknumber(L,1)
    start:=lua.L_checknumber(L,2)
    target :=lua.L_checknumber(L,3)
    duration :=lua.L_checknumber(L,4)

    res := rl.EaseLinearOut(f32(counter),f32(start),f32(target),f32(duration))
    lua.pushnumber(L,lua.Number( res))
    return 1
}


l_ease_elastic_in_out :: proc  "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()
    counter:=lua.L_checknumber(L,1)
    start:=lua.L_checknumber(L,2)
    target :=lua.L_checknumber(L,3)
    duration :=lua.L_checknumber(L,4)

    res := rl.EaseElasticInOut(f32(counter),f32(start),f32(target),f32(duration))
    lua.pushnumber(L,lua.Number( res))
    return 1
}


l_ease_elastic_in :: proc  "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()
    counter:=lua.L_checknumber(L,1)
    start:=lua.L_checknumber(L,2)
    target :=lua.L_checknumber(L,3)
    duration :=lua.L_checknumber(L,4)

    res := rl.EaseElasticIn(f32(counter),f32(start),f32(target),f32(duration))
    lua.pushnumber(L,lua.Number( res))
    return 1
}

l_ease_elastic_out :: proc  "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()
    counter:=lua.L_checknumber(L,1)
    start:=lua.L_checknumber(L,2)
    target :=lua.L_checknumber(L,3)
    duration :=lua.L_checknumber(L,4)

    res := rl.EaseElasticOut(f32(counter),f32(start),f32(target),f32(duration))
    lua.pushnumber(L,lua.Number( res))
    return 1
}


l_ease_bounce_in_out :: proc  "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()
    counter:=lua.L_checknumber(L,1)
    start:=lua.L_checknumber(L,2)
    target :=lua.L_checknumber(L,3)
    duration :=lua.L_checknumber(L,4)

    res := rl.EaseBounceInOut(f32(counter),f32(start),f32(target),f32(duration))
    lua.pushnumber(L,lua.Number( res))
    return 1
}


l_ease_bounce_in :: proc  "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()
    counter:=lua.L_checknumber(L,1)
    start:=lua.L_checknumber(L,2)
    target :=lua.L_checknumber(L,3)
    duration :=lua.L_checknumber(L,4)

    res := rl.EaseBounceIn(f32(counter),f32(start),f32(target),f32(duration))
    lua.pushnumber(L,lua.Number( res))
    return 1
}

l_ease_bounce_out :: proc  "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()
    counter:=lua.L_checknumber(L,1)
    start:=lua.L_checknumber(L,2)
    target :=lua.L_checknumber(L,3)
    duration :=lua.L_checknumber(L,4)

    res := rl.EaseBounceOut(f32(counter),f32(start),f32(target),f32(duration))
    lua.pushnumber(L,lua.Number( res))
    return 1
}


l_ease_sine_in :: proc  "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()
    counter:=lua.L_checknumber(L,1)
    start:=lua.L_checknumber(L,2)
    target :=lua.L_checknumber(L,3)
    duration :=lua.L_checknumber(L,4)

    res := rl.EaseSineIn(f32(counter),f32(start),f32(target),f32(duration))
    lua.pushnumber(L,lua.Number( res))
    return 1
}

l_ease_sine_out :: proc  "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()
    counter:=lua.L_checknumber(L,1)
    start:=lua.L_checknumber(L,2)
    target :=lua.L_checknumber(L,3)
    duration :=lua.L_checknumber(L,4)

    res := rl.EaseSineOut(f32(counter),f32(start),f32(target),f32(duration))
    lua.pushnumber(L,lua.Number( res))
    return 1
}

// easing
// noise sub library
create_easing_sublib :: proc(L: ^lua.State) {

	context = runtime.default_context()

    // Create a new table for the random sublibrary
    lua.newtable(L)


    lua.pushcfunction(L, l_ease_expo_in_out )
    lua.setfield(L, -2, "ease_expo_in_out")

    lua.pushcfunction(L, l_ease_expo_in )
    lua.setfield(L, -2, "ease_expo_in")

    lua.pushcfunction(L, l_ease_expo_out )
    lua.setfield(L, -2, "ease_expo_out")


    lua.pushcfunction(L, l_ease_linear_in_out )
    lua.setfield(L, -2, "ease_linear_in_out")

    lua.pushcfunction(L, l_ease_linear_in )
    lua.setfield(L, -2, "ease_linear_in")

    lua.pushcfunction(L, l_ease_linear_out )
    lua.setfield(L, -2, "ease_linear_out")



    lua.pushcfunction(L, l_ease_elastic_in_out )
    lua.setfield(L, -2, "ease_elastic_in_out")

    lua.pushcfunction(L, l_ease_elastic_in )
    lua.setfield(L, -2, "ease_elastic_in")

    lua.pushcfunction(L, l_ease_elastic_out )
    lua.setfield(L, -2, "ease_elastic_out")


    lua.pushcfunction(L, l_ease_bounce_in_out )
    lua.setfield(L, -2, "ease_bounce_in_out")

    lua.pushcfunction(L, l_ease_bounce_in )
    lua.setfield(L, -2, "ease_bounce_in")

    lua.pushcfunction(L, l_ease_bounce_out )
    lua.setfield(L, -2, "ease_bounce_out")

    lua.pushcfunction(L, l_ease_sine_in)
    lua.setfield(L, -2, "ease_sine_in")


    lua.pushcfunction(L, l_ease_sine_out )
    lua.setfield(L, -2, "ease_sine_out")




}
