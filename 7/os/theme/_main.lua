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
exitButton.disabledTheme.textColor = colors.lightGrey
exitButton.disabledTheme.textBackgroundColor = colors.grey
exitButton.disabledTheme.borderColor = colors.lightGrey
exitButton.disabledTheme.borderBackgroundColor = colors.grey

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
menuButton.disabledTheme.textColor = colors.lightGrey
menuButton.disabledTheme.textBackgroundColor = colors.grey
menuButton.disabledTheme.borderColor = colors.lightGrey
menuButton.disabledTheme.borderBackgroundColor = colors.grey

---@type style.scrollView
local listView = style("scrollView")
listView.normalTheme.border = {{}, {}, {}, {}, {" "}, {" "}, {}, {}, {}}
listView.selectedTheme.border = {{}, {}, {}, {}, {" "}, {" "}, {}, {}, {}}
listView.disabledTheme.border = {{}, {}, {}, {}, {" "}, {" "}, {}, {}, {}}

---@type style.button
local listButton = style("button")
listButton.alignment = 1
listButton.normalTheme.border = {{}, {}, {}, {" "}, {" "}, {}, {}, {}, {}}
listButton.pressedTheme.border = {{}, {}, {}, {"\16"}, {" "}, {}, {}, {}, {}}
listButton.selectedTheme.border = {{}, {}, {}, {">"}, {" "}, {}, {}, {}, {}}
listButton.disabledTheme.border = {{}, {}, {}, {"*"}, {" "}, {}, {}, {}, {}}
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
listButton.disabledTheme.textColor = colors.grey
listButton.disabledTheme.textBackgroundColor = colors.white
listButton.disabledTheme.borderColor = colors.grey
listButton.disabledTheme.borderBackgroundColor = colors.white

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
deactivatedButton.disabledTheme.textColor = colors.lightGrey
deactivatedButton.disabledTheme.textBackgroundColor = colors.grey
deactivatedButton.disabledTheme.borderColor = colors.lightGrey
deactivatedButton.disabledTheme.borderBackgroundColor = colors.grey
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
activatedButton.disabledTheme.textColor = colors.lightGrey
activatedButton.disabledTheme.textBackgroundColor = colors.grey
activatedButton.disabledTheme.borderColor = colors.lightGrey
activatedButton.disabledTheme.borderBackgroundColor = colors.grey

local textBox = style("textBox")

---@type style.label
local pathLabel = style("label")
pathLabel.alignment = 1
pathLabel.normalTheme.backgroundColor = colors.lime
pathLabel.normalTheme.textColor = colors.black

assets.variables.save(
    "os/theme/main.lua",
    {
        exitButton = exitButton,
        menuButton = menuButton,
        listView = listView,
        listButton = listButton,
        activatedButton = activatedButton,
        deactivatedButton = deactivatedButton,
        textBox = textBox,
        pathLabel = pathLabel
    }
)
