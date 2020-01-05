---@type style
local style = ui.style.new()

---@type style.button
local exitButton = style("button")
if term.isColor() then
    exitButton.normalTheme.border = {{}, {}, {}, {" "}, {" "}, {" "}, {}, {}, {}}
    exitButton.pressedTheme.border = {{}, {}, {}, {" "}, {" "}, {" "}, {}, {}, {}}
    exitButton.selectedTheme.border = {{}, {}, {}, {" "}, {" "}, {" "}, {}, {}, {}}
    exitButton.disabledTheme.border = {{}, {}, {}, {" "}, {" "}, {" "}, {}, {}, {}}
else
    exitButton.normalTheme.border = {{}, {}, {}, {" "}, {" "}, {" "}, {}, {}, {}}
    exitButton.pressedTheme.border = {{}, {}, {}, {"["}, {" "}, {"]"}, {}, {}, {}}
    exitButton.selectedTheme.border = {{}, {}, {}, {"["}, {" "}, {"]"}, {}, {}, {}}
    exitButton.disabledTheme.border = {{}, {}, {}, {"*"}, {" "}, {"*"}, {}, {}, {}}
end
exitButton.normalTheme.textColor = colors.white
exitButton.normalTheme.textBackgroundColor = colors.red
exitButton.normalTheme.borderColor = colors.white
exitButton.normalTheme.borderBackgroundColor = colors.red
exitButton.pressedTheme.textColor = colors.white
exitButton.pressedTheme.textBackgroundColor = colors.orange
exitButton.pressedTheme.borderColor = colors.white
exitButton.pressedTheme.borderBackgroundColor = colors.orange
exitButton.selectedTheme.textColor = colors.orange
exitButton.selectedTheme.textBackgroundColor = colors.red
exitButton.selectedTheme.borderColor = colors.orange
exitButton.selectedTheme.borderBackgroundColor = colors.red
exitButton.disabledTheme.textColor = colors.lightGray
exitButton.disabledTheme.textBackgroundColor = colors.gray
exitButton.disabledTheme.borderColor = colors.lightGray
exitButton.disabledTheme.borderBackgroundColor = colors.gray

---@type style.button
local menuButton = style("button")
if term.isColor() then
    menuButton.normalTheme.border = {{}, {}, {}, {" "}, {" "}, {" "}, {}, {}, {}}
    menuButton.pressedTheme.border = {{}, {}, {}, {" "}, {" "}, {" "}, {}, {}, {}}
    menuButton.selectedTheme.border = {{}, {}, {}, {" "}, {" "}, {" "}, {}, {}, {}}
    menuButton.disabledTheme.border = {{}, {}, {}, {" "}, {" "}, {" "}, {}, {}, {}}
else
    menuButton.normalTheme.border = {{}, {}, {}, {" "}, {" "}, {" "}, {}, {}, {}}
    menuButton.pressedTheme.border = {{}, {}, {}, {"["}, {" "}, {"]"}, {}, {}, {}}
    menuButton.selectedTheme.border = {{}, {}, {}, {"["}, {" "}, {"]"}, {}, {}, {}}
    menuButton.disabledTheme.border = {{}, {}, {}, {"*"}, {" "}, {"*"}, {}, {}, {}}
end
menuButton.normalTheme.textColor = colors.white
menuButton.normalTheme.textBackgroundColor = colors.green
menuButton.normalTheme.borderColor = colors.white
menuButton.normalTheme.borderBackgroundColor = colors.green
menuButton.pressedTheme.textColor = colors.orange
menuButton.pressedTheme.textBackgroundColor = colors.green
menuButton.pressedTheme.borderColor = colors.orange
menuButton.pressedTheme.borderBackgroundColor = colors.green
menuButton.selectedTheme.textColor = colors.yellow
menuButton.selectedTheme.textBackgroundColor = colors.green
menuButton.selectedTheme.borderColor = colors.yellow
menuButton.selectedTheme.borderBackgroundColor = colors.green
menuButton.disabledTheme.textColor = colors.gray
menuButton.disabledTheme.textBackgroundColor = colors.green
menuButton.disabledTheme.borderColor = colors.gray
menuButton.disabledTheme.borderBackgroundColor = colors.green

