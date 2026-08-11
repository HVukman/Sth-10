-- main.lua

local draw_ = require("drawing")
local window = require("window")
local color = require("colors")
local shapes_ = require("shapes")
local gui = require("gui")

function init()


    local width = 1280
    local height = 640


    window.title("Button")
    window.set_window_position(200,100)
    window.set_width_height(width,height)

    R1 = shapes_.newrectangle(1, 2, 100, 200)
    Buttontext = "Click Me"

end

function update()




end

function draw()


    draw_.clear_background(color.BLACK)
    local s = gui.button(R1,Buttontext)
    if s then

    end
end
