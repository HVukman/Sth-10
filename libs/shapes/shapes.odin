package shapes

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

Ellipse :: struct{
	center :point,
	radiush : f32,
	radiusv : f32,
}

Ring :: struct{
	center : point,
	inner_radius: f32,
	outer_radius : f32,
	start_angle : f32,
	end_angle: f32,
	segments :int,
}

Polygon :: struct{
	center : point,
	sides : int,
	radius: f32,
	rotation : f32,

}

mat2 :: distinct matrix[2, 2]f32
mat4 :: distinct matrix[4, 4]f32

//
PointArray :: struct {
    size: int,
    data: rawptr,  // pointer to pixel data
}

CircleArray :: struct {
    size: int,
    data: rawptr,  // pointer to circle data
}

RectangleArray :: struct {
    size: int,
    data: rawptr,  // pointer to rectangle
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
pointarray_index :: proc "c" (L: ^lua.State) -> i32 {

    a := cast(^PointArray)lua.L_checkudata(L,1,"PointArrayMT")
    index:= lua.L_checkinteger(L, 2)

    point_:= cast(^point)lua.newuserdata(L, size_of(point))

    points := cast([^]point)a.data
    p := points[index - 1]


    result := cast(^point)lua.newuserdata(L, size_of(point))
        result.x = p.x
        result.y = p.y
        lua.L_setmetatable(L, "PointMT")
        return 1

}

// Set a point in the array
pointarray_set :: proc "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()
    a := cast(^PointArray)lua.L_checkudata(L, 1, "PointArrayMT")
    index := int(lua.L_checkinteger(L, 2))

    if index < 1 || index > a.size {
        lua.L_error(L, "index out of bounds: %d (size: %d)", index, a.size)
        return 0
    }

    x := lua.L_checknumber(L, 3)
    y := lua.L_checknumber(L, 4)

    points := cast([^]point)a.data
    points[index - 1] = point{f32(x), f32(y)}
    return 0
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

	if ind == "x" || ind=="X" {

		lua.pushnumber(L,lua.Number(point_.x))
		return 1
	}
	else if ind == "y" || ind=="Y"{

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
	if ind == "X" || ind == "x" {
		point_.x = f32(val)
		return 1
	}
	else if ind == "Y" || ind == "y" {
		point_.y = f32(val)
		return 1
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

// Get rectangle field (__index)
lua_getrectindex :: proc "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()
    rect_ := cast(^rectangle)lua.L_checkudata(L, 1, "RectMT")
    ind := lua.L_checkstring(L, 2)

    switch ind {
    case "x": fallthrough
    case "X":
        lua.pushnumber(L, lua.Number(rect_.x))
        return 1
    case "y": fallthrough
    case "Y":
        lua.pushnumber(L, lua.Number(rect_.y))
        return 1
    case "width":
        lua.pushnumber(L, lua.Number(rect_.width))
        return 1
    case "height":
        lua.pushnumber(L, lua.Number(rect_.height))
        return 1
    case:
        lua.pushnil(L)
        return 1
    }
}

// Set rectangle field (__newindex)
lua_setrect :: proc "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()
    rect_ := cast(^rectangle)lua.L_checkudata(L, 1, "RectangleMT")
    ind := lua.L_checkstring(L, 2)
    val := lua.L_checknumber(L, 3)

    switch ind {
    case "X": fallthrough
    case "x":
        rect_.x = f32(val)
    case "Y": fallthrough
    case "y":
        rect_.y = f32(val)
    case "width":
        rect_.width = f32(val)
    case "height":
        rect_.height = f32(val)
    case:
        lua.L_error(L, "invalid field: %s", ind)
        return 0
    }
    return 0
}

// __tostring for rectangle
lua_rect_tostring :: proc "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()
    rect_ := cast(^rectangle)lua.L_checkudata(L, 1, "RectangleMT")

    buf: [128]byte
    result := fmt.bprintf(buf[:], "Rect(x=%.2f, y=%.2f, w=%.2f, h=%.2f)",
                          rect_.x, rect_.y, rect_.width, rect_.height)
    lua.pushstring(L, strings.clone_to_cstring(result))
    return 1
}

// get triangle point

lua_get_triangle_point :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	tri_ := cast(^triangle)lua.L_checkudata(L, 1, "TriangleMT")
	ind  := lua.L_checkinteger(L, 2)

	if ind == 1 {
			result := cast(^point)lua.newuserdata(L, size_of(point))
			result = &tri_.p1
			return 1
	}else if ind == 2 {
			result := cast(^point)lua.newuserdata(L, size_of(point))
			result = &tri_.p2
			return 1
	}else if ind ==3 {
			result := cast(^point)lua.newuserdata(L, size_of(point))
			result = &tri_.p3
			return 1
	}else{
		lua.pushnil(L)
		return 1
	}


}

