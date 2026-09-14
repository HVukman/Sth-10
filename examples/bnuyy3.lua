-- bnuyy3.lua
-- lighttexture and lightarray
local shapes_ = require("shapes")
local color = require("colors")
local draw_ = require("drawing")
local window = require("window")
local texture2 = require("lighttexture")

local lightarray = require("lightarray")
local text   = require("text")

local limit      = 100000

local ax = lightarray.new(limit)
local ay = lightarray.new(limit)

local Text_
local P1         = shapes_.newpoint(1, 1)
local R1 = shapes_.newrectangle(1, 1, 80, 30)
local width = 1280
local height = 640

local rendertexture

local function init()

    local rand_ = math.random
    for i = 1, (limit) do
        lightarray.set(ax, i, rand_(width))
        lightarray.set(ay, i, rand_(height))

    end

    window.title("Bnuuys")
    window.set_window_position(200,100)
    window.set_width_height(width,height)

    Text_ = texture2.load_texture("examples/resources/bunny.png")
    -- draw onto rendertexture
    rendertexture = draw_.new_render_texture(width, height)

end

local function draw()
    local p = shapes_.newpoint(0, 0)
    draw_.clear_background(color.BLACK)

    -- draw on rendertexture
    draw_.begin_texture_mode(rendertexture)
        for i = 1, (limit) do
            texture2.draw_texture(Text_, lightarray.get(ax,i), lightarray.get(ay,i))
        end
    draw_.end_texture_mode()

    -- draw the render texture itself
    draw_.draw_render_texture(rendertexture,p)
    draw_.rectangle(R1, color.BLACK)
    text.draw_fps(P1)
end

local function update()
    local rand_ = math.random
    for i = 1,(limit) do

        lightarray.set(ax, i, lightarray.get(ax,i) + rand_(-1,1))
        lightarray.set(ay, i, lightarray.get(ay,i) + rand_(-1,1))
    end
    draw()
end


return {init, update}
