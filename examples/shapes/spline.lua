-- draw linear spline
local shapes_ = require("shapes")
local color = require("colors")
local draw_ = require("drawing")
local window = require("window")

local array = require("array")

local size= 4
local ax = array.new(size)
local ay = array.new(size)



local function init()

    local width = 1280
    local height = 640


    ax[1] = 0
    ay[1] = 0
    ax[2] = 100
    ay[2] = 300
    ax[3] = 600
    ay[3] = 600
    ax[4] = 900
    ay[4] = 640

    window.title("Linear Spline (Yellow) and Catmull Rom (Green)")
    window.set_window_position(200,100)
    window.set_width_height(width,height)



end

local function draw()
    draw_.clear_background(color.BLACK)
    draw_.catmull_rom_spline(ax, ay, 5.3, color.GREEN)
    draw_.linear_spline(ax, ay, 2.3, color.YELLOW)

end


local function update()

    draw()
end

return{init,update}
