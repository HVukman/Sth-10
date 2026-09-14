-- draw button and press it

local draw_ = require("drawing")
local window = require("window")
local color = require("colors")
local shapes_ = require("shapes")
local gui = require("gui")

local function init()


    local width = 1280
    local height = 640
    window.title("Button")
    window.set_width_height(width,height)
    R1 = shapes_.newrectangle(width/2, height/2, 100, 100)
    Buttontext = "Click Me"

end



local function draw()


    draw_.clear_background(color.BLACK)
    local s = gui.button(R1,Buttontext)
    if s then
        print("Pressed me!")
    end
end


return {init,draw}
