-- main.lua
local shapes_ = require("shapes")
local color = require("colors")
local draw_ = require("draw")
local window = require("window")
local a = 3

function init()

    window.title("New Game")
    window.set_window_position(200,100)
    window.set_width_height(1280, 640)


    P1 = shapes_.newpoint(3, 4)
    P2 = shapes_.newpoint(200, 600)

    print(P1)
    print(P1["x"])
    print(P1 + P2)

    P3 = shapes_.newpoint(500, 100)

    local r1 = shapes_.newrectangle(10, 20, 300, 50)
    local r2 = shapes_.newrectangle(50, 30, 80, 60)

    print(r1)     -- Rect(x=10.00, y=20.00, w=100.00, h=50.00)

    ArrayP = shapes_.newpointarray(59)
    print(ArrayP:size())

    -- Set some points
       ArrayP:set(1, 10, 20)
       ArrayP:set(2, 30, 40)

       -- Get a point
       local p = ArrayP:get(1)
       print("First point:", p)    -- Point(10.00, 20.00)

    R1 = shapes_.newrectangle(1, 2, 100, 200)
    R2 = shapes_.newrectangle(50, 30, 80, 60)
end

function update()

end

function draw()


    draw_.clear_background(color.BLACK)
    draw_.full_rectangle(R1, color.YELLOW)
    draw_.lines_rectangle(R2, color.WHITE)
    draw_.point(P3,color.RED)
    draw_.line(P1, P2, color.GREEN)

end