lua_set_triangle_point :: proc "c" (L: ^lua.State) -> i32 {

    context = runtime.default_context()
    tri_ := cast(^triangle)lua.L_checkudata(L, 1, "TriangleMT")
    p_ := cast(^point)lua.L_checkudata(L, 2, "PointMT")
    ind := lua.L_checknumber(L, 3)

    switch ind {
    case 1:
    	tri_.p1 = p_^
    case 2:
   		tri_.p2 = p_^
    case 3:
   		tri_.p3 = p_^

    case:
        lua.L_error(L, "invalid field: %i (1,2,3) ", ind)
        return 0
    }
    return 0
}

// __tostring for triangle
lua_triangle_tostring :: proc "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()

    tri_ := cast(^triangle)lua.L_checkudata(L, 1, "TriangleMT")

    str_ := fmt.tprintf( "Triangle p1x: %i , p1y : %i  p2x: %i , p2y : %i p3x: %i , p3y : %i" ,
    	tri_.p1.x, tri_.p1.y, tri_.p2.x , tri_.p2.y , tri_.p3.x , tri_.p3.y )

    lua.pushstring(L, strings.clone_to_cstring(str_))
    return 1
}

// Get circle field (__index)
lua_getcircleindex :: proc "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()
    circ_ := cast(^circle)lua.L_checkudata(L, 1, "CircleMT")
    ind := lua.L_checkstring(L, 2)

    switch ind {
    case "X": fallthrough
    case "x":
        lua.pushnumber(L, lua.Number(circ_.x))
        return 1
    case "Y": fallthrough
    case "y":
        lua.pushnumber(L, lua.Number(circ_.y))
        return 1
    case "r": fallthrough
    case "radius":
        lua.pushnumber(L, lua.Number(circ_.radius))
        return 1
    case:
        lua.pushnil(L)
        return 1
    }
}

lua_setcircle :: proc "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()
    circ_ := cast(^circle)lua.L_checkudata(L, 1, "CircleMT")
    ind := lua.L_checkstring(L, 2)
    val := lua.L_checknumber(L, 3)

    switch ind {
    case "X": fallthrough
    case "x":
        circ_.x = f32(val)
    case "Y": fallthrough
    case "y":
        circ_.y = f32(val)
    case "radius":
        circ_.radius= f32(val)
    case "r":
        circ_.radius = f32(val)
    case:
        lua.L_error(L, "invalid field: %s", ind)
        return 0
    }
    return 0
}

// __tostring for circle
lua_circle_tostring :: proc "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()


    circ_ := cast(^circle)lua.L_checkudata(L, 1, "CircleMT")
    buf: [128]byte
    result := fmt.bprintf(buf[:], "Circle(x=%.2f, y=%.2f, radius=%.2f)",
                          circ_.x, circ_.y, circ_.radius)
    lua.pushstring(L, strings.clone_to_cstring(result))
    return 1
}

// get ellipse point

lua_get_ellipse_point :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	ellipse_ := cast(^Ellipse)lua.L_checkudata(L, 1, "EllipseMT")
	context = runtime.default_context()

    ind := lua.L_checkstring(L, 2)

    point_ := ellipse_.center

    switch ind {
    case "X": fallthrough
    case "x":
    	lua.pushnumber(L, lua.Number( point_.x))
     	return 1
    case "Y": fallthrough
    case "y":
   		lua.pushnumber(L, lua.Number( point_.y))
    	return 1
    case "rh":
   		lua.pushnumber(L, lua.Number(ellipse_.radiush))
    	return 1
    case "rv":
   		lua.pushnumber(L, lua.Number(ellipse_.radiusv))
    	return 1
    case:
        lua.L_error(L, "invalid field: %s", ind)
        return 0
    }
    return 0


}

// set ellipse point

lua_set_ellipse_point :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	ellipse_ := cast(^Ellipse)lua.L_checkudata(L, 1, "EllipseMT")
	context = runtime.default_context()

    ind := lua.L_checkstring(L, 2)
    val := lua.L_checknumber(L, 3)


    switch ind {
    case "X": fallthrough
    case "x":
        ellipse_.center.x= f32(val)
    case "Y": fallthrough
    case "y":
        ellipse_.center.y  = f32(val)
    case "rh":
        ellipse_.radiush = f32(val)
    case "rv":
        ellipse_.radiusv  = f32(val)
    case:
        lua.L_error(L, "invalid field: %s", ind)
        return 0
    }
    return 0


}

