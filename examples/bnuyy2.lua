-- bnuyy2.lua
-- lighttexture
local shapes_ = require("shapes")
local color = require("colors")
local draw_ = require("drawing")
local window = require("window")
local lighttexture = require("lighttexture")
local array = require("array")
local text   = require("text")

local R1 = shapes_.newrectangle(1, 1, 80, 30)
local limit = 100000
local ax = array.newint(limit)
local ay = array.newint(limit)


local Text_
local P1 = shapes_.newpoint(1, 1)

local function init()

    local width = 1280
    local height = 640

    local rand_ = math.random
    for i = 1,(limit) do
        ax[i] = rand_(width)
        ay[i] = rand_(height)
    end

    window.title("Bnuuys")
    window.set_window_position(200,100)
    window.set_width_height(width,height)


    Text_ = lighttexture.load_texture("examples/resources/bunny.png")


end

local function draw()
    draw_.clear_background(color.BLACK)
    for i = 1, (limit) do
        lighttexture.draw_texture(Text_, ax[i], ay[i])
    end
     draw_.rectangle(R1, color.BLACK)
    text.draw_fps(P1)
end


local function update()
    local rand_ = math.random
    for i = 1,(limit) do
        ax[i] =  ax[i] + rand_(-1,1)
        ay[i] =  ay[i] + rand_(-1,1)
    end
    draw()
end

return{init,update}
