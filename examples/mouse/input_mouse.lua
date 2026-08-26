---
---
local draw_ = require("drawing")
local window = require("window")
local color = require("colors")
local shapes_ = require("shapes")
local mouse = require("mouse")
local text   = require("text")
local keys  = require("keys")
local circle_color = nil

function init()

    local width = 1280
    local height = 640

    window.title( "Input Mouse")
    window.set_window_position(200,100)
    window.set_width_height(width, height)

    -- make circle
    local radius = 30
    C1 = shapes_.newcircle(250, 130, radius)
    -- mouse x , y
    Mousex = 0
    Mousey = 0
    P1 = shapes_.newpoint(10,10)
    P2 = shapes_.newpoint(10, 30)
    P3 = shapes_.newpoint(20, 600)
    circle_color = color.PURPLE

    print("c1 x", C1.x)
end

function update()

    C1.x = mouse.get_mouse_x()
    C1.y = mouse.get_mouse_y()

    if mouse.is_mouse_button_pressed(mouse.Left) then
        circle_color = color.RED
    elseif mouse.is_mouse_button_pressed(mouse.Right) then
        circle_color = color.BLUE
    elseif mouse.is_mouse_button_pressed(mouse.Middle) then
        circle_color = color.GREEN
    elseif mouse.is_mouse_button_pressed(mouse.Side) then
        circle_color = color.GOLD
    elseif mouse.is_mouse_button_pressed(mouse.Extra) then
        circle_color = color.BLACK
    end

    if keys.key_down(keys.H) then
        if mouse.is_cursor_hidden() then
            mouse.show_cursor()
        else
            mouse.hide_cursor()
        end
    end
end

function draw()



    draw_.clear_background(color.BLACK)
    draw_.circle(C1, circle_color )
    text.draw_text("move ball with mouse and click mouse buttons to change color", P1, 16, color.DARKGRAY)
    text.draw_text("Press 'H' to toggle cursor visibility",P2, 20, color.DARKGRAY);

    if mouse.is_cursor_hidden() then
        text.draw_text("CURSOR HIDDEN", P3, 20, color.RED)
    else
        text.draw_text("CURSOR VISIBLE", P3, 20, color.LIME)
    end



end