// __tostring for ellipse
lua_ellipse_tostring :: proc "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()


    ellipse_ := cast(^Ellipse)lua.L_checkudata(L, 1, "EllipseMT")
     point_ := ellipse_.center
    buf: [128]byte
    result := fmt.bprintf(buf[:], "Ellipse(x=%.2f, y=%.2f, radiush=%.2f , radiusv=%.2f )",
                           point_.x, point_.y,ellipse_.radiush,ellipse_.radiusv)
    lua.pushstring(L, strings.clone_to_cstring(result))
    return 1
}

// get poylgon

lua_get_poylgon_point :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	poly_ := cast(^Polygon)lua.L_checkudata(L, 1, "PolygonMT")
	context = runtime.default_context()

    ind := lua.L_checkstring(L, 2)

    switch ind {
    case "radius":
    	lua.pushnumber(L, lua.Number(poly_.radius))
     	return 1
    case "rot": fallthrough
    case "rotation":
   		lua.pushnumber(L, lua.Number(poly_.rotation))
    	return 1
    case "sides":
   		lua.pushinteger(L, lua.Integer(poly_.sides))
    	return 1
    case "center":
    	p := cast(^point)lua.newuserdata(L, size_of(^point))
   		p.x = poly_.center.x
     	p.y = poly_.center.y
    	return 1
    case:
        lua.L_error(L, "invalid field: %s", ind)
        return 0
    }
    return 0


}

// set polygon point

lua_set_poylgon_point :: proc "c" (L: ^lua.State) -> i32 {

	// get poylgon

	lua_get_poylgon_point :: proc "c" (L: ^lua.State) -> i32 {

		context = runtime.default_context()
		poly_ := cast(^Polygon)lua.L_checkudata(L, 1, "PolygonMT")
		context = runtime.default_context()

    ind := lua.L_checkstring(L, 2)
    val := lua.L_checknumber(L,3)

    switch ind {
    case "radius":
    	poly_.radius = f32(val)
    	return 0
    case "rot": fallthrough
    case "rotation":
  		poly_.rotation = f32(val)
   	return 0
    case "sides":
  		poly_.sides = int(val)
   	return 0
    case "x":
	   	poly_.center.x = f32(val)
	   	return 0
    case "y":
	   	poly_.center.y = f32(val)
	   	return 0
    case:
        lua.L_error(L, "invalid field: %s", ind)
        return 0
    }

	}
	return 0

}

// __tostring for polygon
lua_poylgon_tostring :: proc "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()


    poly_ := cast(^Polygon)lua.L_checkudata(L, 1, "PolygonMT")
    buf: [128]byte
    result := fmt.bprintf(buf[:], "Polygon (radius=%i, rotation=%.2f, sides=%.2f , centerx=%.2f ,centery=%.2f )",
                          poly_.radius,poly_.rotation,poly_.sides,poly_.center.x,poly_.center.y)
    lua.pushstring(L, strings.clone_to_cstring(result))
    return 1
}

// ellipse meta table
ellipse_meta := []lua.L_Reg{

    {"__index", lua_get_ellipse_point},
    {"__newindex", lua_set_ellipse_point},
    {"__tostring", lua_ellipse_tostring},
   /* {"size", pointarray_size},
    {"get", pointarray_index  },
    {"set", pointarray_set  }, */
    {nil, nil},
}

// polygon meta table
polygon_meta := []lua.L_Reg{

    {"__index", lua_get_poylgon_point},
    {"__newindex", lua_set_poylgon_point},
    {"__tostring", lua_poylgon_tostring},
   /* {"size", pointarray_size},
    {"get", pointarray_index  },
    {"set", pointarray_set  }, */
    {nil, nil},
}

// triangle meta table
triangle_meta := []lua.L_Reg{

    {"__index", lua_get_triangle_point},
    {"__newindex", lua_set_triangle_point},
    {"__tostring", lua_triangle_tostring},
   /* {"size", pointarray_size},
    {"get", pointarray_index  },
    {"set", pointarray_set  }, */
    {nil, nil},
}


// circle meta table
circle_meta := []lua.L_Reg{

    {"__index", lua_getcircleindex},
    {"__newindex", lua_setcircle},
    {"__tostring", lua_circle_tostring},
   /* {"size", pointarray_size},
    {"get", pointarray_index  },
    {"set", pointarray_set  }, */
    {nil, nil},
}

// rectangle meta table
rect_meta := []lua.L_Reg{

    {"__index", lua_getrectindex},
    {"__newindex", lua_setrect},
    {"__tostring", lua_rect_tostring},
  /* {"size", pointarray_size},
    {"get", pointarray_index  },
    {"set", pointarray_set  },
    */
    {nil, nil},
}

