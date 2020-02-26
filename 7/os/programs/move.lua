local x, y, w, h = 1, 1, term.getSize()

local manager = ui.uiManager.new(x, y, w, h)
ui.buffer.fill(manager.buffer, " ", colors.white, colors.white)

local button1 = ui.button.new(manager, "move", theme.button1, 1, 1, 6, 1)

local element_m1 = ui.element.new(manager, "image", 1, 2, 9, 9)
ui.buffer.fill(element_m1.buffer, " ", colors.blue, colors.blue)
local element_m2 = ui.element.new(element_m1, "image", 2, 3, 7, 7)
ui.buffer.fill(element_m2.buffer, " ", colors.lime, colors.lime)
local element_m3 = ui.element.new(element_m2, "image", 3, 4, 5, 5)
ui.buffer.fill(element_m3.buffer, " ", colors.yellow, colors.yellow)
local element_m4 = ui.element.new(element_m3, "image", 4, 5, 3, 3)
ui.buffer.fill(element_m4.buffer, " ", colors.red, colors.red)
local element_m5 = ui.element.new(element_m4, "image", 5, 6, 1, 1)
ui.buffer.fill(element_m5.buffer, " ", colors.magenta, colors.magenta)

manager.selectionManager:addNewGroup():addElement(button1)

local down, right = true, true
function button1:onClick(event)
    if down then
        element_m1:setGlobalRect(element_m1:getGlobalPosX() + 1)
        if element_m1:getGlobalPosX() + element_m1:getWidth() + 1 >= w then
            down = false
        end
    else
        element_m1:setGlobalRect(element_m1:getGlobalPosX() - 1)
        if element_m1:getGlobalPosX() - 1 <= x then
            down = true
        end
    end
    if right then
        element_m1:setGlobalRect(nil, element_m1:getGlobalPosY() + 1)
        if element_m1:getGlobalPosY() + element_m1:getHeight() + 1 >= h then
            right = false
        end
    else
        element_m1:setGlobalRect(nil, element_m1:getGlobalPosY() - 1)
        if element_m1:getGlobalPosY() - 1 <= y + 1 then
            right = true
        end
    end
    manager:draw()
end

manager:draw()
manager:execute()
