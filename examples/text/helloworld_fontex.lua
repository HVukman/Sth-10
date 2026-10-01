-- hello world with expert font
--
local shapes_ = require("shapes")
local color = require("colors")
local draw_ = require("drawing")
local window = require("window")
local array = require("array")
local text   = require("text")

local NewFont
local P1
local P2
local P3
local P4
local Devangari
local emoji_font

local emoji_text
local emoji_codepoints
local deva_text
local codepoints
local function init()

    codepoints = [[चूंकिमानवपरिवारकेसभीसदस्योंकेजन्मजातगौरवऔरसमान ]]
    emoji_codepoints = "🥰💀✌︎🌴🐢🐐🍄⚽🍻👑📸😬👀🚨🏡🐦‍🔥🍋‍🟩🍄‍🟫🙂‍↕︎🕊︎🏆😻🌟🧿🍀🎨🍜"
    emoji_text = [[🥰💀✌︎🌴🐢🐐🍄⚽🍻👑📸😬👀🚨🏡🐦‍🔥
    🍋‍🟩🍄‍🟫🙂‍↕︎🕊︎🏆😻🌟🧿🍀🎨🍜]]
    print("emojis : " , emoji_codepoints)
    deva_text = "चूंकिमानवपरिवारकेसभीसदस्योंकेजन्मजातगौरवऔरसमान"
    print(deva_text)
    local width = 1280
    local height = 740

    window.title("Font Expert")
    window.set_width_height(width,height)
    P1 = shapes_.newpoint(10, 10)
    P2 = shapes_.newpoint(10, 300)
    P3 = shapes_.newpoint(10, 400)
    P4 = shapes_.newpoint(10, 510)
    NewFont = text.load_font_expert("examples/resources/pixantiqua.ttf", 16, 250)
    Devangari = text.load_font_codepoints("examples/resources/NotoSansDevanagari-Regular.ttf", 30, codepoints)
    -- https://fonts.google.com/noto/specimen/Noto+Emoji
    emoji_font = text.load_font_codepoints("examples/resources/NotoEmoji-VariableFont_wght.ttf", 30, emoji_codepoints)

end



local function draw()

    draw_.clear_background(color.BLACK)
    text.draw_text_ex(NewFont, [[Hello World!#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHI
                JKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmn
                opqrstuvwxyz{|}~¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓ
                ÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷
                øùúûüýþÿ]], P1, 32, 5, color.PINK)
    text.draw_text_ex(Devangari, deva_text, P2, 32, 5, color.PINK)
    text.draw_text_ex(emoji_font, emoji_text, P3, 32, 5, color.WHITE)


end

return {init,draw}
