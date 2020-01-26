local width, height = term.getSize()

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
local browserButton =
    ui.button.new(
    manager,
    "Browser",
    function(self, event)
        manager:callFunction(
            function()
                local select = true
                if event.name == "mouse_up" then
                    select = false
                end
                local success, select =
                    assert(loadfile("os/sys/execute.lua"))(
                    {file = "os/sys/browser/manager.lua", select = event ~= "mouse_up", args = {{select = select}}}
                )
                if select then
                    manager.selectionManager:select(self, "code", 3)
                else
                    manager.selectionManager:deselect("code")
                end
                manager:draw()
            end
        )
    end,
    theme.button1,
    1,
    1,
    10,
    1
)
local explorerButton =
    ui.button.new(
    manager,
    "Explorer",
    function(self, event)
        manager:callFunction(
            function()
                local select = true
                if event.name == "mouse_up" then
                    select = false
                end
                local success, select =
                    assert(loadfile("os/sys/execute.lua"))(
                    {file = "os/sys/explorer/main.lua", select = event ~= "mouse_up", args = {{select = select}}}
                )
                if select then
                    manager.selectionManager:select(self, "code", 3)
                else
                    manager.selectionManager:deselect("code")
                end
                manager:draw()
            end
        )
    end,
    theme.button1,
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
    theme.button1,
    width - 5,
    1,
    3,
    1
)
local exitButton =
    ui.button.new(
    manager,
    "x",
    function(self, event)
        term.setCursorPos(1, 1)
        if term.isColor() then
            term.setBackgroundColor(colors.black)
            term.setTextColor(colors.white)
        end
        term.clear()
        manager:exit()
    end,
    theme.button2,
    width - 2,
    1,
    3,
    1
)
local menuSelectionGroup = manager.selectionManager:addNewGroup()
local listView = ui.scrollView.new(manager, nil, 3, theme.sView1, 1, 2, width, height - 1)

menuSelectionGroup:addElement(browserButton, nil, nil, explorerButton, listView.selectionGroup)
menuSelectionGroup:addElement(explorerButton, browserButton, nil, optionButton, listView.selectionGroup)
menuSelectionGroup:addElement(optionButton, explorerButton, nil, exitButton, listView.selectionGroup)
menuSelectionGroup:addElement(exitButton, optionButton, nil, nil, listView.selectionGroup)
menuSelectionGroup.current = browserButton

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
    local programs
    if fs.exists("os/programs/") then
        programs = fs.list("os/programs/")
    else
        programs = {}
    end
    local container = listView:getContainer()
    listView:clear()
    local elements = {}
    for i, v in ipairs(programs) do
        local startFunction
        local startupFunction
        local delFunction
        if fs.isDir("os/programs/" .. v) then
        else
            startFunction = function(self, event)
                manager:callFunction(
                    function()
                        local success, select =
                            assert(loadfile("os/sys/execute.lua"))(
                            {
                                file = "os/programs/" .. v,
                                select = event.name ~= "mouse_up",
                                args = {select = event.name ~= "mouse_up"}
                            }
                        )
                        --TODO selection:
                        -- if select then
                        --     manager.selectionManager.select(self, "code", 3)
                        -- else
                        --     manager.selectionManager.deselect("code")
                        -- end
                        manager:draw()
                    end
                )
            end
        end
        local buttonWidth = width - 12
        local name =
            (v:sub(1, 1):upper() .. v:sub(2)):gsub("%.[^%.]*$", ""):gsub(
            "%l%u",
            function(text)
                return text:sub(1, 1) .. " " .. text:sub(2, 2)
            end
        )
        if name:len() > width then
            name = name:sub(1, width - 3) .. "..."
        end
        local programButton = ui.button.new(container, name, startFunction, theme.button3, 1, i + 1, buttonWidth, 1)
        table.insert(elements, programButton)
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
        table.insert(elements, startupButton)
        local delButton =
            ui.button.new(
            container,
            "del",
            function()
            end,
            theme.button2,
            width - 6,
            i + 1,
            5,
            1
        )
        table.insert(elements, delButton)
    end
    for i = 1, #elements, 3 do
        listView.selectionGroup:addElement(elements[i], nil, elements[i - 3], elements[i + 1], elements[i + 3])
        listView.selectionGroup:addElement(
            elements[i + 1],
            elements[i],
            elements[i - 4],
            elements[i + 2],
            elements[i + 4]
        )
        listView.selectionGroup:addElement(elements[i + 2], elements[i + 1], elements[i - 5], nil, elements[i + 5])
    end
    listView.selectionGroup.current = listView:getContainer()._elements[1]
    listView:resetLayout()
end
updateListView()
menuSelectionGroup.next = listView.selectionGroup
menuSelectionGroup.previous = listView.selectionGroup
listView.selectionGroup.next = menuSelectionGroup
listView.selectionGroup.previous = menuSelectionGroup
manager.selectionManager:addGroup(listView.selectionGroup)
if #listView:getContainer()._elements > 0 then
    manager.selectionManager:select(listView.selectionGroup, "key", 3)
else
    manager.selectionManager:select(menuSelectionGroup)
end
manager:draw()
manager:execute()
