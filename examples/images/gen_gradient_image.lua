-- generate gradient images

local draw_ = require("drawing")
local window = require("window")
local color = require("colors")
local image = require("image")
local shapes_ = require("shapes")
local texture = require("texture")


local P1,Img_,Img2_,P2,Text_,Text2_

local function init()


    local width = 1280
    local height = 640


    window.title("Gradient Image")
    window.set_window_position(200,100)
    window.set_width_height(width,height)

    --  image.gen_radial_gradient_image (width, height,density, color, color2 )
    Img_ = image.gen_radial_gradient(640,480,0.1, color.BLACK, color.WHITE)
    P1 = shapes_.newpoint(3, 4)
    Text_ = texture.texture_from_image(Img_)

    --  image.gen_square_gradient_image (width, height,density, color, color2 )
    Img2_ = image.gen_square_gradient(640,480,0.01, color.RED, color.BLUE)
    P2 = shapes_.newpoint(640, 4)
    Text2_ = texture.texture_from_image(Img2_)

end

local function draw()
    draw_.clear_background(color.BLACK)
    texture.draw(Text_, P1)
    texture.draw(Text2_, P2)
end



return {init,draw}
