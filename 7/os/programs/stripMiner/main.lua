--[[
Strip Miner                        [x]
Length: [                            ]

[O] Save Path   [0] Ender Chest

[  White List  ][Edit]
Path: 

Slots:  [Chest][Fuel ][Build][Build]   
        [None ][None ][None ][None ]   
        [None ][None ][None ][None ]   
        [None ][None ][None ][None ]   
                               [Start]
]]
--[[
Modes:
Mining
Refuling
Make Place
Empty Chest
Go Back
Request Item
]]
--[[
Setings
length 0 = infinite
slotType Fuel,Chest,Building,None
savePath
enderChest
whitelist/Blacklist
]]
local _x, _y, _w, _h = 1, 1, term.getSize()

local success, set = fs.doFile("os/programs/stripMine/settings")
if not success then
    set = {}
    set.length = 0
    set.path = nil
    set.savePath = false
    set.enderChest = false
    set.whiteList = "White List"
    set.destroy = true
    set.slots = {}
    set.slots[1] = "Chest"
    set.slots[2] = "Fuel"
    for i = 3, 16 do
        set.slots[i] = "None"
    end
end

local manager = ui.uiManager.new(_x, _y, _w, _h)
for i = 1, _w * _h do
    if i <= _w or i >= _w * (_h - 1) then
        manager.buffer.text[i] = " "
        manager.buffer.textColor[i] = colors.green
        manager.buffer.textBackgroundColor[i] = colors.green
    else
        manager.buffer.text[i] = " "
        manager.buffer.textColor[i] = colors.white
        manager.buffer.textBackgroundColor[i] = colors.white
    end
end
local label_title = ui.label.new(manager, "Strip Miner", theme.label1, _x, _y, _w - 3, 1)
local button_exit = ui.button.new(manager, "<", nil, theme.button2, _x + _w - 3, _y, 3, 1)

local label_length = ui.label.new(manager, "Length: ", theme.label2, _x, _y + 1, 8, 1)
local iField_length = ui.inputField.new(manager, "", tostring(set.length), false, nil, theme.iField1, _x + 8, _y + 1, _w - 8, 1)

local toggle_savePath = ui.toggleButton.new(manager, "Save Path", set.savePath, nil, theme.toggle1, _x, _y + 3, math.floor(_w / 2), 1)
local toggle_enderChest = ui.toggleButton.new(manager, "Ender Chest", set.enderChest, nil, theme.toggle1, _x + math.floor(_w / 2), _y + 3, math.floor(_w / 2), 1)

local button_whiteList = ui.button.new(manager, set.whiteList, nil, theme.button1, _x, _y + 5, math.floor(_w / 2), 1)
local toggle_destroy = ui.toggleButton.new(manager, "Destroy Reject", set.destroy, nil, theme.toggle1, _x + math.floor(_w / 2), _y + 5, math.floor(_w / 2), 1)

local button_path = ui.button.new(manager, "Path", nil, theme.button1, _x, _y + 6, 6, 1)
local label_path = ui.label.new(manager, set.path or "No Selection", theme.label2, _x + 7, _y + 6, _w - 7, 1)

local label_slot = ui.label.new(manager, "Slots:", theme.label2, _x, _y + 8, 8, 1)
local list_slots = {}
for i = 1, 16 do
    local x = _x + 8 + ((i - 1) % 4) * 8
    local y = _y + 8 + math.floor((i - 1) / 4)
    local button_slot = ui.button.new(manager, set.slots[i], nil, theme.button1, x, y, 7, 1)
    table.insert(list_slots, button_slot)
end

local button_start = ui.button.new(manager, "Start", nil, theme.button1, _x + _w - 7, _h, 7, 1)
local button_saveSettings = ui.button.new(manager, "Save Settings", nil, theme.button1, _x, _h, 15, 1)

local function updateStart()
    local possible = false
    local list, chest, fuel, build = false, false, false, not set.savePath
    if set.path then
        list = true
    end
    for i = 1, 16 do
        if not chest and set.slots[i] == "Chest" then
            chest = true
        end
        if not fuel and set.slots[i] == "Fuel" then
            fuel = true
        end
        if set.savePath ~= build and set.slots[i] == "Build" then
            if set.savePath then
                build = true
            else
                build = false
            end
        end
    end
    if list and chest and fuel and build then
        possible = true
    end

    if possible then
        button_start:changeMode(1, true)
    else
        button_start:changeMode(2, true)
    end
end

updateStart()

function iField_length:onTextEdit(event, ...)
    if event == "char" or event == "text" or event == "paste" then
        local text = ...
        text = text:gsub("[^%d]", "")
        set.length = tonumber(self:combinedText(text))
        return text
    end
end

function toggle_savePath:_onToggle(event, checked)
    set.savePath = checked
    updateStart()
    button_start:repaint("this")
end

function toggle_enderChest:_onToggle(event, checked)
    set.enderChest = checked
end

function toggle_destroy:_onToggle(event, checked)
    set.destroy = checked
end

function button_whiteList:_onClick(event)
    if self.text == "White List" then
        self.text = "Black List"
    elseif self.text == "Black List" then
        self.text = "White List"
    end
    set.whiteList = self.text
    updateStart()
    self:recalculate()
    self:repaint("this")
    button_start:repaint("this")
end

function button_path:_onClick(event)
    manager:callFunction(
        function()
            local file = assert(loadfile("os/sys/explorer/main.lua"))({select = event.name ~= "mouse_up", mode = "select_one", edit = false, type = "list"})
            if file then
                set.path = file
                label_path.text = set.path
                label_path:recalculate()
                updateStart()
            end
            manager:draw()
        end
    )
end

for i = 1, 16 do
    local element = list_slots[i]
    function element:_onClick(event)
        local positive = true
        if (event.name == "mouse_up" and event.param1 == 2) or (event.name == "key_up" and event.param1 == 29) then
            positive = false
        end

        if self.text == "None" then
            if positive then
                self.text = "Chest"
            elseif toggle_savePath._checked then
                self.text = "Build"
            else
                self.text = "Fuel"
            end
        elseif self.text == "Chest" then
            if positive then
                self.text = "Fuel"
            else
                self.text = "None"
            end
        elseif self.text == "Fuel" then
            if not positive then
                self.text = "Chest"
            elseif toggle_savePath._checked then
                self.text = "Build"
            else
                self.text = "None"
            end
        elseif self.text == "Build" then
            if positive then
                self.text = "None"
            else
                self.text = "Fuel"
            end
        end
        set.slots[i] = self.text
        updateStart()
        button_start:repaint("this")
        self:recalculate()
        self:repaint("this")
    end
end

function button_saveSettings:_onClick(event)
    table.save(set, "os/programs/stripMine/settings")
end

manager:draw()
manager:execute()
