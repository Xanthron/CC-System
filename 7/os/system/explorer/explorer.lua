local args = ...
local set = dofile("os/system/explorer/default.lua")
if type(args) == "table" then
    for key, value in pairs(args) do
        set[key] = value
    end
else
    error("An argument table is missing as argument")
end

local function checkType(name, kind)
    local value = set[name]
    local valueType = type(value)
    if value or value == false then
        if valueType ~= kind then
            error(string.format("'%s' is set but has the wrong type. (expected '%s' got '%s')", name, kind, valueType), 3)
        end
    else
        error(string.format("'%s' is not set. (expected '%s' got 'nil')", name, kind), 3)
    end
end

checkType("showIcons", "boolean")
checkType("showHidden", "boolean")
checkType("showExtensions", "boolean")
checkType("neatNames", "boolean")
checkType("pathSaveSize", "number")
checkType("showType", "string")

set.showFiles = set.showFiles or true
checkType("showFiles", "boolean")
set.showFolders = set.showFolders or true
checkType("showFolders", "boolean")
set.selectMode = set.selectMode or "browse" -- handle fallback! modes: select_one,select_many
checkType("selectMode", "string")
set.path = set.path or ""
checkType("path", "string")
if not fs.exists(set.path) then
    error("Invalid path. (path: '/" .. set.path .. "' does not exist)")
elseif not fs.isDir(set.path) then
    error("Path is not a folder. (path: '/" .. set.path .. "')")
end
if set.pathSaveSize < 1 then
    error(string.format("pathSaveSize' is set but the value is to low. (expected value > 0 got %s)", set.pathSaveSize), 3)
end
checkType("select", "boolean")

local exPath = dofile("os/system/explorer/excludedPaths.lua")
--TODO load files, so external Programs can execute one fileTypes
local ext = dofile("os/system/explorer/extensions.lua")

local _x, _y, _w, _h
if set.manager then
    _x, _y, _w, _h = set.manager.getGlobalRect()
else
    _x, _y, _w, _h = 1, 1, term.getSize()
end

local isSelected
local addSelection
local removeSelection
local updateSelectionLabel
if set.selectMode == "save" then
    set.saveName = set.saveName or ""
    checkType("saveName", "string")
