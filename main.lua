-- main.lua
local shapes_ = require("shapes")
local color = require("colors")
local draw_ = require("drawing")
local window = require("window")
local image = require("image")
local texture = require("texture")
local array = require("array")
local limit = 100000
local ax = array.new(limit)
local ay = array.new(limit)
function init()

    local width = 1280
    local height = 640

    for i = 1,(limit) do
        ax[i] = math.random(width)
        ay[i] = math.random(height)
    end


    window.title("New Game")
    window.set_window_position(200,100)
    window.set_width_height(width,height)


    P1 = shapes_.newpoint(3, 4)
    P2 = shapes_.newpoint(200, 600)

    print(P1)
    print(P1["x"])
    print(P1 + P2)

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

    Img_ = image.load_image("resources/bunny.png")
    print(Img_)

    Text_ = texture.texture_from_image(Img_)

    print(Text_)
    Val = texture.is_valid(Text_)
    print("Texture valid:", Val)

    P4 = shapes_.newpoint(300, 300)


end

function update()
    fps = window.get_fps()
    print(" fps ", fps)

    array.array_change(ax, 1, limit)
    array.array_change(ay, 1,limit)


    if window.should_close() then
        local mb = collectgarbage("count") / 1024
        print(string.format("%.2f MB", mb))
    end
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


    for i = 1, (limit) do
        local p4 = shapes_.newpoint(ax[i], ay[i])
        texture.draw(Text_,p4)
    end



end
