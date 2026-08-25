--- should show all *.lua files in the previous folder
--- sorted by size


local color = require("colors")
local window = require("window")
local text   = require("text")
local oslib = require("oslib")
local draw_  = require("drawing")
local shapes_ = require("shapes")
local files_size = {}
local globbed = {}

local function compare_size(x,y)

    return x.size > y.size
end

function init()
    window.title("Globbed")
    globbed = oslib.glob("*.lua")

    for i,v in ipairs(globbed) do
        local dummy = {}
        local info = oslib.file_info(v)
        print("info ", info)
        dummy["name"] = info.name
        dummy["size"] = info.size
        table.insert(files_size,dummy)
    end

    table.sort(files_size, compare_size)
    print("len ", #files_size)


end

function update()

end

function draw()

    draw_.clear_background(color.BLACK)
    local y=30
    local size = 17

    local P = shapes_.newpoint(10,10)
    text.draw_text("files with *.lua pattern",P,size,color.WHITE)
    local P1 = shapes_.newpoint(10,30)
    for i, v in ipairs(globbed) do
        text.draw_text(v,P1,size,color.WHITE)
        P1.y=P1.y+size
    end


    local P2 = shapes_.newpoint(300,10)
    text.draw_text("files sorted by size",P2,size,color.WHITE)

    for i, v in ipairs(files_size) do
     --   text.draw_text(v.name .. " " .. tostring(v.size), P2,size,color.WHITE)
        P2.y=P2.y+size
    end
end
