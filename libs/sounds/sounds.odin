package sounds

// sounds module

import "base:runtime" // or whatever version you want
import "core:c/libc"
import "core:fmt"
import "core:os"
import "core:strings"
import lua "vendor:lua/5.4"
import rl "vendor:raylib"


// Sound userdata wrapper
SoundData :: struct {
	sound: rl.Sound,
}

// Sound userdata wrapper
WaveData :: struct {
	wave: rl.Wave,
}


lua_load_sound :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	file := lua.L_checkstring(L, 1)

	if os.is_file(strings.clone_from_cstring(file)) {
		snd_ := rl.LoadSound(file)
		if rl.IsSoundValid(snd_) {
			fmt.printfln("succesfully loaded sound %s", file)
			sound := cast(^SoundData)lua.newuserdata(L, size_of(SoundData))
			sound.sound = snd_
			lua.L_setmetatable(L, "SoundMT")
			return 1
		} else {
			fmt.println("invalid sound  %s ", file)
			lua.L_error(L, "invalid sound")
			return 0
		}
	} else {

		lua.L_error(L, "invalid file  %s", file)
		return 0
	}


}

lua_set_sound_volume :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	sound := cast(^SoundData)lua.L_checkudata(L, 1, "SoundMT")
	vol := lua.L_checknumber(L, 2)
	rl.SetSoundVolume(sound.sound, f32(vol))
	return 0
}

lua_set_sound_pitch :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	sound := cast(^SoundData)lua.L_checkudata(L, 1, "SoundMT")
	pitch := lua.L_checknumber(L, 2)
	rl.SetSoundPitch(sound.sound, f32(pitch))
	return 0
}

lua_set_sound_pan :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	sound := cast(^SoundData)lua.L_checkudata(L, 1, "SoundMT")
	pan := lua.L_checknumber(L, 2)
	rl.SetSoundPan(sound.sound, f32(pan))
	return 0
}

lua_is_audiodevice_ready :: proc "c" (L: ^lua.State) -> i32 {

	lua.pushboolean(L, b32(rl.IsAudioDeviceReady()))
	return 1
}

lua_play_sound :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	sound := cast(^SoundData)lua.L_checkudata(L, 1, "SoundMT")
	rl.PlaySound(sound.sound)
	return 0
}

lua_stop_sound :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	sound := cast(^SoundData)lua.L_checkudata(L, 1, "SoundMT")
	rl.StopSound(sound.sound)
	return 0
}

lua_resume_sound :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	sound := cast(^SoundData)lua.L_checkudata(L, 1, "SoundMT")
	rl.ResumeSound(sound.sound)
	return 0
}

lua_pause_sound :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	sound := cast(^SoundData)lua.L_checkudata(L, 1, "SoundMT")
	rl.PauseSound(sound.sound)
	return 0
}


lua_is_sound_playing :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	sound := cast(^SoundData)lua.L_checkudata(L, 1, "SoundMT")
	lua.pushboolean(L, b32(rl.IsSoundPlaying(sound.sound)))
	return 1
}

lua_valid_sound :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	sound := cast(^SoundData)lua.L_checkudata(L, 1, "SoundMT")
	lua.pushboolean(L, b32(rl.IsSoundValid(sound.sound)))
	return 1
}

lua_get_master_vol :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	lua.pushinteger(L, lua.Integer(rl.GetMasterVolume()))
	return 1
}

lua_set_master_vol :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	vol := lua.L_checknumber(L, 1)
	rl.SetMasterVolume(f32(vol))
	return 0
}

lua_soundlib := []lua.L_Reg {
	{"get_master_volume", lua_get_master_vol},
	{"set_master_volume", lua_set_master_vol},
	{"is_valid_sound", lua_valid_sound},
	{"is_audiodevice_ready", lua_is_audiodevice_ready},
	{"load_sound", lua_load_sound},
	{"play_sound", lua_play_sound},
	{"stop_sound", lua_stop_sound},
	{"pause_sound", lua_pause_sound},
	{"play_sound", lua_play_sound},
	{"set_pitch", lua_set_sound_pitch},
	{"set_pan", lua_set_sound_pan},
	{"set_volume", lua_set_sound_volume},
	{"resume_sound", lua_resume_sound},
	{"is_sound_playing", lua_is_sound_playing},
	{"load_sound_from_wave", lua_sound_from_wave},
	{nil, nil},
}


lua_sound_gc :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	sound := cast(^SoundData)lua.L_checkudata(L, 1, "SoundMT")
	rl.UnloadSound(sound.sound)
	return 0
}

lua_sound_tostring :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	sound := cast(^SoundData)lua.L_checkudata(L, 1, "SoundMT")
	res := fmt.tprintf(
		"Sound SampleRate : %i SampleSize : %i",
		sound.sound.sampleRate,
		sound.sound.sampleSize,
	)
	lua.pushstring(L, strings.clone_to_cstring(res))
	return 1
}

lua_wave_tostring :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	wave := cast(^WaveData)lua.L_checkudata(L, 1, "WaveMT")
	res := fmt.tprintf(
		"Wave : Channels %i SampleSize : %i",
		wave.wave.channels,
		wave.wave.sampleSize,
	)
	lua.pushstring(L, strings.clone_to_cstring(res))
	return 1
}

lua_wave_gc :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	wav := cast(^WaveData)lua.L_checkudata(L, 1, "WaveMT")
	rl.UnloadWave(wav.wave)
	return 0
}

lua_sound_from_wave :: proc "c" (L: ^lua.State) -> i32 {

	context = runtime.default_context()
	wave := cast(^WaveData)lua.L_checkudata(L, 1, "WaveMT")

	sound := cast(^SoundData)lua.newuserdata(L, size_of(SoundData))

	if rl.IsWaveValid(wave.wave) {
		sound.sound = rl.LoadSoundFromWave(wave.wave)
		lua.L_setmetatable(L, "SoundMT")
		return 1
	} else {
		lua.L_error(L, "not a valid wave")
		return 0
	}


}

sound_meta := []lua.L_Reg {
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

wave_meta := []lua.L_Reg {
	/*   {"__index", lua_getpointindex  },
    {"__newindex",  lua_setpoint},
    */
	{"__tostring", lua_wave_tostring},
	/* {"__add", lua_point_add},
    {"__sub", lua_point_sub},
    {"__mul", lua_point_mul}, */
	{"__gc", lua_wave_gc},
	{nil, nil},
}

luasound_open :: proc "c" (L: ^lua.State) -> i32 {
	context = runtime.default_context()

	lua.L_newmetatable(L, "SoundMT")
	lua.L_setfuncs(L, raw_data(sound_meta), 0)
	lua.pop(L, 1)

	lua.L_newmetatable(L, "WaveMT")
	lua.L_setfuncs(L, raw_data(wave_meta), 0)
	lua.pop(L, 1)

	lua.L_newlib(L, lua_soundlib)

	return 1
}
