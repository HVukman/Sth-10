-- attractor.lua
local shapes_ = require("shapes")
local color = require("colors")
local draw_ = require("drawing")
local window = require("window")


local xpos
local ypos
local zpos
local athom = 0.19

local function init()

    local width = 1280
    local height = 640

    local rand_ = math.random

    xpos = rand_(width)
    ypos = rand_(height)
    zpos = rand_(height)

    window.set_width_height(width, height)
    window.titel("Thomas Attractor")
    draw_.clear_background(color.BLACK)
end

local function draw()

    local P = shapes_.newpoint(xpos, ypos)
    local P2 = shapes_.newpoint(ypos,zpos)
    draw_.point(P,color.RED)
    draw_.point(P2,color.GREEN)
end

local function update()

    local dt =  window.get_frametime()
    local dx = (-athom*xpos + math.sin(ypos))*dt
    local dy = (-athom*ypos + math.sin(zpos))*dt
    local dz = (-athom*zpos + math.sin(xpos))*dt

    xpos = xpos + dx
    ypos = ypos + dy
    zpos = zpos + dz

    draw()
end




return {init,update}
