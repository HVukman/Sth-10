-- hello world
local shapes_ = require("shapes")
local color = require("colors")
local draw_ = require("drawing")
local window = require("window")
local array = require("array")
local text   = require("text")



function init()


    local width = 1280
    local height = 640

    window.title("Hello World")
    window.set_width_height(width,height)
    P1 = shapes_.newpoint(width/2, height/2)

end

function update()


end

function draw()

    draw_.clear_background(color.BLACK)
    text.draw_text("hello world", P1, 16, color.GREEN)

end
