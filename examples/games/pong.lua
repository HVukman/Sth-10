-- hello world
local shapes_ = require("shapes")
local color = require("colors")
local draw_ = require("drawing")
local window = require("window")
local text   = require("text")
local collision = require("collision")
local keys = require("keys")

local player_score = 0
local cpu_score = 0

local width = 1280
local height = 640

local ball = nil
local ballx = width / 2
local bally = height / 2
local ballradius = 8

local paddlespeed = 3

local P1
local P2
local R1
local R2

function init()

    window.title("Pong")

    window.set_width_height(width, height)

    P1 = shapes_.newpoint(20, height / 2)
    P2 = shapes_.newpoint(width - 30, height / 2)

    R1 = shapes_.newrectangle(P1.x, P1.y , 20, 100)
    R2 = shapes_.newrectangle(P2.x, P2.y, 20, 100)

    ball = shapes_.newcircle(ballx,bally, ballradius)

end

function update()

    if keys.key_down(keys.UP) then
        P1.Y = P1.Y - paddlespeed
    elseif keys.key_down(keys.DOWN) then
        P1.Y = P1.Y + paddlespeed
    end

    if P1.Y > height or P1.Y < 0 then
        P1.Y = P1.Y
    end

    R1.Y = P1.Y

end

function draw()

    draw_.clear_background(color.DARKGREEN)
    draw_.rectangle(R1, color.WHITE)
    draw_.rectangle(R2, color.WHITE)

    local LP1 = shapes_.newpoint(width/2, 0)
    local LP2 = shapes_.newpoint(width / 2, height)

    draw_.line(LP1, LP2, color.WHITE)
    draw_.circle(ball, color.WHITE)
end
