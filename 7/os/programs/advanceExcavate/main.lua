--Advance Excavate            [<]
--Size: [                      ]
--Trash List  WhiteList
--path:
--Chest Mode   Ender Chest
--Insert the [tc=red]chest[tc=clear] in [tc=red]slot 1[tc=clear] and [tc=red]fuel[tc=clear] in [tc=red]slot 1[tc=clear].
--options size, chest, trash

ui.input.term = term
local _x, _y, _w, _h = 1, 1, term.getSize()

local success, set = fs.doFile("os/programs/advanceExcavate/data/settings.set")
set = set or {}
set.trashWhiteList = not (set.trashWhiteList == false)
if set.pathTrashList and not fs.exists(set.pathTrashList) then
    set.pathTrashList = nil
end
set.enderChest = set.enderChest or false
set.mineMode = not (set.mineMode == false)
set.size = set.size or 0

local input = ui.input.new()
local drawer = ui.drawer.new(input, _x, _y, _w, _h)
ui.buffer.fill(drawer.buffer, " ", colors.white, colors.white)

local label_title = ui.label.new(drawer, "Advance Excavate", theme.label1, _x, _y, _w - 3, 2)
local button_exit = ui.button.new(drawer, "<", theme.button2, _x + _w - 3, _y, 3, 1)

local label_size = ui.label.new(drawer, "Length: ", theme.label2, _x, _y + 1, 8, 1)
local iField_size = ui.inputField.new(drawer, nil, tostring(set.size), false, theme.iField2, _x + 8, _y + 1, _w - 8, 1)

local label_trashList = ui.label.new(drawer, "Trash List", theme.label2, _x, _y + 3, 12, 1)
local toggle_trashList = ui.toggle.new(drawer, {"White List", "Black List"}, set.trashWhiteList, theme.toggle1, 13, _y + 3, math.floor(_w / 2), 1)

local button_pathTrashList = ui.button.new(drawer, "Path", theme.button1, _x, _y + 4, 6, 1)
local label_pathTrashList = ui.label.new(drawer, set.pathTrashList or "No Selection", theme.label2, _x + 7, _y + 4, _w - 7, 1)
if not set.pathTrashList then
    label_pathTrashList:changeMode(2, true)
end

local label_chest = ui.label.new(drawer, "Chest Mode", theme.label2, _x, _y + 6, 12, 1)
local toggle_chest = ui.toggle.new(drawer, {"Ender Chest", "Normal"}, set.enderChest, theme.toggle1, 13, _y + 6, math.floor(_w / 2), 1)

local label_mine = ui.label.new(drawer, "Mine Mode", theme.label2, _x, _y + 8, 12, 1)
local toggle_mine = ui.toggle.new(drawer, {"Efficient", "Radical"}, set.mineMode, theme.toggle1, 13, _y + 8, math.floor(_w / 2), 1)

local text_info = ui.text.new(drawer, " \n ", theme.label2, 1, _y + 10, _w, _h - 9)
text_info.scaleH = false

ui.label.new(drawer, "", theme.label1, 1, _h, _w, 1)

local button_start = ui.button.new(drawer, "Start", theme.button1, _x + _w - 7, _h, 7, 1)
local button_saveSettings = ui.button.new(drawer, "Save Settings", theme.button1, _x, _h, 15, 1)

local group_menu = drawer.selectionManager:addNewGroup()
group_menu.current = button_exit
local group_main = drawer.selectionManager:addNewGroup()
group_main.current = iField_size
local group_save = drawer.selectionManager:addNewGroup()
group_save.current = button_start

group_menu.previous = group_save
group_main.previous = group_menu
group_save.previous = group_main
group_menu.next = group_main
group_main.next = group_save
group_save.next = group_menu

group_menu:addElement(button_exit, nil, nil, nil, iField_size)
group_main:addElement(iField_size, nil, group_menu, nil, toggle_trashList)
group_main:addElement(toggle_trashList, nil, iField_size, nil, button_pathTrashList)
group_main:addElement(button_pathTrashList, nil, toggle_trashList, nil, toggle_chest)
group_main:addElement(toggle_chest, nil, button_pathTrashList, nil, group_save)
group_save:addElement(button_saveSettings, nil, toggle_chest, button_start, nil)
group_save:addElement(button_start, button_saveSettings, toggle_chest, nil, nil)

drawer.selectionManager:select(iField_size, "code", not term.isColor())

local function updateTrashList()
    if set.pathTrashList then
        toggle_trashList:changeMode(1, true)
    else
        toggle_trashList:changeMode(2, true)
    end
end
updateTrashList()

local function updateInfoText()
    local text = "Insert [tc=red]fuel[tc=clear] in [tc=red]slot 1[tc=clear]"
    if toggle_chest._checked then
        text = text .. " and an [tc=red]Ender Chest[tc=clear] in [tc=red]slot 2[tc=clear]"
    end
    text_info.text = text .. "."
    text_info:recalculate()
    text_info:repaint("this")
end
updateInfoText()

local function updateStart()
    local canStart = false

    if (tonumber(iField_size.text) or 0) >= 1 then
        button_start:changeMode(1, true)
        group_save.current = button_start
    else
        button_start:changeMode(2, true)
        group_save.current = button_saveSettings
    end
end
updateStart()

function button_exit:onClick()
    input:exit()
end

function button_pathTrashList:onClick(event)
    input:callFunction(
        function()
            local path = callfile("os/sys/explorer/main.lua", {mode = "select_one", edit = false, select = event.name == "key_up", type = "list"})
            if path then
                set.pathTrashList = path
                label_pathTrashList.mode = 1
                label_pathTrashList.text = path
                label_pathTrashList:recalculate()
            end
            drawer:draw()
            updateTrashList()
        end
    )
end

function toggle_chest:onToggle(event, bool)
    updateInfoText()
    set.enderChest = bool
end

function toggle_trashList:onToggle(event, bool)
    set.trashWhiteList = bool
end

function iField_size:onTextEdit(event, text)
    if event == "change" then
        updateStart()
        set.size = tonumber(text) or 0
    end
end

function button_saveSettings:onClick(event)
    table.save(set, "os/programs/advanceExcavate/data/settings.set")
end

function button_start:onClick(event)
    input:callFunction(
        function()
            term.clear()
            fs.delete("os/programs/advanceExcavate/data/move.set")
            fs.delete("os/programs/advanceExcavate/data/data.set")
            table.save(set, "os/programs/advanceExcavate/data/data.set")
            local file = fs.open("os/startup/50-advanceExcavate.lua", "w")
            file.write('dofile("os/programs/advanceExcavate/excavate.lua")')
            file.close()
            dofile("os/programs/advanceExcavate/excavate.lua")
            input:exit()
        end
    )
end

drawer:draw()
input:eventLoop({[term] = drawer.event})
