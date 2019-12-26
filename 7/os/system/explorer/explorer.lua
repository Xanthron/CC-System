local args = {...}
local startPath = args[1]

local settings = {
    excludedPaths = dofile("os/system/explorer/excludedPaths.lua"),
    showIcons = true,
    showHiddenFiles = false,
    showFiles = true,
    showExtension = false,
    selectMode = false,
    neatNames = false
}
if args[2] then
    for key, value in pairs(args[2]) do
        settings[key] = value
    end
end

local extensions = dofile("os/system/explorer/extensions.lua")

local width, height = term.getSize()

local updateListView, updatePath, getName, getList

getName = function(name)
    local startI, endI = name:find("%.[^%.]*$")
    local extension = nil
    if endI then
        extension = name:sub(startI + 1, endI)
        if settings.showExtension == false then
            name = name:sub(1, startI - 1)
        end
    end
    if settings.neatNames == true then
        name =
            (name:sub(1, 1):upper() .. name:sub(2)):gsub(
            "%l%u",
            function(text)
                return text:sub(1, 1):upper() .. " " .. text:sub(2, 2)
            end
        )
    end
    return name, extension
end

getList = function(path, dir, file)
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
            local newName, extension = getName(name)
            if fs.isDir(newPath) then
                table.insert(dir, newPath)
                table.insert(dir, newName)
                table.insert(dir, "folder")
            else
                if settings.showFiles then
                    if settings.showHiddenFiles == true or name:sub(1, 1) ~= "." then
                        table.insert(file, newPath)
                        table.insert(file, newName)
                        table.insert(file, extension or "file")
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

local fileButton =
    ui.button.new(
    manager,
    "File",
    function()
    end,
    theme.menuButton,
    1,
    1,
    6,
    1
)
local upButton =
    ui.button.new(
    manager,
    "^",
    function()
    end,
    theme.menuButton,
    8,
    1,
    3,
    1
)
local backButton =
    ui.button.new(
    manager,
    "<",
    function()
    end,
    theme.menuButton,
    11,
    1,
    3,
    1
)
local forwardButton = ui.button.new(manager, ">", nil, theme.menuButton, 14, 1, 3, 1)
forwardButton._onClick = function()
end
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
    index = (i - 1) * (width - 1) + 4
    backgroundListViewBuffer.text[index] = "|"
    backgroundListViewBuffer.textColor[index] = colors.black
    backgroundListViewBuffer.textBackgroundColor[index] = colors.white
    index = index + width - 5
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
    for i = 1, #dir, 3 do
        local path = dir[i]
        local name = dir[i + 1]
        local ext = extensions["folder"]
        local image = ui.element.new(container, 1, index + 2, 3, 1)
        image.buffer.text = ext[1]
        image.buffer.textColor = ext[2]
        image.buffer.textBackgroundColor = ext[3]
        local button = ui.button.new(container, name, nil, theme.listButton, 5, index + 2, width - 10, 1)
        button._onClick = function()
            manager.parallelManager.removeFunction(button._pressAnimation)
            updatePath(path)
            manager.selectionManager.focusGroup(listView.selectionGroup)
            manager.draw()
        end
        table.insert(selectionElements, listView.selectionGroup.addNewSelectionElement(button))
        index = index + 1
    end
    for i = 1, #file, 3 do
        local path = file[i]
        local name = file[i + 1]
        local ext = extensions[file[i + 2]]
        if ext then
            ---@type element
            local image = ui.element.new(container, 1, index + 2, 3, 1)
            image.buffer.text = ext[1]
            image.buffer.textColor = ext[2]
            image.buffer.textBackgroundColor = ext[3]
        end
        local buttonFunc = function()
        end
        local button = ui.button.new(container, name, buttonFunc, theme.listButton, 5, index + 2, width - 10, 1)
        table.insert(selectionElements, listView.selectionGroup.addNewSelectionElement(button))
        index = index + 1
    end
    for i = 1, #selectionElements do
        selectionElements[i].up = selectionElements[i - 1]
        selectionElements[i].down = selectionElements[i + 1]
    end
    listView.selectionGroup.currentSelectionElement = listView.selectionGroup.selectionElements[2]
    listView.recalculate()
    listView.resetLayout()
end

updatePath = function(path)
    updateListView(path)
    if path == "" then
        pathLabel.text = "root"
    else
        pathLabel.text = path
    end
    pathLabel.recalculate()
end

updatePath("")
manager.selectionManager.setCurrentSelectionGroup(listView.selectionGroup)
manager.draw()
manager.execute()
