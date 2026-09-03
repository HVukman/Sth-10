-- easing
local shapes_ = require("shapes")
local color = require("colors")
local draw_ = require("drawing")
local window = require("window")
local mathlib = require("mathlib")

local frame_counter = 0
local time          = 1100
local target_x      = 500
local target_x2     = 450
local target_r1_x   = 900


local P1,P2,P3,R1,R2,C1,C2

local function init()


    local width = 1280
    local height = 640


    window.title("Easing examples")
    window.set_width_height(width,height)
    window.set_target_fps(60)

    P1 = shapes_.newpoint(3, 4)
    P2 = shapes_.newpoint(200, 600)
    P3 = shapes_.newpoint(500, 100)

    local r1 = shapes_.newrectangle(10, 20, 300, 50)
    local r2 = shapes_.newrectangle(50, 30, 80, 60)


    R1 = shapes_.newrectangle(1, 2, 100, 200)
    R2 = shapes_.newrectangle(50, 30, 80, 60)

    C1 = shapes_.newcircle(0, 130, 80)
    C2 = shapes_.newcircle(0, 530, 20)


end

local function draw()
    draw_.clear_background(color.BLACK)
    draw_.rectangle(R1, color.YELLOW)
    draw_.lines_rectangle(R2, color.WHITE)
    draw_.point(P3, color.RED)
    draw_.circle(C1, color.PURPLE)
    draw_.lines_circle(C2, color.SKYBLUE)
end


local function update()

    frame_counter = frame_counter + 1

    if frame_counter >= time then
        frame_counter = 0
    end

        -- ease to target until time is reached
        -- ease_method(counter,start,target,time)
        C1.x = mathlib.easing.ease_elastic_in(frame_counter, 0, target_x, time)
        C2.x = mathlib.easing.ease_bounce_in(frame_counter, 0, target_x2, time)
        R1.x = mathlib.easing.ease_linear_in(frame_counter, 1, target_r1_x, time)
        R2.x = mathlib.easing.ease_expo_in(frame_counter, 50, target_r1_x, time)

        if  frame_counter >= time then
             frame_counter = 0

        end

        draw()
end

return{init,update}
