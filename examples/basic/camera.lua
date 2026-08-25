-- camera.lua
local shapes_ = require("shapes")
local color = require("colors")
local draw_ = require("drawing")
local window = require("window")
local keys = require("keys")

local rot = 0
local dummy = 0.1
local radius = 30
local cam = nil

function init()


    local width = 1280
    local height = 640

    cam = draw_.new_camera()
    window.title("Basic Camera (Arrow Keys to move)")
    window.set_width_height(width,height)
    window.set_target_fps(60)

    P1 = shapes_.newpoint(3, 4)
    P2 = shapes_.newpoint(200, 600)
    P3 = shapes_.newpoint(500, 100)

    local r1 = shapes_.newrectangle(10, 20, 300, 50)
    local r2 = shapes_.newrectangle(50, 30, 80, 60)

    print(r1)     -- Rect(x=10.00, y=20.00, w=100.00, h=50.00)

    R1 = shapes_.newrectangle(1, 2, 100, 200)
    R2 = shapes_.newrectangle(50, 30, 80, 60)

    Target =  shapes_.newpoint(250, 130)
    C1 = shapes_.newcircle(Target.x, Target.y, 80)
    print(C1)

    C2 = shapes_.newcircle(450, 530, 20)
    print(C1)

    Offset = shapes_.newpoint(width/2, height/2)
    cam.target = Target
    cam.rotation = rot
    cam.zoom = 1.0
    cam.offset = Offset
end

function update()

    if keys.key_down(keys.UP) then
        C1.Y = C1.Y - 1

    elseif keys.key_down(keys.DOWN) then
        C1.Y = C1.Y + 1
    elseif keys.key_down(keys.LEFT) then
        C1.X = C1.X - 1
    elseif keys.key_down(keys.RIGHT) then
        C1.X = C1.X + 1
    end

    Target.Y = C1.Y
    Target.X = C1.X
    cam.target = Target

end

function draw()


    draw_.clear_background(color.BLACK)

    draw_.begin_mode_2D(cam)
        draw_.rectangle(R1, color.YELLOW)
        draw_.lines_rectangle(R2, color.WHITE)
        draw_.point(P3,color.RED)
        draw_.line(P1, P2, color.GREEN)
        draw_.circle(C1, color.PURPLE)
        draw_.lines_circle(C2, color.SKYBLUE)
    draw_.end_mode_2D()



end
