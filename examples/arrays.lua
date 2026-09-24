-- shows array class
--
local shapes_ = require("shapes")
local color = require("colors")
local draw_ = require("drawing")
local window = require("window")
local image = require("image")
local texture = require("texture")
local array = require("array")
local mathlib = require("mathlib")
local text   = require("text")



local limit = 400000
local limit2 = 4000000

local ax = array.new(limit)
local ay = array.new(limit)

local ax2 = array.new(limit2)
local ay2 = array.new(limit2)

-- array done with linspace
local linsp = array.linspace(1, 100, 210)

-- concat array
local concated_array

local function init()
    local bin = mathlib.binom(43, 12)
    print("bin ", bin)

    local width = 1280
    local height = 640

    window.title("Arrays")

    for i = 1, (limit) do
        ax[i] = math.random(width)
        ay[i] = math.random(height)
    end

    for i = 1, (limit2) do
        ax2[i] = math.random(width)
        ay2[i] = math.random(height)
    end

    local sum_ = mathlib.sum(ax)
    print("sum ", sum_)

    print("ax length " , #ax)
    print("ax 3 ", ax[3])
    print("ax 315621 ", ax[315621])
    mathlib.random.shufflearray(ax)

    print("ax 3 shuffle ", ax[3])

    print("linspace test ", linsp[4])
    print("linspace test length ", #linsp)

    -- concat arrays
    concated_array = ax .. ay
    print("concated array len ", #concated_array)

    -- add arrays
    local plus_axay
    plus_axay = ax + ay
    print("plus ax+ay ", plus_axay[2])

    local min_axay
    min_axay = ax - ay
    print("min ax - ay ", min_axay[3])

    local div_axay
    div_axay = ax / ay
    print("div ax/ay " , div_axay[3])


    for i = 1, (limit2) do
        ax2[i] = math.random(width)
        ay2[i] = math.random(height)
    end

    local nClock = os.clock()
    local mul_axay2
    mul_axay2 = ax2 * ay2
    print("mul ax*ay " , mul_axay2[3])
    print("this took with arrays ", os.clock() - nClock)

    local tableax2 = {}
    local tableay2 = {}
    local tableax2ay2 = {}

    for i = 1, (limit2) do
        table.insert(tableax2, math.random(width))
        table.insert(tableay2, math.random(width))
        table.insert(tableax2ay2, 0.0) -- preallocate table
    end

    nClock = os.clock()
    for i = 1, (limit2) do
        table.insert(tableax2ay2, ax2[i]*ay2[i])
    end
    print("mul ax*ay table " , tableax2ay2[3])
    print("this took with tables", os.clock() - nClock)

    local pow_axdivay
    pow_axdivay = ax ^ div_axay
    local out = string.format("pow ax^ay %3f ^ %3f = %3f " , ax[3] , div_axay[3] , pow_axdivay[3])
    print(out)

    local umin_ax
    umin_ax = -ax
    print("ax " , ax[3])
    print("umin ax " , umin_ax[3])


end

local function draw()

    draw_.clear_background(color.BLACK)

end

local function update()


end




return {init,update}
