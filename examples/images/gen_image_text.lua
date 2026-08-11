--

local draw_ = require("drawing")
local window = require("window")
local color = require("colors")
local image = require("image")
local shapes_ = require("shapes")
local texture = require("texture")

function init()


    local width = 1280
    local height = 640


    window.title("Text image")
    window.set_window_position(200,100)
    window.set_width_height(width,height)

    --  image.gen_text (width, height,text )
    Img_ = image.gen_text(640,480,"bleep bllop")
    P1 = shapes_.newpoint(3, 4)
    Text_ = texture.texture_from_image(Img_)

end

function update()



end

function draw()
    draw_.clear_background(color.BLACK)
    texture.draw(Text_, P1)
end
