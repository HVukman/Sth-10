-- hello world with font from image
--
local shapes_ = require("shapes")
local color = require("colors")
local draw_ = require("drawing")
local window = require("window")
local array = require("array")
local text   = require("text")

local NewFont
local P1

local function init()


    local width = 1280
    local height = 640

    window.title("Hello World")
    window.set_width_height(width,height)
    P1 = shapes_.newpoint(width/2, height/2)
    NewFont = text.load_font("examples/resources/pixantiqua.fnt")
end



function draw()

    draw_.clear_background(color.BLACK)
    text.draw_text_ex(NewFont, "hello world", P1, 23, 5, color.PINK)

end

return {init,draw}
