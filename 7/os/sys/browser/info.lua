local data = ...
local _x, _y, _w, _h = 1, 1, term.getSize()

local manager = ui.uiManager.new(_x, _y, _w, _h)
ui.buffer.fill(manager.buffer, " ", colors.white, colors.white)

local types = {}
if data.type:find("d") then
    table.insert(types, "Desktop")
end
if data.type:find("t") then
    table.insert(types, "Turtle")
end
if data.type:find("p") then
    table.insert(types, "Pocket")
end
if #types == 0 then
    table.insert(types, "Desktop")
    table.insert(types, "Turtle")
    table.insert(types, "Pocket")
end
if data.color then
    table.insert(types, "Color", 1)
end

local tBox_info = ui.textBox.new(manager, "", ("Name:\n%s\n\nDescription:\n%s\n\nCategory:\n%s\n\nType:\n%s\n\nVersion:\n%s\n\nSource:\n%s"):format(data.name, IF(data.description and data.description ~= "", data.description, "No Description."), IF(data.category and data.category ~= "", data.category, "Non."), table.concat(types, ", "), table.concat(data.version or {"No Version"}, "."), data.url), theme.tBox2, _x, _y, _w, _h)
local label_title = ui.label.new(tBox_info, "Info", theme.label1, 1, 1, _w - 3, 1)
local button_exit = ui.button.new(tBox_info, "<", theme.button2, _w - 2, 1, 3, 1)
local label_title = ui.label.new(tBox_info, "", theme.label1, 1, _h, _w, 1)
local button_delete = ui.button.new(tBox_info, "Delete", theme.button1, 1, _h, 8, 1)
if not data.delete then
    button_delete.mode = 2
    button_delete:recalculate()
end
local type_do = "Install"
if data.status == 1 then
    type_do = "Update"
elseif data.status == 2 then
    type_do = "Remove"
end
local button_do = ui.button.new(tBox_info, type_do, theme.button1, _w - 8, _h, 9, 1)

local group_menu = manager.selectionManager:addNewGroup()
local group_tBox = tBox_info.selectionGroup
manager.selectionManager:addGroup(group_tBox)

group_menu:addElement(button_exit, nil, nil, nil, group_tBox)
group_tBox:addElement(button_delete, nil, group_menu, button_do, nil)
group_tBox:addElement(button_do, button_delete, group_menu, nil, nil)

group_menu.current = button_exit
manager.selectionManager:select(button_do, "code", 3)

function button_exit:onClick(event)
    manager:exit()
end

manager:draw()
manager:execute()
