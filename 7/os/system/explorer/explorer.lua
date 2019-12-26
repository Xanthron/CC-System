local args = {...}
local startPath = args[1]

local settings = {
    excludedPaths = dofile("os/system/explorer/excludedPaths.lua"),
    showIcons = true,
    showHiddenFiles = false,
    showFiles = true,
    showExtension = true,
    selectMode = false,
    neatNames = true,
    pathSaveSize = 20
}
if args[2] then
    for key, value in pairs(args[2]) do
        settings[key] = value
    end
end

local extensions = dofile("os/system/explorer/extensions.lua")
local width, height = term.getSize()
local updateListView, updatePath, updateButton
local pathSaveIndex = 1
local pathSaves = {startPath or ""}

local function getCurrentDir()
    return pathSaves[pathSaveIndex] or ""
end

local function getName(name)
    local startI, endI = name:find("%.[^%.]*$")
    local extension = nil
    if endI then
        extension = name:sub(startI + 1, endI)
        --if settings.showExtension == false then
        name = name:sub(1, startI - 1)
    --end
    end
    if settings.neatNames == true then
        name =
            name:gsub(
            "[._]+.",
            function(text)
                return text:sub(text:len()):upper()
            end
        )
        name =
            (name:sub(1, 1):upper() .. name:sub(2)):gsub(
            "%l%u",
            function(text)
                return text:sub(1, 1) .. " " .. text:sub(2, 2)
            end
        )
    end
    return name, extension
end

local function getList(path, dir, file)
    local paths = fs.list(path)
    local index = 1
    for i = 1, #paths do
        local name = paths[i]
        local newPath = path .. "/" .. name
        local excluded = false
        for j, exclude in ipairs(settings.excludedPaths) do
            if exclude == newPath then
                excluded = true
                break
            end
        end
        if excluded == false then
            if fs.isDir(newPath) then
                local newName, extension = getName(name)
                table.insert(dir, newPath)
                table.insert(dir, "/" .. newName)
            else
                if settings.showFiles then
                    if settings.showHiddenFiles == true or name:sub(1, 1) ~= "." then
                        local newName, extension = getName(name)
                        table.insert(file, newPath)
                        table.insert(file, newName)
                        table.insert(file, extension or "")
                    end
                end
            end
        end
    end
end

---@type uiManager
local manager = ui.uiManager.new(1, 1, width, height)
local index
for i = 1, width * height do
    if i <= width then
        manager.buffer.text[i] = " "
        manager.buffer.textColor[i] = colors.green
        manager.buffer.textBackgroundColor[i] = colors.green
    elseif i <= 2 * width then
        manager.buffer.text[i] = " "
        manager.buffer.textColor[i] = colors.lime
        manager.buffer.textBackgroundColor[i] = colors.lime
    else
        manager.buffer.text[i] = " "
        manager.buffer.textColor[i] = colors.white
        manager.buffer.textBackgroundColor[i] = colors.white
    end
end

local fileButton = ui.button.new(manager, "File", nil, theme.menuButton, 1, 1, 6, 1)
fileButton._onClick = function()
    manager.callFunction(
        function()
            assert(loadfile("os/system/listBox.lua"))(
                {
                    x = 1,
                    y = 1,
                    manager = manager,
                    label = "File",
                    func = function()
                    end,
                    buttons = {"test", {name = "and more", "Was", {name = "auch", "und", "noch", {name = "mehr", "Jetzt", {name = "aber", "ok", "jetzt", "muss", "ich", "aber", "noch", "mehr", "schreiben", "langer Text"}}}, "immer"}, "Test"}
                }
            )
            print("jo")
            sleep(1)
            manager.draw()
        end
    )
end
local upButton = ui.button.new(manager, "^", nil, theme.menuButton, 8, 1, 3, 1)

---@type button
local backButton = ui.button.new(manager, "<", nil, theme.menuButton, 11, 1, 3, 1)

local forwardButton = ui.button.new(manager, ">", nil, theme.menuButton, 14, 1, 3, 1)

