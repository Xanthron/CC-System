local _x, _y, _w, _h = 1, 1, term.getSize()
local manager = ui.uiManager.new(_x, _y, _w, _h)
local inputField = ui.inputField.new(manager, "", "test\n\n\nund so", true, theme.iField1, _x, _y, _w, _h)

local group = manager.selectionManager:addNewGroup()
group:addElement(inputField)

manager.selectionManager:select(inputField, "key", 3)

manager:draw()
manager:execute()
