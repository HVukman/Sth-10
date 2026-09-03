-- testing fennel inclusion
--
local fennel = require("examples/resources/fennel")

-- all fennel functions are put in local game, which will be a table
local game
table.insert(package.searchers, fennel.searcher) -- insert fennel, see : https://fennel-lang.org/api#use-luas-built-in-require-function
game = fennel.dofile("examples/main.fnl")        -- load the fennel file, returns a table

-- call functions in game table from main.fnl
return {game.set_window,game.draw_hello}
