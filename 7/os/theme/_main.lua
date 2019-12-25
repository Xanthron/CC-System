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
menuButton.pressedTheme.textColor = colors.white
menuButton.pressedTheme.textBackgroundColor = colors.lime
menuButton.pressedTheme.borderColor = colors.white
menuButton.pressedTheme.borderBackgroundColor = colors.lime
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
listView.assets.variables.save(
    "os/theme/main.lua",
    {
        exitButton = exitButton,
        menuButton = menuButton,
        listView = listView
    }
)
