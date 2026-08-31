package drawing

// draw splines

import "../colors"

import array "../array"
import "base:runtime"
import "core:fmt"
import lua "vendor:lua/5.4"
import rl "vendor:raylib"


lua_draw_linear_spline :: proc "c" (L: ^lua.State) -> i32 {

 // const Vector2 *points, int pointCount, float thick, Color color
 // draw.linear_spline(x,y,thick, color)
   	context = runtime.default_context()
   	a := cast(^array.array)lua.touserdata(L, 1)
    b := cast(^array.array)lua.touserdata(L, 2)
    thick:= lua.L_checknumber(L,3)
    col_:= lua.L_checknumber(L,4)
    COLOR_ARRAY := colors.COLOR_ARRAY


    if a.size <2 || b.size <2 {

    	lua.L_error(L,"not enough points for spline (at least 2)")
    	return 0
    } else if a.size != b.size {
	   	lua.L_error(L,"arrays must be same size")
	   	return 0
    }

    points : [dynamic]rl.Vector2
	reserve(&points, int(a.size))
	defer delete(points)


	for index := 0; index < a.size ; index += 1{
		new_vec : rl.Vector2
		new_vec.x = f32(a.data[index])
		new_vec.y = f32(b.data[index])

	 	append_elem(&points,new_vec)

	}
	dummy := raw_data(points)
    rl.DrawSplineLinear(dummy,i32(a.size),f32(thick) , COLOR_ARRAY[int(col_)])

    return 0

 }


lua_draw_catmull_rom_spline :: proc "c" (L: ^lua.State) -> i32 {

  // const Vector2 *points, int pointCount, float thick, Color color

    	context = runtime.default_context()
    	a := cast(^array.array)lua.touserdata(L, 1)
     b := cast(^array.array)lua.touserdata(L, 2)
     thick:= lua.L_checknumber(L,3)
     col_:= lua.L_checknumber(L,4)
     COLOR_ARRAY := colors.COLOR_ARRAY

     // minimum 4 points
     if a.size <4 || b.size <4 {

     	lua.L_error(L,"not enough points for Catmull-Rom spline (at least 4)")
     	return 0
     } else if a.size != b.size {
	   	lua.L_error(L,"arrays must be same size")
	   	return 0
     }

     points : [dynamic]rl.Vector2
	reserve(&points, int(a.size))
	defer delete(points)


	for index := 0; index < a.size ; index += 1{
		new_vec : rl.Vector2
		new_vec.x = f32(a.data[index])
		new_vec.y = f32(b.data[index])

	 	append_elem(&points,new_vec)

	}
	 dummy := raw_data(points)
     rl.DrawSplineCatmullRom(dummy,i32(a.size),f32(thick) , COLOR_ARRAY[int(col_)])

     return 0

  }
