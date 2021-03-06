ui.input.term = term
local _x, _y, _w, _h = 1, 1, term.getSize()

local success, set = fs.doFile("os/programs/stripMiner/data/settings.set")
set = set or {}
set.length = set.length or 0
set.searchWhiteList = set.searchWhiteList or "White List"
if set.pathSearchList and not fs.exists(set.pathSearchList) then
    set.pathSearchList = nil
end
set.trashWhiteList = set.trashWhiteList or "White List"
if set.pathTrashList and not fs.exists(set.pathTrashList) then
    set.pathTrashList = nil
end
set.slots = set.slots or {}
set.slots[1] = set.slots[1] or 1
set.slots[2] = set.slots[2] or 2
set.slots[3] = set.slots[3] or 3
set.slots[4] = set.slots[4] or 4
for i = 5, 16 do
    set.slots[i] = set.slots[i] or 0
end

local input = ui.input.new()
local drawer = ui.drawer.new(input, _x, _y, _w, _h)
for i = 1, _w * _h do
    if i <= _w or i > _w * (_h - 1) then
        drawer.buffer.text[i] = " "
        drawer.buffer.textColor[i] = colors.green
        drawer.buffer.textBackgroundColor[i] = colors.green
    else
        drawer.buffer.text[i] = " "
        drawer.buffer.textColor[i] = colors.white
        drawer.buffer.textBackgroundColor[i] = colors.white
    end
end
--ui.buffer.fill(drawer.buffer, " ", colors.white, colors.white)
local label_title = ui.label.new(drawer, "Strip Miner", theme.label1, _x, _y, _w - 3, 2)
local button_exit = ui.button.new(drawer, "<", theme.button2, _x + _w - 3, _y, 3, 1)

local label_length = ui.label.new(drawer, "Length: ", theme.label2, _x, _y + 1, 8, 1)
local iField_length = ui.inputField.new(drawer, nil, tostring(set.length), false, theme.iField2, _x + 8, _y + 1, _w - 8, 1)

local label_searchList = ui.label.new(drawer, "Search List", theme.label2, _x, _y + 3, 12, 1)
local button_searchList = ui.button.new(drawer, set.searchWhiteList, theme.button1, 13, _y + 3, math.floor(_w / 2), 1)

local button_pathSearchList = ui.button.new(drawer, "Path", theme.button1, _x, _y + 4, 6, 1)
local label_pathSearchList = ui.label.new(drawer, set.pathSearchList or "No Selection", theme.label2, _x + 7, _y + 4, _w - 7, 1)
if not set.pathSearchList then
    label_pathSearchList:changeMode(2, true)
end

local label_trashList = ui.label.new(drawer, "Trash List", theme.label2, _x, _y + 5, 12, 1)
local button_trashList = ui.button.new(drawer, set.trashWhiteList, theme.button1, 13, _y + 5, math.floor(_w / 2), 1)

local button_pathTrashList = ui.button.new(drawer, "Path", theme.button1, _x, _y + 6, 6, 1)
local label_pathTrashList = ui.label.new(drawer, set.pathTrashList or "No Selection", theme.label2, _x + 7, _y + 6, _w - 7, 1)
if not set.pathTrashList then
    label_pathTrashList:changeMode(2, true)
end

local text_slot = ui.text.new(drawer, "Slots:\n1: Chest    2: Fuel\n3: Build    4: Torch\n5: Ender Chest", theme.label2, _x, _y + 8, 26, 4)
local list_slots = {}
for i = 1, 16 do
    local x = _x + 26 + ((i - 1) % 4) * 3
    local y = _y + 8 + math.floor((i - 1) / 4)
    local button_slot = ui.button.new(drawer, tostring(set.slots[i]), theme.button1, x, y, 3, 1)
    table.insert(list_slots, button_slot)
end

local button_start = ui.button.new(drawer, "Start", theme.button1, _x + _w - 7, _h, 7, 1)
local button_saveSettings = ui.button.new(drawer, "Save Settings", theme.button1, _x, _h, 15, 1)

--Connect
local group_mainMenu = drawer.selectionManager:addNewGroup()
group_mainMenu.current = button_exit
local group_mainUp = drawer.selectionManager:addNewGroup()
group_mainUp.current = iField_length
local group_slot = drawer.selectionManager:addNewGroup()
group_slot.current = list_slots[1]
local group_mainDown = drawer.selectionManager:addNewGroup()
group_mainDown.current = button_start

group_mainMenu.previous = group_slot
group_mainUp.previous = group_mainMenu
group_slot.previous = group_mainUp
group_mainDown.previous = group_slot
group_mainMenu.next = group_mainUp
group_mainUp.next = group_slot
group_slot.next = group_mainDown
group_mainDown.next = group_mainMenu