elseif set.selectMode == "select_many" then
    set.selections = set.selections or {}
    checkType("selections", "table")
    isSelected = function(name)
        for _, s in ipairs(set.selections) do
            if s == name then
                return true
            end
        end
        return false
    end
    addSelection = function(name)
        table.insert(set.selections, name)
    end
    removeSelection = function(name)
        for i, s in ipairs(set.selections) do
            if s == name then
                table.remove(set.selections, i)
                return
            end
        end
    end
    updateSelectionLabel = function(manager)
        local element = manager._elements[8]
        element.text = tostring(#set.selections)
        element.recalculate()
        element.repaint("this")
    end
end

local pathsIndex, paths = 1, {set.path}

local ret = {}

--- Functions
local function getCurrentPath()
    return paths[pathsIndex]
end

local function addPath(path)
    for _ = pathsIndex + 1, #paths do
        table.remove(paths, pathsIndex + 1)
    end
    while #paths >= set.pathSaveSize do
        table.remove(paths, 1)
    end
    table.insert(paths, path)
    pathsIndex = math.min(pathsIndex + 1, set.pathSaveSize)
end

---@param manager uiManager
local function updateButton(manager)
    ---@type button
    local upButton, backButton, forwardButton, inputField = table.unpack(manager._elements, 3, 6)
    if pathsIndex == 1 then
        if backButton.mode ~= 2 then
            backButton.mode = 2
            if not backButton._inAnimation then
                backButton.recalculate()
                backButton.repaint("this")
            end
        end
    else
        if backButton.mode == 2 then
            backButton.mode = 1
            if not backButton._inAnimation then
                backButton.recalculate()
                backButton.repaint("this")
            end
        end
    end
    if pathsIndex >= #paths then
        if forwardButton.mode ~= 2 then
            forwardButton.mode = 2
            if not forwardButton._inAnimation then
                forwardButton.recalculate()
                forwardButton.repaint("this")
            end
        end
    else
        if forwardButton.mode == 2 then
            forwardButton.mode = 1
            if not forwardButton._inAnimation then
                forwardButton.recalculate()
                forwardButton.repaint("this")
            end
        end
    end
    if fs.getDir(getCurrentPath()) == ".." then
        if upButton.mode ~= 2 then
            upButton.mode = 2
            if not upButton._inAnimation then
                upButton.recalculate()
                upButton.repaint("this")
            end
        end
    else
        if upButton.mode == 2 then
            upButton.mode = 1
            if not upButton._inAnimation then
                upButton.recalculate()
                upButton.repaint("this")
            end
        end
    end
    local path = getCurrentPath()
    if path == "" then
        path = "root"
    else
        path = path .. "/"
    end
    inputField.setText(path)
    -- ---@type inputField
    -- inputField.cursorOffset = path:len()
    inputField.recalculate("this")
end

local function clearListView(listView)
    ---@type element
    local container = listView.getContainer()
    for i = 1, #container._elements do
        container._elements[1].setParent(nil)
    end
    for i = 1, #listView.selectionGroup.selectionElements do
        listView.selectionGroup.selectionElements[i] = nil
    end
end

local function getNameAndIconKeyExtension(name)
    local startI, endI = name:find("%.[^%.]*$")
    local extension = nil
    if endI then
        extension = name:sub(startI + 1, endI)
        --if settings.showExtension == false then
        name = name:sub(1, startI - 1)
    --end
    end
    if set.neatNames == true then
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

local function getPathElements(folder)
    local list = fs.list(folder)
    local dirs = {}
    local files = {}

    for _, path in pairs(list) do
        local fullPath
        if folder ~= "" then
            fullPath = folder .. "/" .. path
        else
            fullPath = path
        end

        if fs.isDir(fullPath) then
            if set.showFolders == true and (set.showHidden == true or path:sub(1, 1) ~= ".") then
                local name, ext = getNameAndIconKeyExtension(path)
                local name = "/" .. name
                table.insert(dirs, fullPath)
                table.insert(dirs, name)
            end
        else
            if set.showFiles == true and (set.showHidden == true or path:sub(1, 1) ~= ".") then
                local name, ext = getNameAndIconKeyExtension(path)
                if set.showExtensions and ext then
                    name = name .. "." .. ext
                end
                if set.showType == "" or set.showType == ext then
                    table.insert(files, fullPath)
                    table.insert(files, name)
                    table.insert(files, ext or "file")
                end
            end
        end
    end

    return dirs, files
end

local function extensionIcon(parent, ext, x, y)
    local element = ui.element.new(parent, x, y, 3, 1)
    local buffer = element.buffer
    for i = 1, 3 do
        buffer.text[i] = ext[1][i]
        buffer.textColor[i] = ext[2][i]
        buffer.textBackgroundColor[i] = ext[3][i]
    end
    return element
end

---@param manager uiManager
---@param listView scrollView
---@param path string
local function updateListView(manager, listView)
    clearListView(listView)
    local dirs, files = getPathElements(getCurrentPath())

    local x, w, y = listView.getGlobalPosX() + #listView.style.normalTheme.border[4], listView.getWidth() - #listView.style.normalTheme.border[4] - #listView.style.normalTheme.border[6] - 1, 3
    if set.showIcons then
        x = x + 4
        w = w - 4
    end

    ---@type selectionElement[]
    local selectionElements = {}
    local container = listView.getContainer()
    for i = 1, #dirs, 2 do
        if set.showIcons then
            local ext = ext["folder"]
            extensionIcon(container, ext, x - 4, y)
        end

        ---@type button
        local button = ui.button.new(container, dirs[i + 1], nil, theme.listButton, x, y, w, 1)
        button._onClick = function(event)
            if (event.name == "mouse_up" and event.param1 == 2) or (event.name == "key_up" and event.param1 == 100) then --TODO right key
                manager.callFunction(
                    function()
                        local options = {"Open"}

                        local select = true
                        if event.name == "mouse_up" then
                            select = false
                        end

                        if set.selectMode == "select_many" then
                            table.insert(options, "-")
                            table.insert(options, "Select All")
                            table.insert(options, "Remove All")
                        end

                        if set.selectMode == "save" then
                            table.insert(options, "Select")
                        end

                        local y = button.getGlobalPosY() + 1
                        if y + #options + 3 > _h + _y then
                            y = y - 3 - #options
                        end

                        local name =
                            assert(loadfile("os/system/listBox.lua"))(
                            {
                                x = button.getGlobalPosX(),
                                y = y,
                                manager = manager,
                                label = "File",
                                select = select,
                                buttons = options
                            }
                        )
                        if name then
                            if name == "Open" then
                            elseif name == "Rename" then
                            elseif name == "Select All" then
                                for _, p in ipairs(assets.extension.getAllFilePaths(dirs[i])) do
                                    if isSelected(p) == false then
                                        addSelection(p)
                                    end
                                end
                            elseif name == "Remove All" then
                                for _, p in ipairs(assets.extension.getAllFilePaths(dirs[i])) do
                                    removeSelection(p)
                                end
                            end
                            updateSelectionLabel(manager)
                        end

                        manager.draw()
                    end
                )
            else
                manager.parallelManager.removeFunction(button._pressAnimation)
                addPath(dirs[i])
                updateListView(manager, listView)

                updateButton(manager)
                if event.name ~= "mouse_up" then
                    manager.selectionManager.select(listView.selectionGroup.selectionElements[1].element)
                end
                manager.draw()
            end
        end
        table.insert(selectionElements, listView.selectionGroup.addNewSelectionElement(button))
        y = y + 1
    end
    for i = 1, #files, 3 do
        local ext = ext[files[i + 2]] or ext["file"] --TODO is the or necessary?
        if set.showIcons then
            extensionIcon(container, ext, x - 4, y)
        end

        local buttonTheme = theme.listButton
        if set.selectMode == "select_many" and isSelected(files[i]) then
            buttonTheme = theme.selectedListButton
        end

        ---@type button
        local button = ui.button.new(container, files[i + 1], nil, buttonTheme, x, y, w, 1)
        if set.selectMode == "select_many" then
            button._onClick = function(event)
                if isSelected(files[i]) then
                    button.style = theme.listButton
                    removeSelection(files[i])
                else
                    button.style = theme.selectedListButton
                    addSelection(files[i])
                end
                updateSelectionLabel(manager)
                if not button._inAnimation then
                    button.recalculate()
                    button.repaint("this")
                end
            end
        else
            button._onClick = function(event)
                --manager.parallelManager.removeFunction(button._pressAnimation)
                --TODO Change by exploring type
                manager.callFunction(
                    function()
                        --If an Error occurs here you may be looking in "os/system/explorer/extensions" for wrong file calling or
                        assert(loadfile("os/system/execute.lua"))(ext[4] or "rom/programs/edit.lua", files[i]) --TODO Add argument support!!!
                        manager.draw()
                    end
                )
            end
        end
        table.insert(selectionElements, listView.selectionGroup.addNewSelectionElement(button))
        y = y + 1
    end
    for i = 1, #selectionElements do
        selectionElements[i].up = selectionElements[i - 1]
        selectionElements[i].down = selectionElements[i + 1]
    end
    --selectionElements[1].up = manager.selectionManager.selectionGroups[1]

    listView.selectionGroup.currentSelectionElement = selectionElements[1]
    listView.recalculate()
    listView.resetLayout()
end

-- Layout
---@type uiManager
local manager = ui.uiManager.new(1, 1, _w, _h)
local index
for i = 1, _w * _h do
    if i <= _w then
        manager.buffer.text[i] = " "
        manager.buffer.textColor[i] = colors.green
        manager.buffer.textBackgroundColor[i] = colors.green
    elseif i <= 2 * _w then
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
local exitButton = ui.button.new(manager, "<", nil, theme.exitButton, _w - 2, 1, 3, 1)
local upButton = ui.button.new(manager, "^", nil, theme.menuButton, 8, 1, 3, 1)
local backButton = ui.button.new(manager, "<", nil, theme.menuButton, 11, 1, 3, 1)
local forwardButton = ui.button.new(manager, ">", nil, theme.menuButton, 14, 1, 3, 1)
---@type inputField
local pathField = ui.inputField.new(manager, "", getCurrentPath(), false, nil, theme.pathField, 1, 2, _w, 1)
---@type scrollView
local listView = ui.scrollView.new(manager, nil, 3, theme.listView, 1, 3, _w, _h - 2)

local backgroundListView = listView._elements[1]
local backgroundListViewBuffer = backgroundListView.buffer
for i = 1, _h - 1 do
    if set.showIcons == true then
        index = (i - 1) * (_w - 1) + 4
        backgroundListViewBuffer.text[index] = "|"
        backgroundListViewBuffer.textColor[index] = colors.black
        backgroundListViewBuffer.textBackgroundColor[index] = colors.white
    end
    index = (i - 1) * (_w - 1) + _w - 1
    backgroundListViewBuffer.text[index] = "|"
    backgroundListViewBuffer.textColor[index] = colors.black
    backgroundListViewBuffer.textBackgroundColor[index] = colors.white
end
pathField.onSuggestCompletion = function(text, offset)
    if text:len() == offset then
        local startI, endI = text:match("%/.*$")
        if startI == nil or endI == nil then
            return fs.complete(text, "", false, false)
        else
            print(startI, endI)
            return fs.complete(text:sub(endI), text:sub(1, startI), false, true)
        end
    else
        return {}
    end
end
pathField.onAutoCompletion = function(text, offset, completion)
    if offset == text:len() then
        return true, text .. completion, text:len() + completion:len()
    else
        return false
    end
end
pathField._onSubmit = function(event, text)
    if text == "root" then
        text = ""
    end
    local currentPath = getCurrentPath()
    if currentPath == ".." then
        currentPath = ""
    end
    if fs.isDir(text) and text ~= currentPath then
        if text:sub(text:len()) == "/" then
            text = text:sub(1, text:len() - 1)
        end
        addPath(text)
        updateButton(manager)
        updateListView(manager, listView)
    else
        updateButton(manager)
        updateListView(manager, listView)
    end
    manager.draw()
end
fileButton._onClick = function(event)
    local select = true
    if event.name == "mouse_up" then
        select = false
        fileButton.mode = 3
        fileButton.recalculate()
    end
    manager.callFunction(
        function()
            local options = {"New Folder", "New File"}
            local option =
                assert(loadfile("os/system/listBox.lua"))(
                {
                    x = 1,
                    y = 1,
                    manager = manager,
                    label = "File",
                    select = select,
                    buttons = options
                }
            )
            if #option > 0 then
                error(options[option[1]] .. " not implemented yet")
            end
            manager.draw()
        end
    )
end
upButton._onClick = function()
    addPath(fs.getDir(getCurrentPath()))
    updateButton(manager)
    updateListView(manager, listView)
    manager.draw()
end
backButton._onClick = function()
    pathsIndex = pathsIndex - 1
    updateButton(manager)
    updateListView(manager, listView)
    manager.draw()
end
forwardButton._onClick = function()
    pathsIndex = pathsIndex + 1
    updateButton(manager)
    updateListView(manager, listView)
    manager.draw()
end
exitButton._onClick = function()
    term.setCursorPos(1, 1)
    if term.isColor() then
        term.setBackgroundColor(colors.black)
        term.setTextColor(colors.white)
    end
    term.clear()
    manager.exit()
end

manager.selectionManager.addSelectionGroup(listView.selectionGroup)

local menuGroup = manager.selectionManager.addNewSelectionGroup()
local fileButton_selection = menuGroup.addNewSelectionElement(fileButton)
local upButton_selection = menuGroup.addNewSelectionElement(upButton)
local backButton_selection = menuGroup.addNewSelectionElement(backButton)
local forwardButton_selection = menuGroup.addNewSelectionElement(forwardButton)
local exitButton_selection = menuGroup.addNewSelectionElement(exitButton)
local pathField_selection = menuGroup.addNewSelectionElement(pathField)
fileButton_selection.right = upButton_selection
upButton_selection.right = backButton_selection
backButton_selection.right = forwardButton_selection
forwardButton_selection.right = exitButton_selection
exitButton_selection.left = forwardButton_selection
forwardButton_selection.left = backButton_selection
backButton_selection.left = upButton_selection
upButton_selection.left = fileButton_selection
menuGroup.currentSelectionElement = fileButton_selection
fileButton_selection.down = pathField_selection
upButton_selection.down = pathField_selection
backButton_selection.down = pathField_selection
forwardButton_selection.down = pathField_selection
exitButton_selection.down = pathField_selection
pathField_selection.up = fileButton_selection
--pathField_selection.down = listView.selectionGroup

menuGroup.next = listView.selectionGroup
menuGroup.previous = listView.selectionGroup
listView.selectionGroup.next = menuGroup
listView.selectionGroup.previous = menuGroup

if set.selectMode == "save" then
    listView.setGlobalRect(nil, nil, nil, listView.getHeight() - 1)
    listView.resetLayout()

    ---@type label
    local saveField = ui.inputField.new(manager, set.saveName, set.saveName, false, nil, theme.inputField, 1, _h, _w - 6, 1)
    saveField._onSubmit = function(event, text)
        --TODO File Already exist function!!!
        if saveField ~= "" then
            table.insert(ret, getCurrentPath() .. "/" .. text)
        end
        saveField.mode = 1
        manager.exit()
    end
    local saveButton = ui.button.new(manager, "Save", nil, theme.menuButton, _w - 5, _h, 6, 1)
    saveButton._onClick = function(event)
        saveField._onSubmit(event, saveField.text)
    end

    local saveMenuGroup = manager.selectionManager.addNewSelectionGroup()
    local saveField_selection = saveMenuGroup.addNewSelectionElement(saveField)
    local saveButton_selection = saveMenuGroup.addNewSelectionElement(saveButton)

    saveField_selection.right = saveButton_selection
    saveButton_selection.left = saveField_selection

    saveMenuGroup.currentSelectionElement = saveField_selection

    saveMenuGroup.previous = listView.selectionGroup
    saveMenuGroup.next = menuGroup
    menuGroup.previous = saveMenuGroup
    listView.selectionGroup.next = saveMenuGroup
elseif set.selectMode == "select_many" then
    listView.setGlobalRect(nil, nil, nil, listView.getHeight() - 1)
    listView.resetLayout()

    ---@type label
    local selectedLabel = ui.label.new(manager, tostring(#set.selections), theme.selectedLabel, 1, _h, _w - 15, 1)
    local clearSelectionButton = ui.button.new(manager, "Clear", nil, theme.menuButton, _w - 14, _h, 7, 1)
    clearSelectionButton._onClick = function(event)
        while #set.selections > 0 do
            table.remove(set.selections)
        end
        updateSelectionLabel(manager)
        updateListView(manager, listView)
        manager.draw()
    end
    local selectSelectionButton = ui.button.new(manager, "Select", nil, theme.menuButton, _w - 7, _h, 8, 1)
    selectSelectionButton._onClick = function()
        table.insert(ret, set.selections)
        manager.exit()
    end

    local selectionMenuGroup = manager.selectionManager.addNewSelectionGroup()
    local clearSelectionButton_selection = selectionMenuGroup.addNewSelectionElement(clearSelectionButton)
    local selectSelectionButton_selection = selectionMenuGroup.addNewSelectionElement(selectSelectionButton)

    clearSelectionButton_selection.right = selectSelectionButton_selection
    selectSelectionButton_selection.left = clearSelectionButton_selection

    selectionMenuGroup.currentSelectionElement = selectSelectionButton_selection

    selectionMenuGroup.previous = listView.selectionGroup
    selectionMenuGroup.next = menuGroup
    menuGroup.previous = selectionMenuGroup
    listView.selectionGroup.next = selectionMenuGroup
end

updateButton(manager)
updateListView(manager, listView)

if term.isColor() then
    manager.selectionManager._currentSelectionGroup = listView.selectionGroup
else
    manager.selectionManager.setCurrentSelectionGroup(listView.selectionGroup)
end
manager.draw()
manager.execute()

return table.unpack(ret)
--error("End not implemented")
