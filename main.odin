package sth10

import rl "vendor:raylib"
import lua "vendor:lua/5.4"
import "core:fmt"
import "core:os"
import "core:strings"

import mouse "libs/mouse"
import color "libs/colors"
import text "libs/text"
import shapes "libs/shapes"
import draw "libs/draw"
import window "libs/window"
import img "libs/images"
import texture "libs/textures"
import array "libs/array"
import mathlib "libs/math"
import keys "libs/keys"
import sounds "libs/sounds"
import music "libs/music"
import gui "libs/gui"

main_loop :: proc( ) {

	succ:= lua.L_loadfile(L,program)

	if succ != lua.Status.ERRFILE{
		if lua.pcall(L, 0, 0, 0) != 0 {
			err_msg = lua.tostring(L, 1)
			lua.pop(L, 1)
			fmt.println(" File cannot be loaded ")
			return
		}


	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, STANDARD_TITLE)
	rl.InitAudioDevice()
	defer rl.CloseWindow()
	defer rl.CloseAudioDevice()
	lua.getglobal(L, cstring("init"))
		if lua.isfunction(L, -1) {
			if lua.pcall(L, 0, 0, 0) != 0 {
				err_msg = lua.tostring(L, 1)
				lua.pop(L, 1)
				fmt.println(" Error in init :", lua.tostring(L, -1))

			}
		}



	for !rl.WindowShouldClose() {
		if err_msg == ""{

			lua.getglobal(L, cstring("update"))
				if lua.isfunction(L, -1) {

					if lua.pcall(L, 0, 0, 0) != 0 {
						err_msg = lua.tostring(L, 1)
						lua.pop(L, 1)
						fmt.println(" Error in update :", lua.tostring(L, -1))
						break
					}
				}
		}

		rl.BeginDrawing()
		if err_msg == ""{

			lua.getglobal(L, cstring("draw"))
				if lua.isfunction(L, -1) {

					if lua.pcall(L, 0, 0, 0) != 0 {
						err_msg = lua.tostring(L, 1)
						fmt.println(err_msg)
						lua.pop(L, 1)
						fmt.println(" Error in draw ", lua.tostring(L, -1))
						return
					}
				}

		}


	//	rl.ClearBackground(rl.RAYWHITE)
		rl.EndDrawing()

	}
	}
}

L : ^lua.State
program : cstring
err_msg : cstring
debug : bool

main :: proc ( ) {


	L = lua.L_newstate() // Create a new Lua state
    defer lua.close(L) // Clean up later

    if L == nil {
            fmt.println("Failed to create Lua state");
            return;
        }

    lua.L_openlibs(L); // Load Lua standard libraries

    // Libraries
    lua.L_requiref(L, "shapes" , shapes.lua_openshapes,0)
    lua.L_requiref(L, "colors" , color.luacolor_open ,0)
    lua.L_requiref(L, "drawing" , draw.lua_opendraw  ,0)
    lua.L_requiref(L, "window" , window.lua_openwindow ,0)
    lua.L_requiref(L, "image" , img.lua_openimage ,0)
    lua.L_requiref(L, "texture" , texture.lua_opentexture ,0)
    lua.L_requiref(L, "array" , array.luaarray_open ,0)
    lua.L_requiref(L, "mathlib" , mathlib.lua_openmath ,0)
    lua.L_requiref(L, "keys" , keys.luakey_open , 0)
    lua.L_requiref(L, "text" , text.luatext_open , 0)
    lua.L_requiref(L, "mouse" , mouse.luamouse_open , 0)
    lua.L_requiref(L, "sound" , sounds.luasound_open , 0)
     lua.L_requiref(L, "music" , music.luamusic_open , 0)
    lua.L_requiref(L, "gui" , gui.luagui_open , 0)


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