group_mainMenu:addElement(button_exit, nil, nil, nil, iField_length)
group_mainUp:addElement(iField_length, nil, group_mainMenu, nil, button_searchList)
group_mainUp:addElement(button_searchList, nil, iField_length, nil, button_pathSearchList)
group_mainUp:addElement(button_pathSearchList, nil, button_searchList, nil, button_trashList)
group_mainUp:addElement(button_trashList, nil, button_pathSearchList, nil, button_pathTrashList)
group_mainUp:addElement(button_pathTrashList, nil, button_trashList, nil, group_slot)
group_mainDown:addElement(button_saveSettings, nil, group_slot, button_start, nil)
group_mainDown:addElement(button_start, button_saveSettings, group_slot, nil, nil)

for i = 1, 16, 4 do
    group_slot:addElement(list_slots[i], nil, list_slots[i - 4], list_slots[i + 1], list_slots[i + 4])
    group_slot:addElement(list_slots[i + 1], list_slots[i], list_slots[i - 3], list_slots[i + 2], list_slots[i + 5])
    group_slot:addElement(list_slots[i + 2], list_slots[i + 1], list_slots[i - 2], list_slots[i + 3], list_slots[i + 6])
    group_slot:addElement(list_slots[i + 3], list_slots[i + 2], list_slots[i - 1], nil, list_slots[i + 7])
end
for i = 1, 4 do
    list_slots[i].select.up = button_pathTrashList
end
for i = 13, 16 do
    list_slots[i].select.down = group_mainDown
end

local function updateStart()
    local possible = false
    local t = {}
    for i = 1, 5 do
        t[i] = 0
    end

    for i = 1, 16 do
        local number = tonumber(list_slots[i].text)
        if number > 0 then
            t[number] = t[number] + 1
        end
    end

    if ((t[1] > 0 and t[5] == 0) or (t[5] == 1 and t[1] == 0)) and (t[3] > 0 or t[4] == 0) and ((t[2] > 0) == (turtle.getFuelLimit() > 0)) and set.pathSearchList then
        possible = true
    end

    if possible then
        button_start:changeMode(1, true)
        group_mainDown.current = button_start
    else
        button_start:changeMode(2, true)
        group_mainDown.current = button_saveSettings
    end
end
updateStart()

function button_exit:onClick(event)
    input:exit()
end

function iField_length:onTextEdit(event, ...)
    if event == "char" or event == "text" or event == "paste" then
        local text = ...
        text = text:gsub("[^%d]", "")
        set.length = tonumber(self:combinedText(text))
        return text
    end
end

function button_searchList:onClick(event)
    if self.text == "White List" then
        self.text = "Black List"
    elseif self.text == "Black List" then
        self.text = "White List"
    end
    set.searchWhiteList = self.text
    updateStart()
    self:recalculate()
    self:repaint("this")
    button_start:repaint("this")
end

function button_pathSearchList:onClick(event)
    input:callFunction(
        function()
            local file = callfile("os/sys/explorer/main.lua", {select = event.name ~= "mouse_up", mode = "select_one", edit = false, type = "list"})
            if file then
                set.pathSearchList = file
                label_pathSearchList.text = set.pathSearchList
                label_pathSearchList:recalculate()
                updateStart()
            end
            drawer:draw()
        end
    )
end

function button_trashList:onClick(event)
    if self.text == "White List" then
        self.text = "Black List"
    elseif self.text == "Black List" then
        self.text = "White List"
    end
    set.trashWhiteList = self.text
    updateStart()
    self:recalculate()
    self:repaint("this")
    button_start:repaint("this")
end

function button_pathTrashList:onClick(event)
    input:callFunction(
        function()
            local file = callfile("os/sys/explorer/main.lua", {select = event.name ~= "mouse_up", mode = "select_one", edit = false, type = "list"})
            if file then
                set.pathTrashList = file
                label_pathTrashList.text = set.pathTrashList
                label_pathTrashList:recalculate()
            end
            drawer:draw()
        end
    )
end

for i = 1, 16 do
    local element = list_slots[i]
    function element:onClick(event)
        local positive = true
        if (event.name == "mouse_up" and event.param1 == 2) or (event.name == "key_up" and event.param1 == 29) then
            positive = false
        end

        local number = tonumber(self.text) or 0
        if positive then
            number = number + 1
            if number > 5 then
                number = 0
            end
        else
            number = number - 1
            if number < 0 then
                number = 5
            end
        end
        set.slots[i] = number
        self.text = tostring(number)

        updateStart()
        button_start:repaint("this")
        self:recalculate()
        if not self._inAnimation then
            self:repaint("this")
        end
    end
end

function button_saveSettings:onClick(event)
    table.save(set, "os/programs/stripMiner/data/settings.set")
end

function button_start:onClick(event)
    input:callFunction(
        function()
            term.clear()
            fs.delete("os/programs/stripMiner/data/move.set")
            fs.delete("os/programs/stripMiner/data/data.set")
            table.save(set, "os/programs/stripMiner/data/data.set")
            local file = fs.open("os/startup/50-stripMiner.lua", "w")
            file.write('dofile("os/programs/stripMiner/mine.lua")')
            file.close()
            dofile("os/programs/stripMiner/mine.lua")
            drawer:draw()
        end
    )
end

drawer.selectionManager:select(group_mainUp, "code", 1)
drawer:draw()
input:eventLoop({[term] = drawer.event})
