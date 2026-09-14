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



// return index x and y as float
imageToGrid :: proc (point : rl.Vector2, cellSize:int) -> rl.Vector2
{
  gridX := i32(point.x / f32(cellSize))
  gridY := i32(point.y / f32(cellSize))
  return rl.Vector2{f32(gridX), f32(gridY) }
}


distance :: proc( x,y : rl.Vector2) ->f32 {
	return math.sqrt_f32( math.pow_f32(x.x-y.x,2.0) + math.pow_f32(x.y-y.y,2.0))
}

// internal poisson disk
poission_disk :: proc (width,height,min_dist: int) -> [dynamic]rl.Vector2 {

	fmt.println(" poisson disk ")
	width := width

	cell_size := int(math.round_f32(f32(min_dist)/math.sqrt_f32(2)))


	y:= int(math.ceil_f32(f32(height/cell_size))) // heights

	grid  := make([][]rl.Vector2, y)
	defer delete(grid)
	for i:=0;i<y ; i+=1{
		x:= int(math.ceil_f32(f32(width/cell_size))) // row
		row_  := make([]rl.Vector2, x)
		grid[i] = row_
	}

	// quadratic grid
	for i:=0;i<len(grid);i+=1{
		for h:=0;h<len(grid);h+=1{
			grid[i][h].x = -1
			grid[i][h].y = -1
		}
	}

	fmt.println(" poisson disk y " , y)
	// make random first point
	first_point := rl.Vector2{f32(rand.int31_max(i32(width))),f32(rand.int31_max(i32(height)))}

	process_list : [dynamic]rl.Vector2
	active_list : [dynamic]rl.Vector2
	defer delete(active_list)
/*	ind:= imageToGrid(first_point,cell_size)

	grid[int(ind.x)][int(ind.y)]= first_point

	inject_at(&process_list,len(process_list), first_point)
	append(&active_list,first_point)

	k:=30

	fmt.println("len active list ", len(active_list))
	for len(active_list)!=0 {
	rand_index := rand.int31_max(i32(len(active_list)))
	// choose random index from active list
	random_point := active_list[rand_index]


	fmt.println(" samples fp " , first_point)
	for m:=0;m<k;m+=1{
		fmt.println(" samples m " , m)
		sample:[dynamic]rl.Vector2
		defer delete(sample)

		// generate up to k points between r and 2r
		// r is min_dist
		new_point : rl.Vector2
		a:= rand.float32_range(0.0,f32(math.PI))
		new_point.x = math.cos_f32(a) * rand.float32_range(f32(min_dist),f32(2*min_dist))
		new_point.y = math.sin_f32(a) * rand.float32_range(f32(min_dist),f32(2*min_dist))

		append(&sample, new_point)

		found : bool
		for i in sample {
			found = true
			if grid[int(new_point.x)][int(new_point.y)].x != -1 && grid[int(new_point.x)][int(new_point.y)].y != -1 {
				p:= grid[int(new_point.x)][int(new_point.y)]
				check_: for ii:=-1;ii<=1;ii+=1{
					for jj:=-1;jj<=1;jj+=1{

						if (int(new_point.x) + ii >0) && (int(new_point.x) + ii <len(grid)) &&
					 		(int(new_point.x) + jj >0) && (int(new_point.x) + jj <len(grid)) {
									p1:= grid[int(new_point.x) + ii][int(new_point.y)+jj]
									val:= distance(p,p1)
									if val<f32(min_dist) {
										found = false
										break check_
									}
						}

					}
				}

			}
		}
		if found{
			// append point to the active list
			append(&active_list,p)
			inject_at(&process_list,len(process_list), p)
		}else{
			// remove point from active list
			ordered_remove(&active_list,rand_index)
		}
	}
	fmt.println("len active list ", len(active_list))
	}
	fmt.println(" return " , process_list[:])
	*/
	return process_list
}


// poisson disk
// returns a table of points
lua_poisson_disk :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()

	w:= lua.L_checknumber(L,1)
	h:= lua.L_checknumber(L,2)
	d:= lua.L_checknumber(L,3)

	res := poission_disk(int(w),int(h),int(d))

	for i:=0;i<len(res);i+=1{
		lua.createtable(L,0,i32(len(res)))
        // get point
        result := cast(^shapes.point)lua.newuserdata(L, size_of(shapes.point))

        result.x = res[i].x
        result.y = res[i].y

        lua.L_setmetatable(L, "PointMT")
        // set index i+1
        lua.rawseti(L,-2,lua.Integer(i+1))

	}

    return 1
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

    lua.pushcfunction(L, lua_poisson_disk)
    lua.setfield(L, -2, "poisson_disk")

}
