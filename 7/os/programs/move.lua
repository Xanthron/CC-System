local x, y, w, h = 1, 1, term.getSize()

local manager = ui.uiManager.new(x, y, w, h)
ui.buffer.fill(manager.buffer, " ", colors.white, colors.white)

local button1 = ui.button.new(manager, "move", theme.button1, 1, 1, 6, 1)

local element = ui.scrollView.new(manager, "scroll View", 1, theme.sView1, 1, 2, 9, 9) --ui.textBox.new(manager, "text", "test", theme.tBox1, 1, 2, 9, 9)
local element2 = ui.element.new(element, "image", 1, 2, 9, 1)

ui.buffer.fill(element2.buffer, " ", colors.blue, colors.blue)

manager.selectionManager:addNewGroup():addElement(button1)

local r = true
local d = nil
function button1:onClick(event)
    if r ~= nil then
        if r then
            element:setLocalRect(1)
            if element:getGlobalPosX() + element:getWidth() + 1 > w + x then
                r = false
            end
        else
            element:setLocalRect(-1)
            if element:getGlobalPosX() - 1 < x then
                r = true
            end
        end
    end
    if d ~= nil then
        if d then
            element:setGlobalRect(nil, element:getGlobalPosY() + 1)
            if element:getGlobalPosY() + element:getHeight() + 1 > h + y then
                d = false
            end
        else
            element:setGlobalRect(nil, element:getGlobalPosY() - 1)
            if element:getGlobalPosY() - 1 < y + 1 then
                d = true
            end
        end
    end
    ui.buffer.fill(manager.buffer, " ", colors.white, colors.white)
    manager:draw()
end

manager:draw()
manager:execute()
