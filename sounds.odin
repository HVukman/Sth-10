package sth10

// sounds module
import "core:fmt"
import lua "vendor:lua/5.4" // or whatever version you want
import "core:c/libc"
import "base:runtime"
import rl "vendor:raylib"
import "core:strings"
import "core:os"


// Sound userdata wrapper
SoundData :: struct {
	sound : rl.Sound,
}


lua_load_sound :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	file := lua.L_checkstring(L,1)

	if os.is_file(strings.clone_from_cstring(file)) {
		snd_ := rl.LoadSound(file)
		if rl.IsSoundValid(snd_) {
			fmt.printfln("succesfully loaded sound %s", file)
			sound:= cast(^SoundData)lua.newuserdata(L, size_of(SoundData))
			sound.sound = snd_
			lua.L_setmetatable(L, "SoundMT")
			return 1
		}else{
			fmt.println("invalid sound  %s ", file)
			lua.L_error(L, "invalid sound")
			return 0
		}
	}else{

		lua.L_error(L, "invalid file  %s" , file)
		return 0
	}


}

lua_is_audiodevice_ready :: proc "c" (L: ^lua.State) -> i32 {

	lua.pushboolean(L, b32(rl.IsAudioDeviceReady()))
	return 1
}

lua_soundlib := []lua.L_Reg{

	{"is_audiodevice_ready", lua_is_audiodevice_ready},
	{"load_sound", lua_load_sound},
	{"play_sound", lua_play_sound},
    {nil, nil},
}

lua_play_sound :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	sound:= cast(^SoundData)lua.L_checkudata(L, 1 , "SoundMT")
	rl.PlaySound(sound.sound)
	return 0
}

lua_sound_gc :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	sound:= cast(^SoundData)lua.L_checkudata(L, 1 , "SoundMT")
	rl.UnloadSound(sound.sound)
	return 0
}

lua_sound_tostring :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	sound:= cast(^rl.Sound)lua.L_checkudata(L, 1 , "SoundMT")
	res := fmt.tprintf("Sound SampleRate : %i SampleSize : %i" , sound.sampleRate , sound.sampleSize)
	lua.pushstring(L, strings.clone_to_cstring(res))
	return 1
}


sound_meta := []lua.L_Reg{
 /*   {"__index", lua_getpointindex  },
    {"__newindex",  lua_setpoint},
    */
    {"__tostring", lua_sound_tostring},
  /* {"__add", lua_point_add},
    {"__sub", lua_point_sub},
    {"__mul", lua_point_mul}, */
    {"__gc", lua_sound_gc},
    {nil, nil},
}

luasound_open :: proc "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()

    lua.L_newmetatable(L, "SoundMT")
    lua.L_setfuncs(L, raw_data(sound_meta), 0)
    lua.pop(L, 1)

    lua.L_newlib(L, lua_soundlib)

    return 1
}
