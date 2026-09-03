-- lightarraytest.lua
--

local color = require("colors")
local draw_ = require("drawing")
local lightarray = require("lightarray")

local limit = 100000
-- shows syntax of light arrays
-- you only get the reference to an array of arrays
-- this is light userdata and is not handled by the garbage collector!
local ax = lightarray.new(limit)
local ay = lightarray.new(limit)

local function init()

    local width = 1280
    local height = 640
    local rand_ = math.random
    for i = 1, (limit) do
        lightarray.set(ax, i, rand_(width))
        lightarray.set(ay, i, rand_(height))
    end

    print("ax ", ax)
    print(" ax[1] ", lightarray.get(ax,1))

end

local function draw()


    draw_.clear_background(color.BLACK)

end

local function update()
    draw()
end


return {init,update}
