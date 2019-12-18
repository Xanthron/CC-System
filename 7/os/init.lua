local width, height = term.getSize()

local style = ui.style.new()
---@type uiManager
local manager = ui.uiManager.new(1, 1, width, height)
manager.recalculate = function()
    local index
    for i = 1, width * height do
        if i <= width then
            manager.buffer.text[i] = " "
            manager.buffer.textColor[i] = colors.lime
            manager.buffer.textBackgroundColor[i] = colors.lime
        else
            manager.buffer.text[i] = " "
            manager.buffer.textColor[i] = colors.white
            manager.buffer.textBackgroundColor[i] = colors.white
        end
    end
end
manager.recalculate()

local inputField =
    ui.inputField.new(manager, "Input Field", "text", false, nil, style("inputField"), 15, 15, width - 15, 3)

local button1 = ui.button.new(manager, "button", nil, style("button"), 2, 15, 12, 3)
-- local toggleButton1 =
--     ui.toggleButton.new(
--     manager,
--     "Toggle",
--     true,
--     function(state)
--         redstone.setOutput("back", state)
--     end,
--     style("toggleButton"),
--     15,
--     16,
--     12,
--     1
-- )
-- toggleButton1._onToggle(toggleButton1._checked)
---@type selectionGroup
local selectionGroup = ui.selectionGroup.new()
manager.selectionManager.addSelectionGroup(selectionGroup)

local button1_selection = ui.selectionElement.new(button1)
local inputField1_selection = ui.selectionElement.new(inputField)

-- local toggleButton1_selection = ui.selectionElement.new(toggleButton1)

button1_selection.left = inputField1_selection
button1_selection.right = inputField1_selection
inputField1_selection.left = button1_selection
inputField1_selection.right = button1_selection

selectionGroup.addSelectionElement(button1_selection)
selectionGroup.addSelectionElement(inputField1_selection)
-- selectionGroup.addSelectionElement(toggleButton1_selection)
selectionGroup.currentSelectionElement = inputField1_selection

---@type textBox
local textBox =
    ui.textBox.new(
    manager,
    "Test Text Box",
    "Line 1\nLine 2\nLine 3\nLine 4\nLine 5\nLine 6\nLine 7\nLine 8\nLine 9\nLine 10",
    style("textBox"),
    2,
    2,
    20,
    11
)
local okButton = ui.button.new(textBox, "Ok", nil, style("button"), 3, 11, 6, 1)
local exitButton = ui.button.new(textBox, "Exit", nil, style("button"), 13, 11, 8, 1)
local okButton_selection = ui.selectionElement.new(okButton)
local exitButton_selection = ui.selectionElement.new(exitButton)
okButton_selection.right = exitButton_selection
exitButton_selection.left = okButton_selection
textBox.selectionGroup.addSelectionElement(okButton_selection)
textBox.selectionGroup.addSelectionElement(exitButton_selection)
textBox.selectionGroup.currentSelectionElement = okButton_selection

---@type scrollView
local scrollView = ui.scrollView.new(manager, "Test", true, true, style("scrollView"), 23, 2, 20, 12)

local scrollViewSelectionElements = {}
local scrollViewContainer = scrollView.getContainer()
---@type selectionElement
local buttons_selection = {}
for i = 1, 100 do
    local viewButton =
        ui.button.new(
        scrollViewContainer,
        "test " .. i,
        nil,
        style("button"),
        scrollViewContainer.getGlobalPosX() + i - 1,
        scrollViewContainer.getGlobalPosY() + i * 4 - 4,
        12,
        3
    )
    table.insert(buttons_selection, ui.selectionElement.new(viewButton))
end
for i = 1, #buttons_selection do
    if i > 1 then
        buttons_selection[i].up = buttons_selection[i - 1]
    end
    if i < #buttons_selection then
        buttons_selection[i].down = buttons_selection[i + 1]
    end
    scrollView.selectionGroup.addSelectionElement(buttons_selection[i])
end
scrollView.resetLayout()

scrollView.selectionGroup.next = textBox.selectionGroup
scrollView.selectionGroup.previous = selectionGroup
textBox.selectionGroup.next = selectionGroup
textBox.selectionGroup.previous = scrollView.selectionGroup
selectionGroup.next = scrollView.selectionGroup
selectionGroup.previous = textBox.selectionGroup

manager.selectionManager.addSelectionGroup(textBox.selectionGroup)
manager.selectionManager.addSelectionGroup(scrollView.selectionGroup)
manager.selectionManager.setCurrentSelectionGroup(selectionGroup)

manager.draw()
manager.execute()