pointarray_methods := []lua.L_Reg{
    {"size", pointarray_size},
    {"get", pointarray_index  },
    {"set", pointarray_set  },
    {nil, nil},
}

pointarray_meta := []lua.L_Reg{
	{"size", pointarray_size},
	{"__index", nil},  // Will be set to pointarray_methods
	{"__tostring", pointarray_string},

/*    {"__newindex",  lua_setpoint},
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
    {"newrectangle",  lua_newrectangle},
    {"newcircle",  lua_newcircle},
    {"newtriangle",  lua_newtriangle},
    {"newellipse",  lua_newellipse},
    {"newpolygon",  lua_newpolygon},
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

// create new rectangle
lua_newrectangle :: proc "c" (L: ^lua.State) -> i32  {

	context = runtime.default_context()
	x := lua.L_checknumber(L,1)
	y := lua.L_checknumber(L,2)
	w := lua.L_checknumber(L,3)
	h := lua.L_checknumber(L,4)


	v:= cast(^rectangle)lua.newuserdata(L, size_of(rectangle))
	v.x = f32(x)
	v.y = f32(y)
	v.width = f32(w)
	v.height = f32(h)

	// userdata is already on the Lua stack
	lua.L_setmetatable(L, "RectangleMT")
	return 1
}

// create new triangle
// newtrianlge(p1,p2,p3)
lua_newtriangle :: proc "c" (L: ^lua.State) -> i32  {

	context = runtime.default_context()
	p1_ := cast(^point)lua.L_checkudata(L, 1, "PointMT")
	p2_ := cast(^point)lua.L_checkudata(L, 2, "PointMT")
	p3_ := cast(^point)lua.L_checkudata(L, 3, "PointMT")

	t:= cast(^triangle)lua.newuserdata(L, size_of(triangle))
	t.p1 = p1_^
	t.p2 = p2_^
	t.p3 = p3_^

	lua.L_setmetatable(L, "TriangleMT")
	return 1
}

// create new circle
lua_newcircle :: proc "c" (L: ^lua.State) -> i32  {

	context = runtime.default_context()
	x := lua.L_checknumber(L,1)
	y := lua.L_checknumber(L,2)

	r := lua.L_checknumber(L,3)


	v:= cast(^circle)lua.newuserdata(L, size_of(circle))
	v.x = f32(x)
	v.y = f32(y)
	v.radius = f32(r)


	lua.L_setmetatable(L, "CircleMT")
	return 1
}

// create new ellipse
lua_newellipse :: proc "c" (L: ^lua.State) -> i32  {

	context = runtime.default_context()


	p1_ := cast(^point)lua.L_checkudata(L, 1, "PointMT")

	rh := lua.L_checknumber(L,2)
	rv := lua.L_checknumber(L,3)


	e:= cast(^Ellipse)lua.newuserdata(L, size_of(Ellipse))

	 e.center.x = f32(p1_.x)
	 e.center.y = f32(p1_.y)
	e.radiush = f32(rh)
	e.radiusv = f32(rv)

	// userdata is already on the Lua stack
	lua.L_setmetatable(L, "EllipseMT")
	return 1
}

// create new polygon
lua_newpolygon:: proc "c" (L: ^lua.State) -> i32  {

	context = runtime.default_context()
	center_ := cast(^point)lua.L_checkudata(L, 1, "PointMT")
	sides := lua.L_checknumber(L,2)
	radius := lua.L_checknumber(L,3)
	rotation := lua.L_checknumber(L,4)

	p:= cast(^Polygon)lua.newuserdata(L, size_of(Polygon))
	p.center.x = center_.x
	p.center.y = center_.y

	p.sides = int(sides)
	p.rotation = f32(rotation)
	p.radius = f32(radius)


	// userdata is already on the Lua stack
	lua.L_setmetatable(L, "PolygonMT")
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

    lua.L_newmetatable(L, "RectangleMT")
    lua.L_setfuncs(L, raw_data(rect_meta), 0)
    lua.pop(L, 1)

    lua.L_newmetatable(L, "CircleMT")
    lua.L_setfuncs(L, raw_data(circle_meta), 0)
    lua.pop(L, 1)

    lua.L_newmetatable(L, "TriangleMT")
    lua.L_setfuncs(L, raw_data(triangle_meta), 0)
    lua.pop(L, 1)

    lua.L_newmetatable(L, "EllipseMT")
    lua.L_setfuncs(L, raw_data(ellipse_meta), 0)
    lua.pop(L, 1)

    lua.L_newmetatable(L, "PolygonMT")
    lua.L_setfuncs(L, raw_data(polygon_meta), 0)
    lua.pop(L, 1)

	lua.L_newlib(L, shapeslib)

	return 1
}