local exitButton = ui.button.new(manager, "<", nil, theme.exitButton, width - 2, 1, 3, 1)
exitButton._onClick = function()
    term.setCursorPos(1, 1)
    if term.isColor() then
        term.setBackgroundColor(colors.black)
        term.setTextColor(colors.white)
    end
    term.clear()
    manager.exit()
end

local updateButton = function()
    if pathSaveIndex == 1 then
        if backButton.mode ~= 2 then
            backButton.mode = 2
            if not backButton._inAnimation then
                backButton.repaint("this")
                backButton.recalculate("this")
            end
        end
    else
        if backButton.mode == 2 then
            backButton.mode = 1
            if not backButton._inAnimation then
                backButton.repaint("this")
                backButton.recalculate("this")
            end
        end
    end
    if pathSaveIndex >= #pathSaves then
        if forwardButton.mode ~= 2 then
            forwardButton.mode = 2
            if not forwardButton._inAnimation then
                forwardButton.repaint("this")
                forwardButton.recalculate("this")
            end
        end
    else
        if forwardButton.mode == 2 then
            forwardButton.mode = 1
            if not forwardButton._inAnimation then
                forwardButton.repaint("this")
                forwardButton.recalculate("this")
            end
        end
    end
    if fs.getDir(getCurrentDir()) == ".." then
        if upButton.mode ~= 2 then
            upButton.mode = 2
            if not upButton._inAnimation then
                upButton.repaint("this")
                upButton.recalculate("this")
            end
        end
    else
        if upButton.mode == 2 then
            upButton.mode = 1
            if not upButton._inAnimation then
                upButton.repaint("this")
                upButton.recalculate("this")
            end
        end
    end
end
updateButton()
upButton._onClick = function()
    local path = fs.getDir(getCurrentDir())
    for _ = pathSaveIndex + 1, #pathSaves do
        table.remove(pathSaves, pathSaveIndex + 1)
    end
    while #pathSaves >= settings.pathSaveSize do
        table.remove(pathSaves, 1)
    end
    table.insert(pathSaves, path)
    pathSaveIndex = math.min(pathSaveIndex + 1, settings.pathSaveSize)

    updateButton()
    updatePath()
    manager.draw()
end
backButton._onClick = function()
    pathSaveIndex = pathSaveIndex - 1
    updateButton()
    updatePath()
    manager.draw()
end
forwardButton._onClick = function()
    pathSaveIndex = pathSaveIndex + 1
    updateButton()
    updatePath()
    manager.draw()
end

local menuSelectionGroup = manager.selectionManager.addNewSelectionGroup()
local fileButton_selection = menuSelectionGroup.addNewSelectionElement(fileButton)
local upButton_selection = menuSelectionGroup.addNewSelectionElement(upButton)
local backButton_selection = menuSelectionGroup.addNewSelectionElement(backButton)
local forwardButton_selection = menuSelectionGroup.addNewSelectionElement(forwardButton)
local exitButton_selection = menuSelectionGroup.addNewSelectionElement(exitButton)
fileButton_selection.right = upButton_selection
upButton_selection.right = backButton_selection
backButton_selection.right = forwardButton_selection
forwardButton_selection.right = exitButton_selection
exitButton_selection.left = forwardButton_selection
forwardButton_selection.left = backButton_selection
backButton_selection.left = upButton_selection
upButton_selection.left = fileButton_selection
menuSelectionGroup.currentSelectionElement = fileButton_selection

---@type label
local pathLabel = ui.label.new(manager, "Path: ", theme.pathLabel, 1, 2, width, 1)

---@type scrollView
local listView = ui.scrollView.new(manager, nil, 3, theme.listView, 1, 3, width, height - 2)
local backgroundListView = listView._elements[1]
local backgroundListViewBuffer = backgroundListView.buffer
for i = 1, height - 1 do
    if settings.showIcons == true then
        index = (i - 1) * (width - 1) + 4
        backgroundListViewBuffer.text[index] = "|"
        backgroundListViewBuffer.textColor[index] = colors.black
        backgroundListViewBuffer.textBackgroundColor[index] = colors.white
    end
    index = (i - 1) * (width - 1) + width - 1
    backgroundListViewBuffer.text[index] = "|"
    backgroundListViewBuffer.textColor[index] = colors.black
    backgroundListViewBuffer.textBackgroundColor[index] = colors.white
