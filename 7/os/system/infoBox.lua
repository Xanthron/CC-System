local set = ...
local x, y, w, h
if set.x then
    x = set.x
    y = set.y
    w = set.w
    h = set.h
else
    x, y = 1, 1
    w, h = term.getSize()
end

utility.checkType(set, "x", "number", false)
utility.checkType(set, "y", "number", false)
utility.checkType(set, "w", "number", false)
utility.checkType(set, "h", "number", false)
utility.checkType(set, "text", "string", true)
utility.checkType(set, "label", "string", false)
utility.checkType(set, "select", "boolean", true)
utility.checkType(set, "tBoxT", "table", true, theme.tBox1)
utility.checkType(set, "buttonT", "table", true, theme.button1)
utility.checkType(set, "button1", "string", true, theme.button1)

local manager = ui.uiManager.new(x, y, w, h)
local textBox = ui.textBox.new(manager, set.label, set.text, set.tBoxT, x, y, w, h)
local left = #textBox.style.nTheme.b[4]
local top = #textBox.style.nTheme.b[2]
local right = #textBox.style.nTheme.b[6]
local bottom = #textBox.style.nTheme.b[8]
local select = set.select
local ret

if not set.button1 then
    set.button1 = set.button2
    set.button2 = nil
end

local button1, button2

if set.button1 then
    local length = set.button1:len() + 2
    button1 =
        ui.button.new(
        textBox,
        set.button1,
        function(self, event)
            ret = 1
            select = event.name ~= "mouse_up"
            manager:exit()
        end,
        set.buttonT or theme.button1,
        x + w - right - 1 - length,
        y + h - math.floor(bottom / 2) - 1,
        length,
        1
    )
    textBox.selectionGroup:addElement(button1)
end
if set.button2 then
    local length = set.button2:len() + 2
    button2 =
        ui.button.new(
        textBox,
        set.button2,
        function(self, event)
            ret = 2
            select = event.name ~= "mouse_up"
            manager:exit()
        end,
        set.buttonT or theme.button1,
        x + left + 1,
        y + h - math.floor(bottom / 2) - 1,
        length,
        1
    )
    textBox.selectionGroup:addElement(button2, nil, nil, button1, nil, true)
end
manager.selectionManager:addGroup(textBox.selectionGroup)
local mode = 3
if set.select == false then
    mode = 1
end
manager.selectionManager:select(button1, "code", mode)
manager:draw()
manager:execute()

return ret, select
