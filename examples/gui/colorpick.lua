-- checkbox

local draw_ = require("drawing")
local window = require("window")
local color = require("colors")
local shapes_ = require("shapes")
local gui = require("gui")
local text_ = require("text")

local buul
local s
local P1
local Picktext

local function init()



    local width = 1280
    local height = 640
    window.title("Color")
    window.set_width_height(width,height)
    R1 = shapes_.newrectangle(width/2, height/2, 40, 40)
    Picktext = "Picker"
    P1 = shapes_.newpoint(1,1)
end



local function draw()


    draw_.clear_background(color.BLACK)
    -- buul changes when checkbox is pressed
    buul = gui.colorpicker(R1,Picktext,color.GREEN)



end


return {init,draw}
