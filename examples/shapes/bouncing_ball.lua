-- hello world
local shapes_ = require("shapes")
local color = require("colors")
local draw_ = require("drawing")
local window = require("window")
local text   = require("text")
local keys  = require("keys")
local radius = 20

local use_gravity = true
local gravity = 0.2
local width = 1280
local height = 640

function init()

    window.title("Bouncing Ball")
    window.set_width_height(width,height)

    Ball_speed = shapes_.newpoint(0.0,-0.4)
    P1 = shapes_.newcircle(250, 130,radius)


end

function update()


    P1.x = P1.x + Ball_speed.x
    P1.y = P1.y + Ball_speed.y

    if use_gravity then
       P1.y = P1.y + gravity
    end

    if P1.x >= (width - radius) or P1.x <= radius then
           Ball_speed.x = -1.0*Ball_speed.x
    end
    if P1.y >= (height - radius) or P1.y <= radius then
           Ball_speed.y = -0.95*Ball_speed.y
    end

    if keys.key_pressed(keys.SPACE) then
        if use_gravity then

           use_gravity = false
       else
           use_gravity = true
       end
   end



end

function draw()

    draw_.clear_background(color.BLACK)
    draw_.circle(P1, color.PURPLE)

end
