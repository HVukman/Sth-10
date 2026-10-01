-- intarraytest.lua
--

local color = require("colors")
local draw_ = require("drawing")
local array = require("array")

local limit = 100000
local ax = array.newint(limit)
local ay = array.newint(limit)

local function init()

    local width = 1280
    local height = 640

    for i = 1, (limit) do
        ax[i] = math.random(width)
        ay[i] = math.random(height)
    end

    print(" ax[1] ", ax[1])

end

local function draw()


    draw_.clear_background(color.BLACK)

end

local function update()


    draw()
end


return {init,update}
