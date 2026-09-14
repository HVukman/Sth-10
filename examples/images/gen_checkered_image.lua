-- Generate checkerboard image

local draw_ = require("drawing")
local window = require("window")
local color = require("colors")
local image = require("image")
local shapes_ = require("shapes")
local texture = require("texture")

local function init()


    local width = 1280
    local height = 640


    window.title("Checkered Image")
    window.set_window_position(200,100)
    window.set_width_height(width,height)

    --  image.gen_checkered_image(width, height, checksx, checksy, color, color2 )
    Img_ = image.gen_checkered_image(640,480,32,32, color.BLACK, color.WHITE)
    P1 = shapes_.newpoint(3, 4)
    Text_ = texture.texture_from_image(Img_)

end


local function draw()


    draw_.clear_background(color.BLACK)
    texture.draw(Text_, P1)

end

return {init,draw}
