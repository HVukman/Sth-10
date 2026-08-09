-- main.lua

local draw_ = require("drawing")
local window = require("window")
local color = require("colors")


function init()


    local width = 1280
    local height = 640


    window.title("New Game")
    window.set_window_position(200,100)
    window.set_width_height(width,height)


end

function update()



end

function draw()


    draw_.clear_background(color.BLACK)

end
