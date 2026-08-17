package sth10

// music module

import "base:runtime"// or whatever version you want
import "core:c/libc"
import "core:fmt"
import "core:os"
import "core:strings"
import lua "vendor:lua/5.4"
import rl "vendor:raylib"


// Sound userdata wrapper
MusicData :: struct {
	music: rl.Music,
	length : f32,
}



lua_load_music :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	file := lua.L_checkstring(L, 1)

	if os.is_file(strings.clone_from_cstring(file)) {
		music := rl.LoadMusicStream(file)
		if rl.IsMusicValid(music) {
			fmt.printfln("succesfully loaded music %s", file)
			music_ := cast(^MusicData)lua.newuserdata(L, size_of(MusicData))
			music_.music = music
			music_.length = rl.GetMusicTimeLength(music)
			lua.L_setmetatable(L, "MusicMT")
			return 1
		} else {
			fmt.println("invalid music  %s ", file)
			lua.L_error(L, "invalid music")
			return 0
		}
	} else {

		lua.L_error(L, "invalid file  %s", file)
		return 0
	}


}

lua_set_music_volume :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	music := cast(^MusicData)lua.L_checkudata(L, 1, "MusicMT")
	vol := lua.L_checknumber(L,2)
	rl.SetMusicVolume(music.music , f32(vol))
	return 0
}

lua_set_music_pitch :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	music := cast(^MusicData)lua.L_checkudata(L, 1, "MusicMT")
	vol := lua.L_checknumber(L,2)
	rl.SetMusicPitch(music.music , f32(vol))
	return 0
}

lua_set_music_pan:: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	music := cast(^MusicData)lua.L_checkudata(L, 1, "MusicMT")
	vol := lua.L_checknumber(L,2)
	rl.SetMusicPan(music.music , f32(vol))
	return 0
}

lua_seek_music:: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	music := cast(^MusicData)lua.L_checkudata(L, 1, "MusicMT")
	seek := lua.L_checknumber(L,2)
	rl.SeekMusicStream(music.music , f32(seek))
	return 0
}

lua_play_music :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	music := cast(^MusicData)lua.L_checkudata(L, 1, "MusicMT")

	rl.PlayAudioStream(music.music)
	return 0
}

lua_stop_music :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	music := cast(^MusicData)lua.L_checkudata(L, 1, "MusicMT")

	rl.StopMusicStream(music.music)
	return 0
}

lua_resume_music :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	music := cast(^MusicData)lua.L_checkudata(L, 1, "MusicMT")

	rl.ResumeMusicStream(music.music)
	return 0
}

lua_pause_music :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	music := cast(^MusicData)lua.L_checkudata(L, 1, "MusicMT")

	rl.PauseMusicStream(music.music)
	return 0
}


lua_is_music_playing :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	music := cast(^MusicData)lua.L_checkudata(L, 1, "MusicMT")
	lua.pushboolean(L, b32(rl.IsMusicStreamPlaying(music.music)))
	return 1
}

lua_valid_music :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	music := cast(^MusicData)lua.L_checkudata(L, 1, "MusicMT")
	lua.pushboolean(L, b32(rl.IsMusicValid(music.music)))
	return 1
}


lua_music_gc :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	music := cast(^MusicData)lua.L_checkudata(L, 1, "MusicMT")
	rl.UnloadMusicStream(music.music)
	return 0
}


 lua_update_music:: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	music := cast(^MusicData)lua.L_checkudata(L, 1, "MusicMT")
	rl.UpdateMusicStream(music.music)
	return 0
}

lua_music_tostring :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	music := cast(^MusicData)lua.L_checkudata(L, 1, "MusicMT")
	res := fmt.tprintf("Music: Length %.2f Channels %i SampleSize : %i", rl.GetMusicTimeLength(music.music), music.music.channels,music.music.sampleSize)
	lua.pushstring(L, strings.clone_to_cstring(res))
	return 1
}




lua_musiclib := []lua.L_Reg {

	{"is_valid_music", lua_valid_music},
	{"load_music", lua_load_music},
	{"play_music", lua_play_music},
	{"stop_music", lua_stop_music},
	{"pause_music", lua_pause_music},
	{"play_music", lua_play_music},
	{"set_pitch", lua_set_music_pitch },
		{"set_pan", lua_set_music_pan},
			{"set_volume", lua_set_music_volume },
	{"resume_music", lua_resume_music},
	{"is_music_playing", lua_is_music_playing},
	{"update_music_stream", lua_update_music},
	{"seek_music", lua_seek_music},
	{nil, nil},
}



music_meta := []lua.L_Reg {
	/*   {"__index", lua_getpointindex  },
    {"__newindex",  lua_setpoint},
    */
	{"__tostring", lua_music_tostring},
	/* {"__add", lua_point_add},
    {"__sub", lua_point_sub},
    {"__mul", lua_point_mul}, */
	{"__gc", lua_music_gc},
	{nil, nil},
}

luamusic_open :: proc "c" (L: ^lua.State) -> i32 {
	context = runtime.default_context()

	lua.L_newmetatable(L, "MusicMT")
	lua.L_setfuncs(L, raw_data(music_meta), 0)
	lua.pop(L, 1)



	lua.L_newlib(L, lua_musiclib)

	return 1
}
