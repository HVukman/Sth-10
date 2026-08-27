-- bnuyy.lua
local shapes_ = require("shapes")
local color = require("colors")
local draw_ = require("drawing")
local window = require("window")
local texture2 = require("texture2")
local array = require("array")
local text   = require("text")


local limit = 65000
local ax = array.new(limit)
local ay = array.new(limit)


local Text_
local P1     = shapes_.newpoint(1, 1)

function init()



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


    Text_ = texture2.load_texture_handle("examples/resources/bunny.png")


end

function update()
    local rand_ = math.random
    for i = 1,(limit) do
        ax[i] =  ax[i] + rand_(-1,1)
        ay[i] =  ay[i] + rand_(-1,1)
    end

end

function draw()

    draw_.clear_background(color.BLACK)
    for i = 1, (limit) do
        texture2.draw_texture_handle(Text_, ax[i], ay[i])
    end
    text.draw_fps(P1)


end
