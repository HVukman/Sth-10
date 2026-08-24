-- input mouse wheel
local shapes_ = require("shapes")
local color = require("colors")
local draw_ = require("drawing")
local window = require("window")
local text   = require("text")
local mouse   = require("mouse")

local speed = 4

local height = 640
function init()

    local width   = 1280
    window.title("Mouse Wheel")
    window.set_width_height(width,height)
    R1 = shapes_.newrectangle(width / 2 - 200, height / 2, 200, 200)

end

function update()
    R1.y = R1.y + mouse.get_mousewheel_move()*speed

end

function draw()

    draw_.clear_background(color.BLACK)
    draw_.rectangle(R1, color.YELLOW)

end
