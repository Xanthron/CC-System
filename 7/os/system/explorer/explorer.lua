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
            error(("'%s' is set but has the wrong type. (expected '%s' got '%s')"):format(name, kind, valueType), 3)
        end
    else
        error(("'%s' is not set. (expected '%s' got 'nil')"):format(name, kind), 3)
    end
end
checkType("icons", "boolean")
checkType("hidden", "boolean")
checkType("extensions", "boolean")
checkType("neatNames", "boolean")
checkType("pathsSize", "number")
checkType("type", "string")
checkType("edit", "boolean")
if set.files ~= false then
    set.files = true
end
checkType("files", "boolean")
set.folders = set.folders or true
checkType("folders", "boolean")
set.mode = set.mode or "browse"
checkType("mode", "string")
set.path = set.path or ""
checkType("path", "string")
if not fs.exists(set.path) then
    error("Invalid path. (path: '/" .. set.path .. "' does not exist)")
elseif not fs.isDir(set.path) then
    error("Path is not a folder. (path: '/" .. set.path .. "')")
end
if set.pathsSize < 1 then
    error(("pathsSize' is set but the value is to low. (expected value > 0 got %s)"):format(set.pathsSize), 3)
end
checkType("select", "boolean")
local ignorePaths = dofile("os/system/explorer/excludedPaths.lua")
local ext = {}
for _, v in ipairs(fs.list("os/system/explorer/extensions")) do
    ext[v] = dofile("os/system/explorer/extensions/" .. v)
end
local _x, _y, _w, _h
if set.manager then
    _x, _y, _w, _h = set.manager:getGlobalRect()
else
    _x, _y, _w, _h = 1, 1, term.getSize()
end
local isSelected
local addSelection
local removeSelection
local updateSelectionLabel
if set.mode == "save" then
    set.save = set.save or ""
    checkType("save", "string")
elseif set.mode == "move" then
    checkType("move", "string")
