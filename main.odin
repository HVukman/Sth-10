package sth10

import rl "vendor:raylib"
import lua "vendor:lua/5.4"
import "core:fmt"
import "core:os"
import "core:strings"

SCREEN_WIDTH :: 800
SCREEN_HEIGHT :: 450
STANDARD_TITLE :: "STH-10 GAME"


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
	defer rl.CloseWindow()

	lua.getglobal(L, cstring("init"))
		if lua.isfunction(L, -1) {
			if lua.pcall(L, 0, 0, 0) != 0 {
				err_msg = lua.tostring(L, 1)
				lua.pop(L, 1)
				fmt.println(" No init found in file :", lua.tostring(L, -1))

			}
		}



	for !rl.WindowShouldClose() {
		if err_msg == ""{

			lua.getglobal(L, cstring("update"))
				if lua.isfunction(L, -1) {

					if lua.pcall(L, 0, 0, 0) != 0 {
						err_msg = lua.tostring(L, 1)
						lua.pop(L, 1)
						fmt.println(" No update found in file :", lua.tostring(L, -1))
						break
					}
				}
		}

		if err_msg == ""{

			lua.getglobal(L, cstring("draw"))
				if lua.isfunction(L, -1) {

					if lua.pcall(L, 0, 0, 0) != 0 {
						err_msg = lua.tostring(L, 1)
						fmt.println(err_msg)
						lua.pop(L, 1)
						fmt.println(" No draw found in file ", lua.tostring(L, -1))
						return
					}
				}

		}

		rl.BeginDrawing()
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
    lua.L_requiref(L, "shapes" , lua_openshapes,0)
    lua.L_requiref(L, "colors" , luacolor_open ,0)
    lua.L_requiref(L, "drawing" , lua_opendraw  ,0)
    lua.L_requiref(L, "window" , lua_openwindow ,0)
    lua.L_requiref(L, "image" , lua_openimage ,0)
    lua.L_requiref(L, "texture" , lua_opentexture ,0)
    lua.L_requiref(L, "array" , luaarray_open ,0)
    lua.L_requiref(L, "mathlib" , lua_openmath ,0)
    lua.L_requiref(L, "keys" , luakey_open , 0)
    lua.L_requiref(L, "text" , luatext_open , 0)
    lua.L_requiref(L, "mouse" , luamouse_open , 0)
    // register functions
	register(L)

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
