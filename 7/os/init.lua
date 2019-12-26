local width, height = term.getSize()

local success
success, _G.theme = ui.theme.load("main.lua")

---@type uiManager
local manager = ui.uiManager.new(1, 1, width, height)
local index
for i = 1, width * height do
    if i <= width then
        manager.buffer.text[i] = " "
        manager.buffer.textColor[i] = colors.green
        manager.buffer.textBackgroundColor[i] = colors.green
    else
        manager.buffer.text[i] = " "
        manager.buffer.textColor[i] = colors.white
        manager.buffer.textBackgroundColor[i] = colors.white
    end
end

---@type style.button

local browserButton =
    ui.button.new(
    manager,
    "Browser",
    function()
    end,
    theme.menuButton,
    1,
    1,
    10,
    1
)
local explorerButton =
    ui.button.new(
    manager,
    "Explorer",
    function()
        manager.callFunction(
            function()
                assert(loadfile("os/system/execute.lua"))("os/system/explorer/explorer.lua")
                manager.draw()
            end
        )
    end,
    theme.menuButton,
    11,
    1,
    10,
    1
)
local optionButton =
    ui.button.new(
    manager,
    "\164",
    function()
    end,
    theme.menuButton,
    width - 5,
    1,
    3,
    1
)
local exitButton =
    ui.button.new(
    manager,
    "x",
    function()
        term.setCursorPos(1, 1)
        if term.isColor() then
            term.setBackgroundColor(colors.black)
            term.setTextColor(colors.white)
        end
        term.clear()
        manager.exit()
    end,
    theme.exitButton,
    width - 2,
    1,
    3,
    1
)
---@type selectionGroup
local menuSelectionGroup = manager.selectionManager.addNewSelectionGroup()
local browserButton_selection = menuSelectionGroup.addNewSelectionElement(browserButton)
local explorerButton_selection = menuSelectionGroup.addNewSelectionElement(explorerButton)
local optionButton_selection = menuSelectionGroup.addNewSelectionElement(optionButton)
local exitButton_selection = menuSelectionGroup.addNewSelectionElement(exitButton)
browserButton_selection.right = explorerButton_selection
explorerButton_selection.right = optionButton_selection
optionButton_selection.right = exitButton_selection
exitButton_selection.left = optionButton_selection
optionButton_selection.left = explorerButton_selection
explorerButton_selection.left = browserButton_selection
menuSelectionGroup.currentSelectionElement = browserButton_selection

---@type scrollView
local listView = ui.scrollView.new(manager, nil, 3, theme.listView, 1, 2, width, height - 1)
local backgroundListView = listView._elements[1]
local backgroundListViewBuffer = backgroundListView.buffer
for i = 1, height - 1 do
    index = (i - 1) * (width - 1) + width - 11
    backgroundListViewBuffer.text[index] = "|"
    backgroundListViewBuffer.textColor[index] = colors.black
    backgroundListViewBuffer.textBackgroundColor[index] = colors.white
    index = index + 4
    backgroundListViewBuffer.text[index] = "|"
    backgroundListViewBuffer.textColor[index] = colors.black
    backgroundListViewBuffer.textBackgroundColor[index] = colors.white
    index = index + 6
    backgroundListViewBuffer.text[index] = "|"
    backgroundListViewBuffer.textColor[index] = colors.black
    backgroundListViewBuffer.textBackgroundColor[index] = colors.white
end
local function updateListView()
    local programs = fs.list("os/programs/")
    local container = listView.getContainer()
    table.remove(container._elements)
    ---@type selectionElement[]
    local programSelectionElements = {}
    for i, value in ipairs(programs) do
        local startFunction
        local startupFunction
        local delFunction

        if fs.isDir("os/programs/" .. value) then
        else
            startFunction = function()
                manager.callFunction(
                    function()
                        assert(loadfile("os/system/execute.lua"))("os/programs/" .. value)
                        manager.draw()
                    end
                )
            end
        end
        local buttonWidth = width - 12
        local name =
            (value:sub(1, 1):upper() .. value:sub(2)):gsub("%.[^%.]*$", ""):gsub(
            "%l%u",
            function(text)
                return text:sub(1, 1) .. " " .. text:sub(2, 2)
            end
        )
        if name:len() > width then
            name = name:sub(1, width - 3) .. "..."
        end

        local programButton = ui.button.new(container, name, startFunction, theme.listButton, 1, i + 1, buttonWidth, 1)
        table.insert(programSelectionElements, listView.selectionGroup.addNewSelectionElement(programButton))
        local startupButton =
            ui.button.new(
            container,
            ">",
            function()
            end,
            theme.deactivatedButton,
            width - 10,
            i + 1,
            3,
            1
        )
        table.insert(programSelectionElements, listView.selectionGroup.addNewSelectionElement(startupButton))
        local delButton =
            ui.button.new(
            container,
            "del",
            function()
            end,
            theme.exitButton,
            width - 6,
            i + 1,
            5,
            1
        )

        table.insert(programSelectionElements, listView.selectionGroup.addNewSelectionElement(delButton))
    end
    for i = 1, #programSelectionElements, 3 do
        programSelectionElements[i].up = programSelectionElements[i - 3]
        programSelectionElements[i + 1].up = programSelectionElements[i - 3 + 1]
        programSelectionElements[i + 2].up = programSelectionElements[i - 3 + 2]

        programSelectionElements[i].down = programSelectionElements[i + 3]
        programSelectionElements[i + 1].down = programSelectionElements[i + 3 + 1]
        programSelectionElements[i + 2].down = programSelectionElements[i + 3 + 2]

        programSelectionElements[i + 1].left = programSelectionElements[i]
        programSelectionElements[i + 2].left = programSelectionElements[i + 1]

        programSelectionElements[i].right = programSelectionElements[i + 1]
        programSelectionElements[i + 1].right = programSelectionElements[i + 2]
    end
    listView.resetLayout()
end
updateListView()

menuSelectionGroup.next = listView.selectionGroup
menuSelectionGroup.previous = listView.selectionGroup
listView.selectionGroup.next = menuSelectionGroup
listView.selectionGroup.previous = menuSelectionGroup
manager.selectionManager.addSelectionGroup(listView.selectionGroup)
manager.selectionManager.setCurrentSelectionGroup(listView.selectionGroup)

manager.draw()
manager.execute()