elseif set.mode == "select_many" then
    set.items = set.items or {}
    checkType("items", "table")
    isSelected = function(name)
        for _, s in ipairs(set.items) do
            if s == name then
                return true
            end
        end
        return false
    end
    addSelection = function(name)
        table.insert(set.items, name)
    end
    removeSelection = function(name)
        for i, s in ipairs(set.items) do
            if s == name then
                table.remove(set.items, i)
                return
            end
        end
    end
    updateSelectionLabel = function(manager)
        local element = manager._elements[8]
        element.text = tostring(#set.items)
        element:recalculate()
        element:repaint("this")
    end
end
local pathsIndex, paths = 1, {set.path}
local ret = {}
local rename, move, duplicate, delete, create
local function getCurrentPath()
    return paths[pathsIndex]
end
local function addPath(path)
    for _ = pathsIndex + 1, #paths do
        table.remove(paths, pathsIndex + 1)
    end
    while #paths >= set.pathsSize do
        table.remove(paths, 1)
    end
    table.insert(paths, path)
    pathsIndex = math.min(pathsIndex + 1, set.pathsSize)
end
local function updatePath()
    if not fs.isDir(getCurrentPath()) then
        paths[pathsIndex] = set.path
        if not fs.isDir(getCurrentPath()) then
            paths[pathsIndex] = ""
        end
    end
end
local function updateButton(manager)
    local upButton, backButton, forwardButton, inputField = table.unpack(manager._elements, 3, 6)
    if pathsIndex == 1 then
        if backButton.mode ~= 2 then
            backButton.mode = 2
            if not backButton._inAnimation then
                backButton:recalculate()
                backButton:repaint("this")
            end
        end
    else
        if backButton.mode == 2 then
            backButton.mode = 1
            if not backButton._inAnimation then
                backButton:recalculate()
                backButton:repaint("this")
            end
        end
    end
    if pathsIndex >= #paths then
        if forwardButton.mode ~= 2 then
            forwardButton.mode = 2
            if not forwardButton._inAnimation then
                forwardButton:recalculate()
                forwardButton:repaint("this")
            end
        end
    else
        if forwardButton.mode == 2 then
            forwardButton.mode = 1
            if not forwardButton._inAnimation then
                forwardButton:recalculate()
                forwardButton:repaint("this")
            end
        end
    end
    if fs.getDir(getCurrentPath()) == ".." then
        if upButton.mode ~= 2 then
            upButton.mode = 2
            if not upButton._inAnimation then
                upButton:recalculate()
                upButton:repaint("this")
            end
        end
    else
        if upButton.mode == 2 then
            upButton.mode = 1
            if not upButton._inAnimation then
                upButton:recalculate()
                upButton:repaint("this")
            end
        end
    end
    local path = getCurrentPath()
    if path == "" then
        path = "root"
    else
        path = path .. "/"
    end
    inputField:setText(path)
    inputField:recalculate("this")
end
local function clearListView(listView)
    local container = listView:getContainer()
    for i = 1, #container._elements do
        container._elements[1]:setParent(nil)
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
        name = name:sub(1, startI - 1)
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
            if set.folders == true and (set.hidden == true or path:sub(1, 1) ~= ".") then
                local name, ext = getNameAndIconKeyExtension(path)
                local name = "/" .. name
                table.insert(dirs, fullPath)
                table.insert(dirs, name)
            end
        else
            if set.files == true and (set.hidden == true or path:sub(1, 1) ~= ".") then
                local name, ext = getNameAndIconKeyExtension(path)
                if set.extensions and ext then
                    name = name .. "." .. ext
                end
                if set.type == "" or set.type == ext then
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
local function updateListView(manager, listView)
    clearListView(listView)
    local dirs, files = getPathElements(getCurrentPath())
    local x, w, y = listView:getGlobalPosX() + #listView.style.nTheme.b[4], listView:getWidth() - #listView.style.nTheme.b[4] - #listView.style.nTheme.b[6] - 1, 3
    if set.icons then
        x = x + 4
        w = w - 4
    end
    local selectionElements = {}
    local container = listView:getContainer()
    for i = 1, #dirs, 2 do
        if set.icons then
            local ext = ext["folder"]
            extensionIcon(container, ext, x - 4, y)
        end
        local button = ui.button.new(container, dirs[i + 1], nil, theme.button3, x, y, w, 1)
        button.path = dirs[i]
        button._onClick = function(self, event)
            if (event.name == "mouse_up" and event.param1 == 2) or (event.name == "key_up" and event.param1 == 29) then
                manager:callFunction(
                    function()
                        local options = {}
                        if set.edit then
                            table.insert(options, "Rename")
                            table.insert(options, "Move")
                            table.insert(options, "Duplicate")
                            table.insert(options, "-")
                            table.insert(options, "Delete")
                        end
                        local select = true
                        if event.name == "mouse_up" then
                            select = false
                        end
                        if set.mode == "select_many" then
                            if #options > 0 then
                                table.insert(options, "-")
                            end
                            table.insert(options, "Select All")
                            table.insert(options, "Remove All")
                        end
                        if set.mode == "save" then
                            if #options > 0 then
                                table.insert(options, "-")
                            end
                            table.insert(options, "Select")
                        end
                        if #options > 0 then
                            local y = self:getGlobalPosY() + 1
                            if y + #options + 3 > _h + _y then
                                y = y - 3 - #options
                            end
                            local name, indexes, select = assert(loadfile("os/system/listBox.lua"))({x = self:getGlobalPosX(), y = y, manager = manager, label = "File", select = select, buttons = options})
                            if name then
                                if name == "Rename" then
                                    manager.parallelManager:removeFunction(self._pressAnimation)
                                    rename(manager, listView, self, dirs[i])
                                elseif name == "Move" then
                                    if move(manager, listView, dirs[i], select) then
                                        manager:draw()
                                    end
                                elseif name == "Duplicate" then
                                elseif name == "Delete" then
                                    manager.parallelManager:removeFunction(self._pressAnimation)
                                    delete(manager, listView, dirs[i], select)
                                elseif name == "Select All" then
                                    for _, p in ipairs(assets.extension.getAllFilePaths(dirs[i])) do
                                        if isSelected(p) == false then
                                            addSelection(p)
                                        end
                                    end
                                    updateSelectionLabel(manager)
                                elseif name == "Remove All" then
                                    for _, p in ipairs(assets.extension.getAllFilePaths(dirs[i])) do
                                        removeSelection(p)
                                    end
                                    updateSelectionLabel(manager)
                                elseif name == "Select" then
                                    local element = manager._elements[8]
                                    element.setText(fs.getName(dirs[i]))
                                    if select then
                                        manager.selectionManager:select(manager._elements[8], "key")
                                    end
                                    element:recalculateText()
                                    element:repaint("this")
                                end
                            end
                            manager:draw()
                        end
                    end
                )
            else
                manager.parallelManager:removeFunction(self._pressAnimation)
                addPath(dirs[i])
                updateListView(manager, listView)
                updateButton(manager)
                if event.name ~= "mouse_up" then
                    if listView.selectionGroup.selectionElements[1] then
                        manager.selectionManager:select(listView.selectionGroup.selectionElements[1].element, "key")
                    else
                        manager.selectionManager:select(manager.selectionManager.selectionGroups[2].selectionElements[1], "key")
                    end
                end
                manager:draw()
            end
        end
        table.insert(selectionElements, listView.selectionGroup:addNewSelectionElement(button))
        y = y + 1
    end
    for i = 1, #files, 3 do
        local ext = ext[files[i + 2]] or ext["file"]
        if set.icons then
            extensionIcon(container, ext, x - 4, y)
        end
        local buttonTheme = theme.button3
        if set.mode == "select_many" and isSelected(files[i]) then
            buttonTheme = theme.button4
        end
        local button = ui.button.new(container, files[i + 1], nil, buttonTheme, x, y, w, 1)
        button.path = files[i]
        button._onClick = function(self, event)
            if (event.name == "mouse_up" and event.param1 == 2) or (event.name == "key_up" and event.param1 == 29) then
                manager:callFunction(
                    function()
                        local options = {}
                        if set.edit then
                            table.insert(options, "Rename")
                            table.insert(options, "Move")
                            table.insert(options, "Duplicate")
                            table.insert(options, "-")
                            table.insert(options, "Delete")
                        end
                        if #options > 0 then
                            local select = true
                            if event.name == "mouse_up" then
                                select = false
                            end
                            local y = self:getGlobalPosY() + 1
                            if y + #options + 3 > _h + _y then
                                y = y - 3 - #options
                            end
                            local name, indexes, select = assert(loadfile("os/system/listBox.lua"))({x = self:getGlobalPosX(), y = y, manager = manager, label = "File", select = select, buttons = options})
                            if name then
                                if name == "Rename" then
                                    manager.parallelManager:removeFunction(self._pressAnimation)
                                    rename(manager, listView, self, files[i])
                                elseif name == "Move" then
                                    if move(manager, listView, files[i], select) then
                                        manager:draw()
                                    end
                                elseif name == "Duplicate" then
                                elseif name == "Delete" then
                                    manager.parallelManager:removeFunction(self._pressAnimation)
                                    delete(manager, listView, files[i], select)
                                end
                            end
                            manager:draw()
                        end
                    end
                )
            else
                if set.mode == "select_many" then
                    if isSelected(files[i]) then
                        self.style = theme.button3
                        removeSelection(files[i])
                    else
                        self.style = theme.button4
                        addSelection(files[i])
                    end
                    updateSelectionLabel(manager)
                    if not self._inAnimation then
                        self:recalculate()
                        self:repaint("this")
                    end
                elseif set.mode == "save" then
                    local element = manager._elements[8]
                    element:setText(fs.getName(files[i]))
                    if event.name ~= "mouse" then
                        manager.selectionManager:select(manager._elements[8], "key")
                    end
                    element:recalculateText()
                    element:repaint("this")
                else
                    manager:callFunction(
                        function()
                            assert(loadfile("os/system/execute.lua"))(ext[4] or "rom/programs/edit.lua", files[i])
                            manager:draw()
                        end
                    )
                end
            end
        end
        table.insert(selectionElements, listView.selectionGroup:addNewSelectionElement(button))
        y = y + 1
    end
    for i = 1, #selectionElements do
        selectionElements[i].up = selectionElements[i - 1]
        selectionElements[i].down = selectionElements[i + 1]
    end
    listView.selectionGroup.currentSelectionElement = selectionElements[1]
    listView:recalculate()
    listView:resetLayout()
end
local function nameItem(manager, text, submit, x, y, w, h)
    local field = ui.inputField.new(manager, "", text, false, nil, theme.iField1, x, y, w, h)
    local selectionGroup = manager.selectionManager:addNewSelectionGroup(manager.selectionManager._currentSelectionGroup, manager.selectionManager._currentSelectionGroup)
    local field_selection = selectionGroup:addNewSelectionElement(field)
    selectionGroup.currentSelectionElement = field_selection
    function selectionGroup:listener(eventName, source, ...)
        if eventName == "selection_lose_focus" then
            local current, new = ...
            field.mode = 1
            field:setParent(nil)
            manager.selectionManager:removeSelectionGroup(selectionGroup)
            manager:repaint("this")
            return true
        end
    end
    field._onSubmit = submit
    manager.selectionManager:setCurrentSelectionGroup(selectionGroup, "code")
end
rename = function(manager, listView, element, path)
    local name = fs.getName(path)
    local path = path:sub(1, path:len() - name:len())
    local submit = function(self, event, text)
        local newPath = path .. text
        if text ~= "" and fs.exists(newPath) == false then
            fs.move(path .. name, newPath)
        end
        updateListView(manager, listView)
        for _, e in ipairs(listView:getContainer()._elements) do
            if e.path == newPath then
                manager.selectionManager:select(e, "code")
                return
            end
        end
        manager.selectionManager:setCurrentSelectionGroup(listView.selectionGroup, "code")
    end
    nameItem(manager, name, submit, element:getGlobalRect())
end
create = function(manager, listView, name, path, isDir)
    local submit = function(self, event, text)
        local newPath = fs.combine(path, text)
        if text ~= "" and fs.exists(newPath) == false then
            if isDir then
                fs.makeDir(newPath)
            else
                local file = io.open(newPath, "w+")
                file:close()
            end
        end
        updateListView(manager, listView)
        for _, e in ipairs(listView:getContainer()._elements) do
            if e.path == newPath then
                manager.selectionManager:select(e, "code")
                return
            end
        end
        manager.selectionManager:setCurrentSelectionGroup(listView.selectionGroup, "code")
    end
    nameItem(manager, name, submit, 1, 2, _w, 1)
end
delete = function(manager, listView, path, select)
    fs.delete(path)
    updateListView(manager, listView)
    if select then
        if listView.selectionGroup.selectionElements[1] then
            manager.selectionManager:select(listView.selectionGroup.selectionElements[1].element, "key")
        else
            manager.selectionManager:select(manager.selectionManager.selectionGroups[2].selectionElements[1], "key")
        end
    end
    manager:draw()
end
move = function(manager, listView, path, select)
    local isDir = fs.isDir(path)
    local name = fs.getName(path)
    local path = path:sub(1, path:len() - name:len())
    local save = assert(loadfile("os/system/explorer/explorer.lua"))({select = select, mode = "move", files = false, path = path, move = name, edit = false})
    if save then
        local newPath = fs.combine(save, name)
        local startPath = path .. name
        if
            not pcall(
                function()
                    fs.move(path .. name, newPath)
                end
            )
         then
        end
        updateListView(manager, listView)
        return true
    end
end
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
local fileButton = ui.button.new(manager, "File", nil, theme.button1, 1, 1, 6, 1)
local exitButton = ui.button.new(manager, "<", nil, theme.button2, _w - 2, 1, 3, 1)
local upButton = ui.button.new(manager, "^", nil, theme.button1, 8, 1, 3, 1)
local backButton = ui.button.new(manager, "<", nil, theme.button1, 11, 1, 3, 1)
local forwardButton = ui.button.new(manager, ">", nil, theme.button1, 14, 1, 3, 1)
local pathField = ui.inputField.new(manager, "", getCurrentPath(), false, nil, theme.iField2, 1, 2, _w, 1)
local listView = ui.scrollView.new(manager, nil, 3, theme.sView1, 1, 3, _w, _h - 2)
local backgroundListView = listView._elements[1]
local backgroundListViewBuffer = backgroundListView.buffer
for i = 1, _h - 1 do
    if set.icons == true then
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
    manager:draw()
end
fileButton._onClick = function(event)
    local select = true
    if event.name == "mouse_up" then
        select = false
        fileButton.mode = 3
        fileButton:recalculate()
    end
    manager:callFunction(
        function()
            local options = {}
            if set.edit == true then
                table.insert(options, "New Folder")
                table.insert(options, "New File")
            elseif set.mode == "move" or set.mode == "save" then
                table.insert(options, "New Folder")
            end
            if #options > 0 then
                local name = assert(loadfile("os/system/listBox.lua"))({x = 1, y = 1, manager = manager, label = "File", select = select, buttons = options})
                if name then
                    if name == "New Folder" then
                        create(manager, listView, "New Folder", getCurrentPath(), true)
                    elseif name == "New File" then
                        create(manager, listView, "New File.txt", getCurrentPath(), false)
                    end
                end
                manager:draw()
            end
        end
    )
end
upButton._onClick = function()
    addPath(fs.getDir(getCurrentPath()))
    updatePath()
    updateButton(manager)
    updateListView(manager, listView)
    manager:draw()
end
backButton._onClick = function()
    pathsIndex = pathsIndex - 1
    updatePath()
    updateButton(manager)
    updateListView(manager, listView)
    manager:draw()
end
forwardButton._onClick = function()
    pathsIndex = pathsIndex + 1
    updatePath()
    updateButton(manager)
    updateListView(manager, listView)
    manager:draw()
end
exitButton._onClick = function(self, event)
    term.setCursorPos(1, 1)
    if term.isColor() then
        term.setBackgroundColor(colors.black)
        term.setTextColor(colors.white)
    end
    term.clear()
    manager:exit()
end
manager.selectionManager:addSelectionGroup(listView.selectionGroup)
local menuGroup = manager.selectionManager:addNewSelectionGroup()
local fileButton_selection = menuGroup:addNewSelectionElement(fileButton)
local upButton_selection = menuGroup:addNewSelectionElement(upButton)
local backButton_selection = menuGroup:addNewSelectionElement(backButton)
local forwardButton_selection = menuGroup:addNewSelectionElement(forwardButton)
local exitButton_selection = menuGroup:addNewSelectionElement(exitButton)
local pathField_selection = menuGroup:addNewSelectionElement(pathField)
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
menuGroup.next = listView.selectionGroup
menuGroup.previous = listView.selectionGroup
listView.selectionGroup.next = menuGroup
listView.selectionGroup.previous = menuGroup
if set.mode == "save" then
    listView:setGlobalRect(nil, nil, nil, listView:getHeight() - 1)
    listView:resetLayout()
    local saveField = ui.inputField.new(manager, set.save, set.save, false, nil, theme.iField1, 1, _h, _w - 6, 1)
    saveField._onSubmit = function(event, text)
        if saveField ~= "" then
            table.insert(ret, getCurrentPath() .. "/" .. text)
        end
        saveField.mode = 1
        manager:exit()
    end
    local saveButton = ui.button.new(manager, "Save", nil, theme.button1, _w - 5, _h, 6, 1)
    saveButton._onClick = function(event)
        saveField:_onSubmit(event, saveField.text)
    end
    local saveMenuGroup = manager.selectionManager:addNewSelectionGroup()
    local saveField_selection = saveMenuGroup:addNewSelectionElement(saveField)
    local saveButton_selection = saveMenuGroup:addNewSelectionElement(saveButton)
    saveField_selection.right = saveButton_selection
    saveButton_selection.left = saveField_selection
    saveMenuGroup.currentSelectionElement = saveField_selection
    saveMenuGroup.previous = listView.selectionGroup
    saveMenuGroup.next = menuGroup
    menuGroup.previous = saveMenuGroup
    listView.selectionGroup.next = saveMenuGroup
elseif set.mode == "move" then
    listView:setGlobalRect(nil, nil, nil, listView:getHeight() - 1)
    listView:resetLayout()
    local label = ui.label.new(manager, set.move, theme.label1, 1, _h, _w - 6, 1)
    local moveButton = ui.button.new(manager, "Move", nil, theme.button1, _w - 5, _h, 6, 1)
    moveButton._onClick = function(event)
        table.insert(ret, getCurrentPath())
        manager:exit()
    end
    local moveMenuGroup = manager.selectionManager:addNewSelectionGroup()
    local moveButton_selection = moveMenuGroup:addNewSelectionElement(moveButton)
    moveMenuGroup.currentSelectionElement = moveButton_selection
    moveMenuGroup.previous = listView.selectionGroup
    moveMenuGroup.next = menuGroup
    menuGroup.previous = moveMenuGroup
    listView.selectionGroup.next = moveMenuGroup
elseif set.mode == "select_many" then
    listView:setGlobalRect(nil, nil, nil, listView:getHeight() - 1)
    listView:resetLayout()
    local selectedLabel = ui.label.new(manager, tostring(#set.items), theme.label1, 1, _h, _w - 15, 1)
    local clearSelectionButton = ui.button.new(manager, "Clear", nil, theme.button1, _w - 14, _h, 7, 1)
    clearSelectionButton._onClick = function(event)
        while #set.items > 0 do
            table.remove(set.items)
        end
        updateSelectionLabel(manager)
        updateListView(manager, listView)
        manager:draw()
    end
    local selectSelectionButton = ui.button.new(manager, "Select", nil, theme.button1, _w - 7, _h, 8, 1)
    selectSelectionButton._onClick = function()
        table.insert(ret, set.items)
        manager:exit()
    end
    local selectionMenuGroup = manager.selectionManager:addNewSelectionGroup()
    local clearSelectionButton_selection = selectionMenuGroup:addNewSelectionElement(clearSelectionButton)
    local selectSelectionButton_selection = selectionMenuGroup:addNewSelectionElement(selectSelectionButton)
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
if listView.selectionGroup.selectionElements[1] then
    manager.selectionManager._currentSelectionGroup = listView.selectionGroup
    if set.select then
        manager.selectionManager:select(listView.selectionGroup.selectionElements[1].element, "code")
    end
else
    manager.selectionManager._currentSelectionGroup = menuGroup
    if set.select then
        manager.selectionManager:select(menuGroup.currentSelectionElement.element, "code")
    end
end
manager:draw()
manager:execute()
return table.unpack(ret)
