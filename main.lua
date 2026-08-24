-- main.lua
local shapes_ = require("shapes")
local color = require("colors")
local draw_ = require("drawing")
local window = require("window")
local image = require("image")
local texture = require("texture")
local array = require("array")
local mathlib = require("mathlib")
local keys  = require("keys")
local text   = require("text")
local mouse = require("mouse")
local sound   = require("sound")
--local music   = require("music")

local limit = 100000
local ax = array.new(limit)
local ay = array.new(limit)

local mousex  = 0
local mousey  = 0



function init()

    local bin = mathlib.binom(43, 12)
    print("bin ", bin)

    local width = 1280
    local height = 640

    for i = 1,(limit) do
        ax[i] = math.random(width)
        ay[i] = math.random(height)
    end

    local sum_ = mathlib.sum(ax)
    print("sum ", sum_)

    print("ax 3 " , ax[3])
    mathlib.random.shufflearray(ax)

    print("ax 3 shuffle " , ax[3])

    window.title("Sth10 Playground (Press arrow keys to move bunny)")
    window.set_window_position(200,100)
    window.set_width_height(width,height)


    P1 = shapes_.newpoint(3, 4)
    P2 = shapes_.newpoint(200, 600)
    P1["X"] = 9.2
    print(P1)
    print(" Y " , P1["Y"])
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

    Img_ = image.load_image("examples/resources/bunny.png")
    print(Img_)

    Text_ = texture.texture_from_image(Img_)

    print(Text_)
    Val = texture.is_valid(Text_)
    print("Texture valid:", Val)

    P4 = shapes_.newpoint(300, 300)
    print("rand i63", mathlib.random.i63())
    print("rand u32", mathlib.random.u32())

    Pico8 = text.load_font("examples/resources/pico-8.ttf")
    P5 = shapes_.newpoint(400, 600)

    SolidColorImage = image.gen_image_color(260, 260, color.BLUE)
    print("solid " , SolidColorImage)
    Text_2 = texture.texture_from_image(SolidColorImage)
    P6 = shapes_.newpoint(900, 300)

    EllipsePoint = shapes_.newpoint(200, 500)
    Ellipse = shapes_.newellipse(EllipsePoint, 36, 70)
    print("Ellipse ", Ellipse)

    PolygonPoint = shapes_.newpoint(500, 500)
    Polygon = shapes_.newpolygon(PolygonPoint, 8, 16, 12)
    print("Polygon ", Polygon)

    Mouse_point = shapes_.newpoint(1000, 100)

    Snd         = sound.load_sound("examples/resources/beep.wav")
    sound.set_volume(Snd,1)
    sound.play_sound(Snd)
end

function update()

    if keys.key_down(keys.UP) then
        print("pressed up")
        P4.Y = P4.Y - 1
    elseif keys.key_down(keys.DOWN) then
        print("pressed up")
        P4.Y = P4.Y + 1
    elseif keys.key_down(keys.LEFT) then
        print("pressed left")
        P4.X = P4.X - 1
    elseif keys.key_down(keys.RIGHT) then
        print("pressed r")
        P4.X = P4.X + 1
    end

    mousex = mouse.get_mouse_x()
    mousey = mouse.get_mouse_y()

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
    texture.draw(Text_, P4)

    text.draw_text("hello world", P2, 16, color.GREEN)
    text.draw_text("Mouse X: " .. tostring(mousex) .. " Mouse Y: " .. tostring(mousey), Mouse_point, 16, color.RAYWHITE)
    text.draw_text_ex(Pico8, "HELLOW PICO", P5, 18, 2 , color.PINK )
    texture.draw(Text_2,P6)
end
