local args = ...
local x, y, w, h
if args.x then
    x = args.x
    y = args.y
    w = args.w
    h = args.h
else
    local x, y = 1, 1
    local w, h = term.getSize()
end
local label = args.label
local text = args.text
local textBoxTheme = args.theme or theme.tBox1
local manager = ui.uiManager.new(x, y, w, h)
local textBox = ui.textBox.new(manager, label, text, textBoxTheme, x, y, w, h)
local left = #textBox.style.nTheme.b[4]
local top = #textBox.style.nTheme.b[2]
local right = #textBox.style.nTheme.b[6]
local bottom = #textBox.style.nTheme.b[8]
local ret

if not args.button1 then
    args.button1 = args.button2
    args.button2 = nil
end

local button1, button2

if args.button1 then
    local length = args.button1:len() + 2
    button1 =
        ui.button.new(
        textBox,
        args.button1,
        function(self)
            ret = 1
            manager:exit()
        end,
        args.buttonTheme or theme.button1,
        x + w - right - 1 - length,
        y + h - math.floor(bottom / 2) - 1,
        length,
        1
    )
    textBox.selectionGroup:addElement(button1)
end
if args.button2 then
    local length = args.button2:len() + 2
    button2 =
        ui.button.new(
        textBox,
        args.button2,
        function(self)
            ret = 2
            manager:exit()
        end,
        args.buttonTheme or theme.button1,
        x + left + 1,
        y + h - math.floor(bottom / 2) - 1,
        length,
        1
    )
    textBox.selectionGroup:addElement(button2, nil, nil, button1, nil, true)
end
manager.selectionManager:addGroup(textBox.selectionGroup)
manager.selectionManager:select(button1, "code", 3)
manager:draw()
manager:execute()

return ret
--TODO return select
--TODO error handling
