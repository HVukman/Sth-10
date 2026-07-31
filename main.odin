package sth10

import rl "vendor:raylib"
import lua "vendor:lua/5.4"

SCREEN_WIDTH :: 800
SCREEN_HEIGHT :: 450
STANDARD_TITLE :: "STH-9 GAME"


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

	main_loop()
}
