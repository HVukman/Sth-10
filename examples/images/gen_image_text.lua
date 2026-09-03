-- gen image text (may not work)

local draw_ = require("drawing")
local window = require("window")
local color = require("colors")
local image = require("image")
local shapes_ = require("shapes")
local texture = require("texture")

local example_text = [[

Lorem ipsum Aenean scelerisque nisi id nisl maximus molestie. Duis ornare purus ut dapibus rutrum. Curabitur magna leo, placerat id sodales nec, auctor non sapien. Nunc sodales massa nibh, vitae iaculis neque imperdiet id. Donec rhoncus pulvinar lobortis. Maecenas dignissim tellus et iaculis blandit. Nam dignissim consectetur felis, eu hendrerit magna dapibus ut. Morbi quis molestie augue.

Fusce ornare sapien sit amet eros gravida pretium. Mauris quam velit, venenatis ut pulvinar sit amet, porta id enim. Nulla vitae viverra diam. Vestibulum justo nulla, vehicula a interdum a, convallis et arcu. Etiam maximus consequat nunc eget rutrum. Donec quis dolor congue, eleifend ex non, sagittis libero. Phasellus eu elementum ipsum.

Pellentesque eu semper risus. Curabitur tincidunt blandit quam, vitae vestibulum libero faucibus a. In luctus imperdiet dui quis fringilla. Nam rhoncus risus eros, tincidunt auctor augue aliquam vel. Phasellus ut pellentesque tortor. Maecenas non felis ut nisl tristique faucibus nec eu ipsum. Praesent consequat augue vitae ipsum sagittis, quis fringilla magna pretium. In a nisi luctus, vehicula dolor in, aliquam diam.

Aenean ut eros massa. Sed tincidunt turpis sit amet diam rhoncus, sed condimentum velit malesuada. Mauris rhoncus, diam id lobortis ornare, elit quam ullamcorper arcu, quis faucibus eros sapien a mi. Etiam viverra, tortor at elementum porta, risus dui placerat odio, in imperdiet lectus arcu quis turpis. Ut ipsum arcu, pulvinar eu metus nec, placerat consectetur ex. Duis semper mollis mauris, vitae interdum purus semper sed. Fusce dignissim tortor sit amet ipsum vehicula suscipit. Donec ornare ligula et arcu dapibus, quis hendrerit felis molestie. Proin consectetur vestibulum nisi, a hendrerit dolor placerat sit amet. Etiam quis quam eros. Mauris nec libero non felis hendrerit volutpat. In hac habitasse platea dictumst. Nullam ut sem sed quam vehicula mattis ac sed eros. Nullam condimentum tortor nec lacus tincidunt maximus. Ut ac neque pellentesque, tempus mi et, tempor eros.
]]
local function init()


    local width = 1280
    local height = 640


    window.title("Text image")
    window.set_window_position(200,100)
    window.set_width_height(width,height)

    --  image.gen_text (width, height,text )
    Img_ = image.gen_text(640,480,example_text)
    P1 = shapes_.newpoint(3, 4)
    Text_ = texture.texture_from_image(Img_)

end


function draw()
    draw_.clear_background(color.BLACK)
    texture.draw(Text_, P1)
end

return {init,draw}
