-- main.lua
Shapes_ = require("shapes")
Color = require("colors")
Draw = require("draw")

function init()

    P1 = Shapes_.newpoint(3, 4)
    P2 = Shapes_.newpoint(3, 4)

    print(P1)
    print(P1["x"])
    print(P1 + P2)

    ArrayP = Shapes_.newpointarray(59)
    print(ArrayP:size())

end

function update()

end

function draw()

    Draw.point(P1,Color.RED)

end
