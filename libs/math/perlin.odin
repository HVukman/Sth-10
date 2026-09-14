package mathlib

import rl "vendor:raylib"
import lua "vendor:lua/5.4"
import "core:fmt"
import "core:slice"
import math "core:math"
import "base:runtime"
import rand "core:math/rand"
import array "../array"
import "core:math/noise"
import shapes "../shapes"


noise_ :: proc(p: [512]int , x, y, z : f64)  -> f64 {

	x := x
	y := y
	z := z
    X := int(math.floor(x)) & 255
    Y := int(math.floor(y)) & 255
    Z := int(math.floor(z)) & 255
    x -= math.floor(x)
    y -= math.floor(y)
    z -= math.floor(z)
    u := fade(x)
    v := fade(y)
    w := fade(z)
    A := p[X] + Y
    AA := p[A] + Z
    AB := p[A+1] + Z
    B := p[X+1] + Y
    BA := p[B] + Z
    BB := p[B+1] + Z
    return lerp(w, lerp(v, lerp(u, grad(p[AA], x, y, z),
        grad(p[BA], x-1, y, z)),
        lerp(u, grad(p[AB], x, y-1, z),
            grad(p[BB], x-1, y-1, z))),
        lerp(v, lerp(u, grad(p[AA+1], x, y, z-1),
            grad(p[BA+1], x-1, y, z-1)),
            lerp(u, grad(p[AB+1], x, y-1, z-1),
                grad(p[BB+1], x-1, y-1, z-1))))

}

fade :: proc(t: f64) ->f64 {
	return t * t * t * (t*(t*6-15) + 10)
}
lerp :: proc(t, a, b : f64) -> f64 {
	return a + t*(b-a)
}


 grad :: proc (hash: int, x, y, z : f64) ->  f64 {

    switch hash & 15 {
    case 0, 12:
        return x + y
    case 1, 14:
        return y - x
    case 2:
        return x - y
    case 3:
        return -x - y
    case 4:
        return x + z
    case 5:
        return z - x
    case 6:
        return x - z
    case 7:
        return -x - z
    case 8:
        return y + z
    case 9, 13:
        return z - y
    case 10:
        return y - z
    }
    // case 11, 16:
    return -y - z
}


permutation := []int{
    151, 160, 137, 91, 90, 15, 131, 13, 201, 95, 96, 53, 194, 233, 7, 225,
    140, 36, 103, 30, 69, 142, 8, 99, 37, 240, 21, 10, 23, 190, 6, 148,
    247, 120, 234, 75, 0, 26, 197, 62, 94, 252, 219, 203, 117, 35, 11, 32,
    57, 177, 33, 88, 237, 149, 56, 87, 174, 20, 125, 136, 171, 168, 68, 175,
    74, 165, 71, 134, 139, 48, 27, 166, 77, 146, 158, 231, 83, 111, 229, 122,
    60, 211, 133, 230, 220, 105, 92, 41, 55, 46, 245, 40, 244, 102, 143, 54,
    65, 25, 63, 161, 1, 216, 80, 73, 209, 76, 132, 187, 208, 89, 18, 169,
    200, 196, 135, 130, 116, 188, 159, 86, 164, 100, 109, 198, 173, 186, 3, 64,
    52, 217, 226, 250, 124, 123, 5, 202, 38, 147, 118, 126, 255, 82, 85, 212,
    207, 206, 59, 227, 47, 16, 58, 17, 182, 189, 28, 42, 223, 183, 170, 213,
    119, 248, 152, 2, 44, 154, 163, 70, 221, 153, 101, 155, 167, 43, 172, 9,
    129, 22, 39, 253, 19, 98, 108, 110, 79, 113, 224, 232, 178, 185, 112, 104,
    218, 246, 97, 228, 251, 34, 242, 193, 238, 210, 144, 12, 191, 179, 162, 241,
    81, 51, 145, 235, 249, 14, 239, 107, 49, 192, 214, 31, 181, 199, 106, 157,
    184, 84, 204, 176, 115, 121, 50, 45, 127, 4, 150, 254, 138, 236, 205, 93,
    222, 114, 67, 29, 24, 72, 243, 141, 128, 195, 78, 66, 215, 61, 156, 180,
}


perlin_noise :: proc ( x,y,z:$E) -> f64 {

	a :[512]int
	for i:=0 ; i< 256; i+=1{
		a[i] = permutation[i]
	}
	for i:=256 ; i< 512; i+=1{
		a[i] = permutation[i]
	}

	return (noise_(a, f64(x),f64(y),f64(z)))
}

lua_perlin :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	a:= lua.L_checknumber(L,1)
	b:= lua.L_checknumber(L,2)
	c:= lua.L_checknumber(L,3)

	res := perlin_noise(a,b,c)
	lua.pushnumber(L, lua.Number(res))
	return 1
}

lua_perlin_fbm :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()

	sol : f64

	a:= lua.L_checknumber(L,1)
	b:= lua.L_checknumber(L,2)
	f:= lua.L_checknumber(L,3)
	amp := lua.L_checknumber(L,4)
	octaves := lua.L_checknumber(L,5)

	f_ := f64(f)
	amp_ := f64(amp)
	for i:=0;i<int(octaves);i+=1{
		sol +=amp_* perlin_noise(a,b,f)
		f_ *=2.0
		amp_ *=0.5
	}

	lua.pushnumber(L, lua.Number(sol))
	return 1
}


// poisson disk
//
Point2D :: struct {
    x, y: f64,
}

PoissonDiskResult :: struct {
    points: []Point2D,
    grid: [][]i32, // Grid for debugging/visualization
}
