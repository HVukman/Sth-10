-- compare ditherings

local draw_ = require("drawing")
local window = require("window")
local color = require("colors")
local image = require("image")
local shapes_ = require("shapes")
local texture = require("texture")
local text_ = require("text")

local function init()


    local width = 1280
    local height = 640


    window.title("Compare Ditherings")
    window.set_window_position(200,100)
    window.set_width_height(width,height)

    Img_ = image.load_image("examples/resources/parrots.png")
    Img2_ = image.copy_image(Img_)

    P1 = shapes_.newpoint(3, 4)
    P2 = shapes_.newpoint(500, 4)

    Img_ = image.dither(Img_)
    Img2_ = image.dither_atkinson(Img2_)

    Text_ = texture.texture_from_image(Img_)
    Text2_ = texture.texture_from_image(Img2_)
end


local function draw()


    draw_.clear_background(color.BLACK)
    texture.draw(Text_, P1)
    texture.draw(Text2_, P2)

    local P3 = shapes_.newpoint(3, 500)
    local P4 = shapes_.newpoint(500, 500)

    local textsize = 22
    text_.draw_text("4x4 Bayer Dither", P3, textsize, color.GREEN)
    text_.draw_text("Atkinson Dither", P4, textsize, color.GREEN)
end

return {init,draw}