---@type style.scrollView
local listView = style("scrollView")
listView.normalTheme.border = {{}, {}, {}, {}, {" "}, {" "}, {}, {}, {}}
listView.selectedTheme.border = {{}, {}, {}, {}, {" "}, {" "}, {}, {}, {}}
listView.disabledTheme.border = {{}, {}, {}, {}, {" "}, {" "}, {}, {}, {}}
---@type style.scrollView
local listBox = style("scrollView")
listBox.label.alignment = 1
listBox.label.normalTheme.textColor = colors.black
listBox.label.selectedTheme.textColor = colors.black
listBox.label.disabledTheme.textColor = colors.black
listBox.normalTheme.spaceTextColor = colors.black
listBox.normalTheme.borderColor = colors.black
listBox.normalTheme.spaceBackgroundColor = colors.white
listBox.normalTheme.borderBackgroundColor = colors.white
listBox.selectedTheme.spaceTextColor = colors.black
listBox.selectedTheme.spaceTextColor = colors.black
listBox.selectedTheme.borderColor = colors.black
listBox.selectedTheme.borderColor = colors.black
listBox.disabledTheme.spaceBackgroundColor = colors.white
listBox.disabledTheme.spaceBackgroundColor = colors.white
listBox.disabledTheme.borderBackgroundColor = colors.white
listBox.disabledTheme.borderBackgroundColor = colors.white

listBox.sliderHorizontal.normal.buttonNegative.normal.backgroundColor = {colors.white}
listBox.sliderHorizontal.normal.buttonNegative.normal.color = {colors.black}
listBox.sliderHorizontal.normal.buttonNegative.disabled.backgroundColor = {colors.white}
listBox.sliderHorizontal.normal.buttonNegative.disabled.color = {colors.gray}
listBox.sliderHorizontal.normal.buttonNegative.selected.backgroundColor = {colors.white}
listBox.sliderHorizontal.normal.buttonNegative.selected.color = {colors.orange}
listBox.sliderHorizontal.disabled.buttonNegative.disabled.backgroundColor = {colors.white}
listBox.sliderHorizontal.disabled.buttonNegative.disabled.color = {colors.gray}

listBox.sliderHorizontal.normal.buttonPositive.normal.backgroundColor = {colors.white}
listBox.sliderHorizontal.normal.buttonPositive.normal.color = {colors.black}
listBox.sliderHorizontal.normal.buttonPositive.disabled.backgroundColor = {colors.white}
listBox.sliderHorizontal.normal.buttonPositive.disabled.color = {colors.gray}
listBox.sliderHorizontal.normal.buttonPositive.selected.backgroundColor = {colors.white}
listBox.sliderHorizontal.normal.buttonPositive.selected.color = {colors.orange}
listBox.sliderHorizontal.disabled.buttonPositive.disabled.backgroundColor = {colors.white}
listBox.sliderHorizontal.disabled.buttonPositive.disabled.color = {colors.gray}

listBox.sliderVertical.normal.buttonNegative.normal.backgroundColor = {colors.white}
listBox.sliderVertical.normal.buttonNegative.normal.color = {colors.black}
listBox.sliderVertical.normal.buttonNegative.disabled.backgroundColor = {colors.white}
listBox.sliderVertical.normal.buttonNegative.disabled.color = {colors.gray}
listBox.sliderVertical.normal.buttonNegative.selected.backgroundColor = {colors.white}
listBox.sliderVertical.normal.buttonNegative.selected.color = {colors.orange}
listBox.sliderVertical.disabled.buttonNegative.disabled.backgroundColor = {colors.white}
listBox.sliderVertical.disabled.buttonNegative.disabled.color = {colors.gray}