end

menuSelectionGroup.next = listView.selectionGroup
menuSelectionGroup.previous = listView.selectionGroup
listView.selectionGroup.next = menuSelectionGroup
listView.selectionGroup.previous = menuSelectionGroup
manager.selectionManager.addSelectionGroup(listView.selectionGroup)

updateListView = function(path)
    local dir = {}
    local file = {}

    getList(path, dir, file)

    local container = listView.getContainer()
    for i = 1, #container._elements do
        table.remove(container._elements, 1)
    end
    for i = 1, #listView.selectionGroup.selectionElements do
        listView.selectionGroup.selectionElements[i] = nil
    end

    index = 1
    ---@type selectionElement[]
    local selectionElements = {}
    for i = 1, #dir, 2 do
        local path = dir[i]
        local name = dir[i + 1]

        local newX = 1
        local newW = width - 14
        if settings.showIcons == true then
            local ext = extensions["folder"]
            local image = ui.element.new(container, 1, index + 2, 3, 1)
            image.buffer.text = ext[1]
            image.buffer.textColor = ext[2]
            image.buffer.textBackgroundColor = ext[3]
            newX = 5
            newW = width - 10
        end
        local button = ui.button.new(container, name, nil, theme.listButton, newX, index + 2, newW, 1)
        button._onClick = function(event)
            manager.parallelManager.removeFunction(button._pressAnimation)

            for _ = pathSaveIndex + 1, #pathSaves do
                table.remove(pathSaves, pathSaveIndex + 1)
            end
            while #pathSaves >= settings.pathSaveSize do
                table.remove(pathSaves, 1)
            end
            table.insert(pathSaves, path)
            pathSaveIndex = math.min(pathSaveIndex + 1, settings.pathSaveSize)

            updateButton()
            updatePath()
            if event.name ~= "mouse_up" then
                manager.selectionManager.select(listView.selectionGroup.selectionElements[1].element)
            end
            manager.draw()
        end
        table.insert(selectionElements, listView.selectionGroup.addNewSelectionElement(button))
        index = index + 1
    end
    for i = 1, #file, 3 do
        local path = file[i]
        local name = file[i + 1]
        if settings.showExtension and file[i + 2] ~= "" then
            name = name .. "." .. file[i + 2]
        end

        local ext = extensions[file[i + 2]] or extensions["file"]
        local program = ext[4]
        local args = ext[5]
        local newX = 1
        local newW = width - 14
        if settings.showIcons == true then
            local image = ui.element.new(container, 1, index + 2, 3, 1)
            image.buffer.text = ext[1]
            image.buffer.textColor = ext[2]
            image.buffer.textBackgroundColor = ext[3]
            newX = 5
            newW = width - 10
        end
        local buttonFunc = function()
            manager.callFunction(
                function()
                    shell.run("os/system/execute.lua", program, path)

                    manager.draw()
                end
            )
        end
        local button = ui.button.new(container, name, buttonFunc, theme.listButton, newX, index + 2, newW, 1)
        table.insert(selectionElements, listView.selectionGroup.addNewSelectionElement(button))
        index = index + 1
    end
    for i = 1, #selectionElements do
        selectionElements[i].up = selectionElements[i - 1]
        selectionElements[i].down = selectionElements[i + 1]
    end
    listView.selectionGroup.currentSelectionElement = listView.selectionGroup.selectionElements[1]
    listView.recalculate()
    listView.resetLayout()
end

updatePath = function()
    local path = getCurrentDir()
    updateListView(path)
    if path == "" then
        pathLabel.text = "root"
    else
        pathLabel.text = path
    end
    pathLabel.recalculate()
end

updatePath()
if term.isColor() then
    manager.selectionManager._currentSelectionGroup = listView.selectionGroup
else
    manager.selectionManager.setCurrentSelectionGroup(listView.selectionGroup)
end
manager.draw()
manager.execute()
