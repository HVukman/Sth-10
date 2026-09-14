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

local function init()


    buul = false
    local width = 1280
    local height = 640
    window.title("Checkbox")
    window.set_width_height(width,height)
    R1 = shapes_.newrectangle(width/2, height/2, 10, 10)
    Buttontext = "Checkbox"
    P1 = shapes_.newpoint(1,1)
end



local function draw()


    draw_.clear_background(color.BLACK)
    -- buul changes when checkbox is pressed
    buul = gui.checkbox(R1,Buttontext,buul) -- return buul; the value to be changed

    if buul then
        text_.draw_text("buul is true", P1, 20, color.GREEN)
    else
        text_.draw_text("buul is not true", P1, 20, color.GREEN)
    end

end


return {init,draw}
