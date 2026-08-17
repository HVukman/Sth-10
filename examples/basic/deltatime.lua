-- hello world
local shapes_ = require("shapes")
local color = require("colors")
local draw_ = require("drawing")
local window = require("window")
local text   = require("text")
local mouse   = require("mouse")

local speed = 10.0
local radius = 30

local width = 1280
local height = 640

local currfps = 30

function init()


    window.title("Delta Time")
    window.set_width_height(width,height)
    C1 = shapes_.newcircle(0, 150, radius)
    C2 = shapes_.newcircle(0, 330, radius)
    window.set_target_fps(30)
end

function update()


    -- Multiply by 6.0 (an arbitrary value) in order to make the speed
       --visually closer to the other circle (at 60 fps), for comparison
    C1.x = C1.x + window.get_frametime()*6.0*speed;
   --This circle can move faster or slower visually depending on the FPS
    C2.x = C2.x + 0.1*speed;

    --If either circle is off the screen, reset it back to the start
            if (C1.x > width) then C1.x = 0 end
            if (C2.x > width) then C2.x = 0 end

            local mousewheel = mouse.get_mousewheel_move()
            if mousewheel ~= 0 then
                currfps = currfps + mousewheel
                if (currfps < 0) then currfps = 0 end
                    window.set_target_fps(currfps)
            end

end

function draw()

    draw_.clear_background(color.BLACK)
    draw_.circle(C1, color.PURPLE)
    draw_.circle(C2, color.GOLD)

    local t1 = shapes_.newpoint(3, 4)
    local fps = window.get_fps()
    local frametime = window.get_frametime()
    text.draw_text(tostring(fps), t1, 16, color.GREEN)
    local t2 = shapes_.newpoint(3, 400)
    text.draw_text(tostring(frametime), t2, 16, color.GREEN)
end
