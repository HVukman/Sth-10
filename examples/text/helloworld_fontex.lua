-- hello world with expert font
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

    window.title("Font Expert")
    window.set_width_height(width,height)
    P1 = shapes_.newpoint(20, 10)
    NewFont = text.load_font_expert("examples/resources/pixantiqua.ttf",16,250)
end



local function draw()

    draw_.clear_background(color.BLACK)
    text.draw_text_ex(NewFont, [[Hello World!#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHI
                JKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmn
                opqrstuvwxyz{|}~¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓ
                ÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷
                øùúûüýþÿ]], P1, 32, 5, color.PINK)

end

return {init,draw}
