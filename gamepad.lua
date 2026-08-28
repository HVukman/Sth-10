-- gamepad.lua

local draw_ = require("drawing")
local window = require("window")
local color = require("colors")
local gamepad = require("gamepad")
local text = require("text")
local shapes = require("shapes")


local button
local available
local name_gamepad

local function init()


    local width = 1280
    local height = 640


    window.title("Gamepad Test")
    window.set_window_position(200,100)
    window.set_width_height(width,height)

    available = gamepad.is_available(0)
    if available then
        name_gamepad = gamepad.get_name(0)
    end

end

local function draw()
    local gamepadtext

    if available then
        gamepadtext = "yes"
    else
        gamepadtext = "no"
    end

    local textsize = 20
    local point = shapes.newpoint(1, 1)
    draw_.clear_background(color.BLACK)
    text.draw_text("Gamepad available: " .. gamepadtext, point, textsize, color.GREEN)
    if available then
        point.y = point.y + 22
        text.draw_text(name_gamepad, point, textsize, color.GREEN)
        point.y = point.y + 22
        text.draw_text("pressed button " .. tostring(button), point, textsize, color.GREEN)
    end
end


local function update()

    if available then
        button = gamepad.get_button_pressed(0)
    end

    draw()

end

return {init,update}
