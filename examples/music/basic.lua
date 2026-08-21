-- main.lua
local shapes_ = require("shapes")
local color = require("colors")
local draw_ = require("drawing")
local window = require("window")
local text   = require("text")
local music = require("music")
local table_ = {}
local limit = 100000

-- music has to be loaded in init at least
--    will not work
--    track = music.load_music("examples/resources/Sample.mp3")
function init()

    track = music.load_music("examples/resources/Sample.mp3")
    local width = 640
    local height = 480
    P2 = shapes_.newpoint(100, 100)
    print("valid ", music.is_valid_music(track))
    music.play_music(track)
end

function update()

    music.update_music_stream(track)
   -- print("played " ,music.get_time_played(track))
end

function draw()


    draw_.clear_background(color.BLACK)
    text.draw_text("you should hear music", P2, 16, color.GREEN)

end
