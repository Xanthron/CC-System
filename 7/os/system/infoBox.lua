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
local button1 = args.button1
local button2 = args.button2
local textBoxTheme = args.theme or theme.tBox1
local manager = ui.uiManager.new(x, y, w, h)
local textBox = ui.textBox.new(manager, label, text, textBoxTheme, x, y, w, h)
local left = #textBox.style.nTheme.b[4]
local top = #textBox.style.nTheme.b[2]
local right = #textBox.style.nTheme.b[6]
local bottom = #textBox.style.nTheme.b[8]
local button1_selection = nil
if button1 then
    local length = button1.name:len() + 2
    local button1 =
        ui.button.new(
        textBox,
        button1.name,
        function()
            button1.func()
            manager.exit()
        end,
        button1.theme or theme.button1,
        x + w - right - 1 - length,
        y + h - math.floor(bottom / 2) - 1,
        length,
        1
    )
    if button2 then
        button1.setGlobalRect(x + left, nil, nil, nil)
    end
    button1_selection = textBox.selectionGroup.addNewSelectionElement(button1)
end
local button2_selection = nil
if button2 then
    local button2 =
        ui.button.new(
        textBox,
        button2.name,
        function()
            button2.func()
            manager.exit = true
        end,
        button2.theme or theme.button1,
        x + w - right - 1,
        y + h - math.floor(bottom / 2) - 1,
        button2.name:len() + 2,
        1
    )
    button2_selection = textBox.selectionGroup.addNewSelectionElement(button2)
end
if button2_selection then
    button2_selection.left = button1_selection
    textBox.selectionGroup.currentSelectionElement = button2_selection
end
if button1_selection then
    button1_selection.right = button2_selection
    textBox.selectionGroup.currentSelectionElement = button1_selection
end
manager.selectionManager.addSelectionGroup(textBox.selectionGroup)
manager.selectionManager.setCurrentSelectionGroup(textBox.selectionGroup, "code")
manager.draw()
manager.execute()
