package sth10

import "vendor:stb/rect_pack"
import "core:fmt"
import "core:os"
import "core:strings"
import lua "vendor:lua/5.4"
import rl "vendor:raylib"

import array "libs/array"
import collision "libs/collision"
import color "libs/colors"
import draw "libs/draw"
import gamepad "libs/gamepad"
import gui "libs/gui"
import img "libs/images"
import keys "libs/keys"
import mathlib "libs/math"
import mouse "libs/mouse"
import music "libs/music"
import os_ "libs/os"
import shapes "libs/shapes"
import sounds "libs/sounds"
import text "libs/text"
import texture "libs/textures"
import window "libs/window"

import hm "core:container/handle_map"
import texture2 "libs/texture2"

main_loop :: proc() {




	succ := lua.L_loadfile(L, program)
	// loading the chunk into the program
	if succ != lua.Status.ERRFILE {
		if lua.pcall(L, 0, 1, 0) != 0 { // return the table therefore 1
			err_msg = lua.tostring(L, -1)
			fmt.println(" File cannot be loaded: ", err_msg)
			lua.pop(L, 1)
			return
		}
		// safe reference
		script_ref := lua.L_ref(L, lua.REGISTRYINDEX)

		rl.InitWindow(window.SCREEN_WIDTH, window.SCREEN_HEIGHT, window.STANDARD_TITLE)
		rl.SetTargetFPS(60) // if not otherwise
		rl.InitAudioDevice()
		defer rl.CloseWindow()
		defer rl.CloseAudioDevice()
		/*
		lua.getglobal(L, cstring("init"))
		if lua.isfunction(L, -1) {
			if lua.pcall(L, 0, 0, 0) != 0 {
				err_msg = lua.tostring(L, -1)
				lua.pop(L, 1)
				fmt.println(" Error in init :", err_msg)
				return
			}
		}
		*/

		// call first function as init
		// get reference
		lua.rawgeti(L, lua.REGISTRYINDEX, lua.Integer(script_ref))
		// get the table
		lua.pushinteger(L, 1)
		lua.gettable(L, -2)

		if (lua.pcall(L, 0, 0, 0) != 0) {
			err_msg = lua.L_checkstring(L,-1)
			fmt.println("error calling init function")
			fmt.println(err_msg)
			lua.pop(L, 1)
			return
		}


		mainloop: for !rl.WindowShouldClose() {
			rl.BeginDrawing()
			// call one function from stack
			//

					lua.pushinteger(L, 2)
					lua.gettable(L, -2)

					if (lua.pcall(L, 0, 0, 0) != 0) {
						err_msg = lua.L_checkstring(L,-1)
						fmt.println("error calling update function")
						fmt.println(err_msg)
						lua.pop(L, 1)
						break mainloop

			}

			//	rl.ClearBackground(rl.RAYWHITE)
			rl.EndDrawing()

		}
		// Remove the table after end
		lua.pop(L, 1)
	}
}

L: ^lua.State
program: cstring
err_msg: cstring
debug: bool

init_func: cstring
update_func: cstring
draw_func: cstring


main :: proc() {

	hm.dynamic_init(&texture2.entities, context.allocator)
	defer hm.dynamic_destroy(&texture2.entities)

	L = lua.L_newstate() // Create a new Lua state
	defer lua.close(L) // Clean up later

	if L == nil {
		fmt.println("Failed to create Lua state")
		return
	}

	lua.L_openlibs(L) // Load Lua standard libraries

	// Libraries
	lua.L_requiref(L, "shapes", shapes.lua_openshapes, 0)
	lua.L_requiref(L, "colors", color.luacolor_open, 0)
	lua.L_requiref(L, "drawing", draw.lua_opendraw, 0)
	lua.L_requiref(L, "window", window.lua_openwindow, 0)
	lua.L_requiref(L, "image", img.lua_openimage, 0)
	lua.L_requiref(L, "texture", texture.lua_opentexture, 0)
	lua.L_requiref(L, "array", array.luaarray_open, 0)
	lua.L_requiref(L, "mathlib", mathlib.lua_openmath, 0)
	lua.L_requiref(L, "keys", keys.luakey_open, 0)
	lua.L_requiref(L, "text", text.luatext_open, 0)
	lua.L_requiref(L, "mouse", mouse.luamouse_open, 0)
	lua.L_requiref(L, "sound", sounds.luasound_open, 0)
	lua.L_requiref(L, "music", music.luamusic_open, 0)
	lua.L_requiref(L, "gui", gui.luagui_open, 0)
	lua.L_requiref(L, "oslib", os_.luaos_open, 0)
	lua.L_requiref(L, "collision", collision.luacollision_open, 0)
	lua.L_requiref(L, "gamepad", gamepad.luagamepad_open, 0)

	lua.L_requiref(L, "texture2", texture2.lua_opentexture, 0)

	// run the program with arguments


	if len(os.args) > 1 {

		for i := 1; i < len(os.args); i += 1 {
			fmt.println(" arg ", os.args[i])
			if os.is_file(os.args[i]) {
				fmt.println("is file")
				program = strings.clone_to_cstring(os.args[i])

			} else if os.args[i] == "-debug" {
				debug = true
			} else if os.args[i] == "-resizable" {
				rl.SetConfigFlags({rl.ConfigFlag.WINDOW_RESIZABLE})
			} else if os.args[i] == "-unfocused" {
				rl.SetConfigFlags({rl.ConfigFlag.WINDOW_UNFOCUSED})
			} else if os.args[i] == "-undecorated" {
				rl.SetConfigFlags({rl.ConfigFlag.WINDOW_UNDECORATED})
			} else if os.args[i] == "-mouse_passthrough" {
				rl.SetConfigFlags({rl.ConfigFlag.WINDOW_MOUSE_PASSTHROUGH})
			} else if os.args[i] == "-fullscreen" {
				rl.SetConfigFlags({rl.ConfigFlag.FULLSCREEN_MODE})
			} else if os.args[i] == "-transparent" {
				rl.SetConfigFlags({rl.ConfigFlag.WINDOW_TRANSPARENT})
			} else if os.args[i] == "-top_most" {
				rl.SetConfigFlags({rl.ConfigFlag.WINDOW_TOPMOST})
			} else if os.args[i] == "-hidden" {
				rl.SetConfigFlags({rl.ConfigFlag.WINDOW_HIDDEN})
			}

		}

	}

	if program != "" {
		fmt.println("starting ", program)

	} else {
		program = "main.lua"
	}


	main_loop()


}
