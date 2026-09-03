-- hilbert.lua
-- see: https://www.eurasip.org/Proceedings/Eusipco/Eusipco1998/sessions/T%20A/TA%20P-7/487/spacefil1.pdf
local shapes_ = require("shapes")
local color = require("colors")
local draw_ = require("drawing")
local window = require("window")
local array = require("array")


local limit = 100000
local ax = array.new(limit)
local ay = array.new(limit)

local wid = 128 -- factor of 2
local Start = 0

local function hilbert(x, y, lg, i1, i2)
    if lg == 1 then
        ax[Start] = 10 * x
        ay[Start] = 10 * y

        Start = Start + 1
    else
        lg = lg / 2; -- Divide by 2.
        hilbert(x + i1 * lg, y + i1 * lg, lg, i1, 1 - i2)
        hilbert(x + i2 * lg, y + (1 - i2) * lg, lg, i1, i2)
        hilbert(x + (1 - i1) * lg, y + (1 - i1) * lg, lg, i1, i2)
        hilbert(x + (1 - i2) * lg, y + i2 * lg, lg, 1 - i1, i2)
    end
end


local function init()
    local width = 1280
    local height = 640
    window.title("Hilbert Curve")
    window.set_width_height(width, height)
    hilbert(0, 0, wid, 0, 0)
end

-- just draw

function draw()
    draw_.clear_background(color.BLACK)
    for i = 0, Start - 1 do
            local point1 = shapes_.newpoint(ax[i], ay[i])
            local point2 = shapes_.newpoint(ax[i+1], ay[i+1])
            draw_.line(point1,point2,color.GREEN)

        end
end

return {init,draw}
