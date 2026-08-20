package collision


import "core:fmt"
import lua "vendor:lua/5.4"
import "core:c/libc"
import "base:runtime"
import rl "vendor:raylib"
import "core:strings"
import "core:os"
import "../shapes"

lua_collision_circle_rec :: proc "c" ( L: ^lua.State) -> i32 {

	circ_ := cast(^shapes.circle)lua.L_checkudata(L, 1, "CircleMT")
	rect_ := cast(^shapes.rectangle)lua.L_checkudata(L, 2, "RectangleMT")


	rect1 :rl.Rectangle
	rect1.x = rect_.x
	rect1.y = rect_.y
	rect1.width = rect_.width
	rect1.height = rect_.width

	center : rl.Vector2
	center.x = circ_.x
	center.y = circ_.y
	radius := circ_.radius

	res := rl.CheckCollisionCircleRec(center,radius,rect1)

	lua.pushboolean(L,b32(res))
    return 1
}


lua_collision_recs :: proc "c" ( L: ^lua.State) -> i32 {

	rect_ := cast(^shapes.rectangle)lua.L_checkudata(L, 1, "RectangleMT")
	rect2_ := cast(^shapes.rectangle)lua.L_checkudata(L, 2, "RectangleMT")

	rect1 :rl.Rectangle
	rect1.x = rect_.x
	rect1.y = rect_.y
	rect1.width = rect_.width
	rect1.height = rect_.width

	rect2 :rl.Rectangle
	rect2.x = rect2_.x
	rect2.y = rect2_.y
	rect2.width = rect2_.width
	rect2.height = rect2_.width

	res := rl.CheckCollisionRecs(rect1,rect2)

	lua.pushboolean(L,b32(res))
    return 1
}

lua_collisionlib := []lua.L_Reg{
	{"collision_rects", lua_collision_recs },
	{"collision_circ_rect", lua_collision_circle_rec},
    {nil, nil},
}

luacollision_open :: proc "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()
    lua.L_newlib(L, lua_collisionlib)


    return 1
}
