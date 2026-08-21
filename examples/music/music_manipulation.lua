-- music manipulation
local shapes_ = require("shapes")
local color = require("colors")
local draw_ = require("drawing")
local text   = require("text")
local music = require("music")
local keys    = require("keys")

local played_ = ""
local pitch   = 1.0
local pan     = 0.0
local vol     = 1.0
local dummy = 0.01
-- music has to be loaded in init at least
--    will not work
--    track = music.load_music("examples/resources/Sample.mp3")
function init()

    track = music.load_music("examples/resources/Sample.mp3")
    P2 = shapes_.newpoint(100, 100)
    P3 = shapes_.newpoint(100, 130)
    P4 = shapes_.newpoint(100, 150)
    P5 = shapes_.newpoint(100, 170)
    P6 = shapes_.newpoint(100, 190)
    print( track)
    print("valid music?: ", music.is_valid_music(track))

    music.play_music(track)
end

function update()

    music.update_music_stream(track)
    played_ = string.format("played sec %.2f ", music.get_time_played(track))

    if keys.key_pressed(keys.UP) then
        pitch = pitch + dummy
    end
    if keys.key_pressed(keys.DOWN) then
        pitch = pitch - dummy
    end

    if keys.key_pressed(keys.LEFT) then
        pan= pan - dummy
    end
    if keys.key_pressed(keys.RIGHT) then
        pan = pan + dummy
    end

    if keys.key_pressed(keys.X) then
        vol = vol + dummy
    end
    if keys.key_pressed(keys.Z) then
        vol = vol - dummy
    end

    if pitch > 1.0 then
        pitch = 1.0
    end
    if pitch < 0.0 then
        pitch = 0.0
    end

    if pan > 1.0 then
        pan = 1.0
    end
    if pan < -1.0 then
        pan = -1.0
    end

    if vol > 1.0 then
        vol  = 1.0
    end
    if vol  < -1.0 then
        vol  = -1.0
    end

    if keys.key_pressed(keys.P) then
        if music.is_music_playing(track) then
            music.pause_music(track)
        else
            if music.get_time_played(track) > 0.0 then
                music.resume_music(track)
            else
                music.play_music(track)
            end

        end
    end

    if keys.key_pressed(keys.S) then
        music.stop_music(track)
    end

    music.set_pitch(track, pitch)
    music.set_pan(track, pan)
    music.set_volume(track, vol)
end

function draw()

    local textsize = 20
    draw_.clear_background(color.BLACK)
    text.draw_text("you should hear music", P2, textsize, color.GREEN)
    text.draw_text(played_, P3, textsize, color.GREEN)
    text.draw_text("Up down to change pan, left right to change pitch, x y to change volume", P4, textsize - 2, color.GREEN)
    text.draw_text(string.format("Pitch %.2f Pan %.2f Vol %.2f ", pitch, pan, vol), P5, textsize, color.GREEN)
     text.draw_text("P to pause and resume, S to stop", P6, textsize, color.GREEN)
end
