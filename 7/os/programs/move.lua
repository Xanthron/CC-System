local x, y, w, h = 1, 1, term.getSize()

local manager = ui.uiManager.new(x, y, w, h)
ui.buffer.fill(manager.buffer, " ", colors.white, colors.white)

local button1 = ui.button.new(manager, "move", theme.button1, 1, 1, 6, 1)

local element = ui.label.new(manager, "Test", theme.label1, 1, 2, 4, 1)

--element:resizeContainer()

manager.selectionManager:addNewGroup():addElement(button1)

local r = true
local d = true
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