listBox.sliderVertical.normal.buttonPositive.normal.backgroundColor = {colors.white}
listBox.sliderVertical.normal.buttonPositive.normal.color = {colors.black}
listBox.sliderVertical.normal.buttonPositive.disabled.backgroundColor = {colors.white}
listBox.sliderVertical.normal.buttonPositive.disabled.color = {colors.gray}
listBox.sliderVertical.normal.buttonPositive.selected.backgroundColor = {colors.white}
listBox.sliderVertical.normal.buttonPositive.selected.color = {colors.orange}
listBox.sliderVertical.disabled.buttonPositive.disabled.backgroundColor = {colors.white}
listBox.sliderVertical.disabled.buttonPositive.disabled.color = {colors.gray}

listBox.sliderHorizontal.normal.handleBackgroundColor = {colors.white}
listBox.sliderHorizontal.normal.handleColor = {colors.gray}
listBox.sliderHorizontal.normal.sliderBackgroundColor = {colors.white}
listBox.sliderHorizontal.normal.sliderColor = {colors.black}
listBox.sliderVertical.normal.handleBackgroundColor = {colors.white}
listBox.sliderVertical.normal.handleColor = {colors.gray}
listBox.sliderVertical.normal.sliderBackgroundColor = {colors.white}
listBox.sliderVertical.normal.sliderColor = {colors.black}

---@type style.button
local listButton = style("button")
if term.isColor() then
    listButton.normalTheme.border = {{}, {}, {}, {" "}, {" "}, {}, {}, {}, {}}
    listButton.pressedTheme.border = {{}, {}, {}, {"\16"}, {" "}, {}, {}, {}, {}}
    listButton.selectedTheme.border = {{}, {}, {}, {">"}, {" "}, {}, {}, {}, {}}
    listButton.disabledTheme.border = {{}, {}, {}, {" "}, {" "}, {}, {}, {}, {}}
else
    listButton.normalTheme.border = {{}, {}, {}, {" "}, {" "}, {}, {}, {}, {}}
    listButton.pressedTheme.border = {{}, {}, {}, {"\16"}, {" "}, {}, {}, {}, {}}
    listButton.selectedTheme.border = {{}, {}, {}, {">"}, {" "}, {}, {}, {}, {}}
    listButton.disabledTheme.border = {{}, {}, {}, {"*"}, {" "}, {}, {}, {}, {}}
end
listButton.alignment = 1
listButton.normalTheme.textColor = colors.black
listButton.normalTheme.textBackgroundColor = colors.white
listButton.normalTheme.borderColor = colors.black
listButton.normalTheme.borderBackgroundColor = colors.white
listButton.pressedTheme.textColor = colors.orange
listButton.pressedTheme.textBackgroundColor = colors.white
listButton.pressedTheme.borderColor = colors.orange
listButton.pressedTheme.borderBackgroundColor = colors.white
listButton.selectedTheme.textColor = colors.orange
listButton.selectedTheme.textBackgroundColor = colors.white
listButton.selectedTheme.borderColor = colors.orange
listButton.selectedTheme.borderBackgroundColor = colors.white
listButton.disabledTheme.textColor = colors.lightGray
listButton.disabledTheme.textBackgroundColor = colors.white
listButton.disabledTheme.borderColor = colors.lightGray
listButton.disabledTheme.borderBackgroundColor = colors.white

---@type style.button
local selectedListButton = style("button")
if term.isColor() then
    selectedListButton.normalTheme.border = {{}, {}, {}, {" "}, {" "}, {}, {}, {}, {}}
    selectedListButton.pressedTheme.border = {{}, {}, {}, {"\16"}, {" "}, {}, {}, {}, {}}
    selectedListButton.selectedTheme.border = {{}, {}, {}, {">"}, {" "}, {}, {}, {}, {}}
    selectedListButton.disabledTheme.border = {{}, {}, {}, {" "}, {" "}, {}, {}, {}, {}}
