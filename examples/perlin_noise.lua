-- perlin_noise.lua
local shapes_ = require("shapes")
local color = require("colors")
local draw_ = require("drawing")
local window = require("window")
local array = require("array")
local mathlib = require("mathlib")
local img     = require("image")

local wh = 150
local limit        = wh*wh

local ax          = array.new(limit)
local ay           = array.new(limit)

print("limit ", limit)

local blank = img.gen_image_color(wh,wh, color.BLACK)

local function init()

    local perlin_ = mathlib.noise.perlin
    local rand_ = math.random
    for i = 1,limit do
        ax[i] = perlin_(3.14, rand_(wh), 7)
        ay[i] = perlin_(3.14, rand_(wh), 7)

    end

    for i = 1, limit do
        local P = shapes_.newpoint(i % wh, (i // wh) % wh)
        if ax[i] > 0.0 and ay[i] > 0.0 then
            img.draw_pixel(blank,P, color.WHITE)
        end
    end


    window.title("Perlin Noise")
    window.set_width_height(wh,wh)

    -- output not needed
    _= img.save_image(blank,"perlin_noise.png")


end

local function draw()
    draw_.clear_background(color.BLACK)

    for i = 1, limit do
        local P = shapes_.newpoint(i%wh, (i//wh)%wh)
        if ax[i] > 0.0 and ay[i] > 0.0 then
            draw_.point(P, color.WHITE)
        else
            draw_.point(P, color.BLACK)
        end


    end


end


local function update()

    draw()

end

return{init,update}
