-- spritesheet

local draw_ = require("drawing")
local window = require("window")
local color = require("colors")
local image = require("image")
local shapes_ = require("shapes")
local texture = require("texture")

function init()


    local width = 640
    local height = 320


    window.title("New Game")
    window.set_window_position(200,100)
    window.set_width_height(width,height)

    Img_ = image.load_image("examples/resources/sheet_example.png")
    P1 = shapes_.newpoint(3, 4)
    P2 = shapes_.newpoint(100, 4)

    Text_ = texture.texture_from_image(Img_)

end

function update()



end

function draw()


    draw_.clear_background(color.BLACK)
    texture.draw_as_spritesheet(Text_, 0, P1, 32,32) -- draw sprite 0 in sheet width, heigth 32
    texture.draw_as_spritesheet(Text_, 1, P2) -- draw sprite 1 in sheet width, heigth 32 as standard
end