else
    selectedListButton.normalTheme.border = {{}, {}, {}, {"x"}, {" "}, {}, {}, {}, {}}
    selectedListButton.pressedTheme.border = {{}, {}, {}, {"\16"}, {" "}, {}, {}, {}, {}}
    selectedListButton.selectedTheme.border = {{}, {}, {}, {">"}, {" "}, {}, {}, {}, {}}
    selectedListButton.disabledTheme.border = {{}, {}, {}, {"*"}, {" "}, {}, {}, {}, {}}
end
selectedListButton.alignment = 1
selectedListButton.normalTheme.textColor = colors.blue
selectedListButton.normalTheme.textBackgroundColor = colors.white
selectedListButton.normalTheme.borderColor = colors.blue
selectedListButton.normalTheme.borderBackgroundColor = colors.white
selectedListButton.pressedTheme.textColor = colors.red
selectedListButton.pressedTheme.textBackgroundColor = colors.white
selectedListButton.pressedTheme.borderColor = colors.red
selectedListButton.pressedTheme.borderBackgroundColor = colors.white
selectedListButton.selectedTheme.textColor = colors.red
selectedListButton.selectedTheme.textBackgroundColor = colors.white
selectedListButton.selectedTheme.borderColor = colors.red
selectedListButton.selectedTheme.borderBackgroundColor = colors.white
selectedListButton.disabledTheme.textColor = colors.lightGray
selectedListButton.disabledTheme.textBackgroundColor = colors.white
selectedListButton.disabledTheme.borderColor = colors.lightGray
selectedListButton.disabledTheme.borderBackgroundColor = colors.white

---@type style.button
local deactivatedButton = style("button")
if term.isColor() then
    deactivatedButton.normalTheme.border = {{}, {}, {}, {" "}, {" "}, {" "}, {}, {}, {}}
    deactivatedButton.pressedTheme.border = {{}, {}, {}, {" "}, {" "}, {" "}, {}, {}, {}}
    deactivatedButton.selectedTheme.border = {{}, {}, {}, {" "}, {" "}, {" "}, {}, {}, {}}
    deactivatedButton.disabledTheme.border = {{}, {}, {}, {" "}, {" "}, {" "}, {}, {}, {}}
else
    deactivatedButton.normalTheme.border = {{}, {}, {}, {" "}, {" "}, {" "}, {}, {}, {}}
    deactivatedButton.pressedTheme.border = {{}, {}, {}, {"["}, {" "}, {"]"}, {}, {}, {}}
    deactivatedButton.selectedTheme.border = {{}, {}, {}, {"["}, {" "}, {"]"}, {}, {}, {}}
    deactivatedButton.disabledTheme.border = {{}, {}, {}, {"*"}, {" "}, {"*"}, {}, {}, {}}
end
deactivatedButton.normalTheme.textColor = colors.white
deactivatedButton.normalTheme.textBackgroundColor = colors.lime
deactivatedButton.normalTheme.borderColor = colors.white
deactivatedButton.normalTheme.borderBackgroundColor = colors.lime
deactivatedButton.pressedTheme.textColor = colors.orange
deactivatedButton.pressedTheme.textBackgroundColor = colors.lime
deactivatedButton.pressedTheme.borderColor = colors.orange
deactivatedButton.pressedTheme.borderBackgroundColor = colors.lime
deactivatedButton.selectedTheme.textColor = colors.yellow
deactivatedButton.selectedTheme.textBackgroundColor = colors.lime
deactivatedButton.selectedTheme.borderColor = colors.yellow
deactivatedButton.selectedTheme.borderBackgroundColor = colors.lime
deactivatedButton.disabledTheme.textColor = colors.lightGray
deactivatedButton.disabledTheme.textBackgroundColor = colors.gray
deactivatedButton.disabledTheme.borderColor = colors.lightGray
deactivatedButton.disabledTheme.borderBackgroundColor = colors.gray
local activatedButton = style("button")
if term.isColor() then
    activatedButton.normalTheme.border = {{}, {}, {}, {" "}, {" "}, {" "}, {}, {}, {}}
    activatedButton.pressedTheme.border = {{}, {}, {}, {" "}, {" "}, {" "}, {}, {}, {}}
    activatedButton.selectedTheme.border = {{}, {}, {}, {" "}, {" "}, {" "}, {}, {}, {}}
    activatedButton.disabledTheme.border = {{}, {}, {}, {" "}, {" "}, {" "}, {}, {}, {}}
