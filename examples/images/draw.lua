-- Draw on an image

local draw_ = require("drawing")
local window = require("window")
local color = require("colors")
local image = require("image")
local shapes_ = require("shapes")
local texture = require("texture")
local text_ = require("text")

local Img_
local Img2_
local P1
local P2
local P3
local P4
local R1
local R2
local C1
local C2
local vandal_text
local Text_
local bnuuy

local sourcerect
local destrect

local function init()


    local width = 1280
    local height = 640


    window.title("Draw on image")
    window.set_window_position(200,100)
    window.set_width_height(width,height)

    Img_ = image.load_image("examples/resources/parrots.png")
    bnuuy = image.load_image("examples/resources/bunny.png")

    P1 = shapes_.newpoint(300, 4)
    P2 =  shapes_.newpoint(3, 4)
    P3 = shapes_.newpoint(500, 400)

    R1 = shapes_.newrectangle(1, 200, 10, 200)
    R2 = shapes_.newrectangle(50, 320, 80, 60)

    C1 = shapes_.newcircle(250, 130, 10)
    C2 = shapes_.newcircle(270, 140, 20)


    image.draw_pixel(Img_,P1,color.WHITE)
    image.draw_line(Img_, P2,P3, color.RED)

    image.draw_rectangle(Img_, R1, color.RAYWHITE)
    image.draw_rectangle_lines(Img_, R2, 2.3, color.PURPLE)

    image.draw_circle(Img_, C1, color.GOLD)
    image.draw_circle_lines(Img_, C2, color.PINK)

    vandal_text = "hello on image"
    P4 = shapes_.newpoint(100, 100)
    image.draw_text(Img_, vandal_text, P4, 22, color.BLUE)

    sourcerect = shapes_.newrectangle(0, 0, 32,32)
    destrect = shapes_.newrectangle(40, 200, 32, 32)

    image.draw_image(Img_, bnuuy, sourcerect, destrect, color.WHITE)


    Text_ = texture.texture_from_image(Img_)



end


local function draw()

    draw_.clear_background(color.BLACK)
    texture.draw(Text_, P1)

    local PP = shapes_.newpoint(3, 500)
    local textsize = 22
    text_.draw_text("Vandalize image", PP, textsize, color.GREEN)

end

return {init,draw}
