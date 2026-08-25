-- shapes.lua
local shapes_ = require("shapes")
local color = require("colors")
local draw_ = require("drawing")
local window = require("window")

local rot = 30
local dummy = 0.1
local radius = 30
function init()


    local width = 1280
    local height = 640


    window.title("Basic shapes")
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

    C1 = shapes_.newcircle(250, 130, 80)
    print(C1)
    C2 = shapes_.newcircle(450, 530, 20)
    print(C1)

    T1 = shapes_.newtriangle(P1,P2,P3)
    print(T1)

    P4 = shapes_.newpoint(300, 300)
    P6 = shapes_.newpoint(900, 300)

    EllipsePoint = shapes_.newpoint(200, 500)
    Ellipse = shapes_.newellipse(EllipsePoint, 36, 70)
    print("Ellipse ", Ellipse)


    PolygonPoint = shapes_.newpoint(500, 500)
     -- Polygon: 	center : point, 	sides : int, 	radius: f32,	rotation : f32,
    Polygon = shapes_.newpolygon(PolygonPoint, 8, radius, rot)
    print("Polygon ", Polygon)

    Mouse_point = shapes_.newpoint(1000, 100)

end

function update()
    rot = (rot + 1) % 360
    Polygon.rot = rot+dummy
end

function draw()


    draw_.clear_background(color.BLACK)
    draw_.lines_triangle(T1, color.RAYWHITE)
    draw_.rectangle(R1, color.YELLOW)
    draw_.lines_rectangle(R2, color.WHITE)
    draw_.point(P3,color.RED)
    draw_.line(P1, P2, color.GREEN)
    draw_.circle(C1, color.PURPLE)
    draw_.lines_circle(C2, color.SKYBLUE)
    draw_.ellipse(Ellipse, color.DARKPURPLE)
    draw_.polygon(Polygon, color.GOLD)



end