else
    activatedButton.normalTheme.border = {{}, {}, {}, {" "}, {" "}, {" "}, {}, {}, {}}
    activatedButton.pressedTheme.border = {{}, {}, {}, {"["}, {" "}, {"]"}, {}, {}, {}}
    activatedButton.selectedTheme.border = {{}, {}, {}, {"["}, {" "}, {"]"}, {}, {}, {}}
    activatedButton.disabledTheme.border = {{}, {}, {}, {"*"}, {" "}, {"*"}, {}, {}, {}}
end
activatedButton.normalTheme.textColor = colors.white
activatedButton.normalTheme.textBackgroundColor = colors.orange
activatedButton.normalTheme.borderColor = colors.white
activatedButton.normalTheme.borderBackgroundColor = colors.orange
activatedButton.pressedTheme.textColor = colors.red
activatedButton.pressedTheme.textBackgroundColor = colors.orange
activatedButton.pressedTheme.borderColor = colors.red
activatedButton.pressedTheme.borderBackgroundColor = colors.orange
activatedButton.selectedTheme.textColor = colors.yellow
activatedButton.selectedTheme.textBackgroundColor = colors.orange
activatedButton.selectedTheme.borderColor = colors.yellow
activatedButton.selectedTheme.borderBackgroundColor = colors.orange
activatedButton.disabledTheme.textColor = colors.lightGray
activatedButton.disabledTheme.textBackgroundColor = colors.gray
activatedButton.disabledTheme.borderColor = colors.lightGray
activatedButton.disabledTheme.borderBackgroundColor = colors.gray

local textBox = style("textBox")

local inputField = style("inputField")
inputField.normalTheme.border = {{}, {}, {}, {}, {" "}, {}, {}, {}, {}}
inputField.disabledTheme.border = {{}, {}, {}, {}, {" "}, {}, {}, {}, {}}
inputField.selectedTheme.border = {{}, {}, {}, {}, {" "}, {}, {}, {}, {}}
---@type style.inputField
local pathField = style("inputField")
pathField.alignment = 3
pathField.normalTheme.border = {{}, {}, {}, {}, {" "}, {}, {}, {}, {}}
pathField.normalTheme.spaceColor = colors.lime
pathField.normalTheme.textColor = colors.black
pathField.normalTheme.textBackgroundColor = colors.lime

pathField.disabledTheme.border = {{}, {}, {}, {}, {" "}, {}, {}, {}, {}}
pathField.selectedTheme.border = {{}, {}, {}, {}, {" "}, {}, {}, {}, {}}

---@type style.label
local selectedLabel = style("label")
selectedLabel.alignment = 1
selectedLabel.normalTheme.backgroundColor = colors.green
selectedLabel.normalTheme.textColor = colors.black

assets.variables.save(
    "os/theme/main.lua",
    {
        exitButton = exitButton,
        menuButton = menuButton,
        listView = listView,
        listButton = listButton,
        selectedListButton = selectedListButton,
        activatedButton = activatedButton,
        deactivatedButton = deactivatedButton,
        textBox = textBox,
        selectedLabel = selectedLabel,
        listBox = listBox,
        pathField = pathField,
        inputField = inputField
    }
)
