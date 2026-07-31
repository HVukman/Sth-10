package sth10

import rl "vendor:raylib"
import lua "vendor:lua/5.4"
import "core:fmt"

SCREEN_WIDTH :: 800
SCREEN_HEIGHT :: 450
STANDARD_TITLE :: "STH-10 GAME"


main_loop :: proc( ) {
	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, STANDARD_TITLE)

	defer rl.CloseWindow()
	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.RAYWHITE)
		rl.EndDrawing()

	}

}

main :: proc ( ) {

	L := lua.L_newstate(); // Create a new Lua state
    defer lua.close(L); // Clean up later

    if L == nil {
            fmt.println("Failed to create Lua state");
            return;
        }

    lua.L_openlibs(L); // Load Lua standard libraries
	main_loop()
}
