--[[
Settings:
    mode = "save","move","select_many"
        "save":
            save = start save name
            override = allow to select existing files
        "move":
            move = label
        "select_many":

    path = start Path "" when not exists

    icons = boolean
    hidden = boolean
    extensions = boolean
    neatNames = boolean
    pathsSize = integer
    type = "" set for mode save to "/" for only folders
    edit = boolean
]]
local args = ...

local set = dofile("os/sys/explorer/default.lua")
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
set.mode = set.mode or ""
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
local ignorePaths = dofile("os/sys/explorer/excludedPaths.lua")
local ext = {}
for _, v in ipairs(fs.list("os/sys/explorer/extensions")) do
    ext[v] = dofile("os/sys/explorer/extensions/" .. v)
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
local pathsIndex, paths = 0, {}
local ret = {}
local rename, move, copy, delete, create

local hasUnderMenu = false

local function getCurrentPath()
    return paths[pathsIndex]
end

---@param path string
local function addPath(path)
    path = path:gsub("/+$", "")
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

local function getNameAndIconKeyExtension(name)
    local startI, endI = name:find("%.[^%.]*$")
    local extension = nil
    if endI then
        extension = name:sub(startI + 1, endI)
        name = name:sub(1, startI - 1)
    end
    if set.neatNames == true then
        name = textutils.getNeatName(name)
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
    local element = ui.element.new(parent, "image", x, y, 3, 1)
    local buffer = element.buffer
    for i = 1, 3 do
        buffer.text[i] = ext[1][i]
        buffer.textColor[i] = ext[2][i]
        buffer.textBackgroundColor[i] = ext[3][i]
    end
    return element
end

local function updateListView(manager, listView)
    listView:clear()
    local dirs, files = getPathElements(getCurrentPath())
    local x, w, y = listView:getGlobalPosX() + #listView.style.nTheme.b[4], listView:getWidth() - #listView.style.nTheme.b[4] - #listView.style.nTheme.b[6] - 1, 3
    if set.icons then
        x = x + 4
        w = w - 4
    end
    ---@type element[]
    local elements = {}
    local container = listView:getContainer()
    for i = 1, #dirs, 2 do
        if set.icons then
            local ext = ext["folder"]
            extensionIcon(container, ext, x - 4, y)
        end
        local button = ui.button.new(container, dirs[i + 1], theme.button3, x, y, w, 1)
        button.path = dirs[i]
        button.onClick = function(self, event)
            if (event.name == "mouse_up" and event.param1 == 2) or (event.name == "key_up" and event.param1 == 29) then
                manager:callFunction(
                    function()
                        local options = {}
                        if set.edit then
                            if fs.isReadOnly(getCurrentPath()) or fs.isReadOnly(files[i]) then
                                table.insert(options, "*Rename")
                                table.insert(options, "*Move")
                                table.insert(options, "Copy")
                                table.insert(options, "-")
                                table.insert(options, "*Delete")
                            else
                                table.insert(options, "Rename")
                                table.insert(options, "Move")
                                table.insert(options, "Copy")
                                table.insert(options, "-")
                                table.insert(options, "Delete")
                            end
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
                        if set.mode == "save" and set.type == "/" then
                            if #options > 0 then
                                table.insert(options, "-")
                            end
                            table.insert(options, "Select")
                        end
                        if #options > 0 then
                            local y = self:getGlobalPosY() + 1
                            if y + #options + 2 > _h + _y then
                                y = y - 3 - #options
                                if y < 1 then
                                    y = 1
                                end
                            end
                            local name, indexes, select = assert(loadfile("os/sys/listBox.lua"))({x = self:getGlobalPosX(), y = y, manager = manager, label = "File", select = select, buttons = options})
                            if name then
                                if name == "Rename" then
                                    manager.parallelManager:removeFunction(self.animation)
                                    rename(manager, listView, self, dirs[i])
                                elseif name == "Move" then
                                    manager.parallelManager:removeFunction(self.animation)
                                    move(manager, listView, dirs[i], select)
                                elseif name == "Copy" then
                                    manager.parallelManager:removeFunction(self.animation)
                                    copy(manager, listView, dirs[i], select)
                                elseif name == "Delete" then
                                    manager.parallelManager:removeFunction(self.animation)
                                    delete(manager, listView, dirs[i], select)
                                elseif name == "Select All" then
                                    for _, p in ipairs(fs.listAll(dirs[i])) do
                                        if isSelected(p) == false then
                                            addSelection(p)
                                        end
                                    end
                                    updateSelectionLabel(manager)
                                elseif name == "Remove All" then
                                    for _, p in ipairs(fs.listAll.getAllFilePaths(dirs[i])) do
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
                manager.parallelManager:removeFunction(self.animation)
                addPath(dirs[i])
                updateListView(manager, listView)
                updateButton(manager)
                if event.name ~= "mouse_up" then
                    if listView:getContainer()._elements[1] then
                        manager.selectionManager:select(listView.selectionGroup, "key", 3)
                    else
                        manager.selectionManager:select(manager.selectionManager.groups[2].elements[1], "key", 3)
                    end
                end
                manager:draw()
            end
        end
        table.insert(elements, button)
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
        local button = ui.button.new(container, files[i + 1], buttonTheme, x, y, w, 1)
        button.path = files[i]
        button.onClick = function(self, event)
            if (event.name == "mouse_up" and event.param1 == 2) or (event.name == "key_up" and event.param1 == 29) then
                manager:callFunction(
                    function()
                        local options = {}
                        if set.edit then
                            if fs.isReadOnly(getCurrentPath()) or fs.isReadOnly(files[i]) then
                                table.insert(options, "*Rename")
                                table.insert(options, "*Move")
                                table.insert(options, "Copy")
                                table.insert(options, "-")
                                table.insert(options, "*Delete")
                            else
                                table.insert(options, "Rename")
                                table.insert(options, "Move")
                                table.insert(options, "Copy")
                                table.insert(options, "-")
                                table.insert(options, "Delete")
                            end
                        end
                        if #options > 0 then
                            local select = true
                            if event.name == "mouse_up" then
                                select = false
                            end
                            local y = self:getGlobalPosY() + 1
                            if y + #options + 2 > _h + _y then
                                y = y - 3 - #options
                                if y < 1 then
                                    y = 1
                                end
                            end
                            local name, indexes, select = assert(loadfile("os/sys/listBox.lua"))({x = self:getGlobalPosX(), y = y, manager = manager, label = "File", select = select, buttons = options})
                            if name then
                                if name == "Rename" then
                                    manager.parallelManager:removeFunction(self.animation)
                                    rename(manager, listView, self, files[i])
                                elseif name == "Move" then
                                    manager.parallelManager:removeFunction(self.animation)
                                    move(manager, listView, files[i], select)
                                elseif name == "Copy" then
                                    manager.parallelManager:removeFunction(self.animation)
                                    copy(manager, listView, files[i], select)
                                elseif name == "Delete" then
                                    manager.parallelManager:removeFunction(self.animation)
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
                    if set.type ~= "/" then
                        local element = manager._elements[8]
                        element:setText(fs.getName(files[i]))
                        manager.selectionManager:select(element, "key", 3)
                        element:recalculateText()
                        element:repaint("this")
                    end
                elseif set.mode == "select_one" then
                    ret = {files[i]}
                    manager:exit()
                else
                    manager:callFunction(
                        function()
                            assert(loadfile("os/sys/execute.lua"))(ext[4] or "rom/programs/edit.lua", files[i])
                            manager:draw()
                        end
                    )
                end
            end
        end
        table.insert(elements, button)
        y = y + 1
    end
    if #elements > 0 then
        for i = 1, #elements do
            listView.selectionGroup:addElement(elements[i], nil, elements[i - 1], nil, elements[i + 1])
        end
        elements[1].select.up = manager.selectionManager.groups[3]
        local pathGroup = manager.selectionManager.groups[3]
        pathGroup.elements[1].select.down = elements[1]
        pathGroup.next = listView.selectionGroup
        if hasUnderMenu then
            local underMenuGroup = manager.selectionManager.groups[4]
            elements[#elements].select.down = underMenuGroup
            underMenuGroup.previous = listView.selectionGroup
            for i = 1, #underMenuGroup.elements do
                underMenuGroup.elements[i].select.up = elements[#elements]
            end
        end
    else
        local pathGroup = manager.selectionManager.groups[3]
        if hasUnderMenu then
            local underMenuGroup = manager.selectionManager.groups[4]

            pathGroup.next = underMenuGroup
            underMenuGroup.previous = pathGroup

            pathGroup.elements[1].select.down = underMenuGroup
            for i = 1, #underMenuGroup.elements do
                underMenuGroup.elements[i].select.up = pathGroup
            end
        else
            local menuGroup = manager.selectionManager.groups[2]
            pathGroup.next = menuGroup
            pathGroup.current.select.down = nil
            menuGroup.previous = pathGroup
        end
    end
    listView.selectionGroup.current = elements[1]
    listView:recalculate() --elements[1]
    listView:resetLayout()
end
local function nameItem(manager, text, submit, x, y, w, h)
    local field = ui.inputField.new(manager, "", text, false, theme.iField1, x, y, w, h)
    local selectionGroup = manager.selectionManager:addNewGroup(manager.selectionManager.current, manager.selectionManager.current)
    selectionGroup:addElement(field)
    --selectionGroup.current = field
    function selectionGroup:listener(eventName, source, ...)
        if eventName == "selection_lose_focus" then
            local current, new = ...
            field.mode = 1
            field:setParent(nil)
            manager.selectionManager:removeGroup(selectionGroup)
            manager:repaint("this")
            return true
        end
    end
    field._onSubmit = submit
    manager.selectionManager:select(field, "code", 3)
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
                manager.selectionManager:select(e, "code", 3)
                return
            end
        end
        manager.selectionManager:select(listView.selectionGroup, "code", 3)
    end
    nameItem(manager, name, submit, element:getGlobalRect())
end
create = function(manager, listView, name, path, isDir)
    local submit = function(self, event, text)
        local newPath = fs.combine(path, text)
        if text ~= "" then
            if fs.exists(newPath) then
                if isDir then
                    assert(loadfile("os/sys/infoBox.lua"))({x = _x + 2, y = _y + 2, w = _w - 4, h = _h - 4, text = "Directory already exist.\nA new Directory is not created.", label = "Directory already exist", select = true, button1 = "Ok"})
                    manager:draw()
                    return
                else
                    if assert(loadfile("os/sys/infoBox.lua"))({x = _x + 2, y = _y + 2, w = _w - 4, h = _h - 4, text = "File already exist.\nShould the file still be created?", label = "File already exist", select = true, button1 = "Cancel", button2 = "Create"}) == 1 then
                        manager:draw()
                        return
                    end
                end
            end
            if isDir then
                fs.makeDir(newPath)
            else
                local file = io.open(newPath, "w+")
                file:close()
            end
            updateListView(manager, listView)
            for _, e in ipairs(listView:getContainer()._elements) do
                if e.path == newPath then
                    manager.selectionManager:select(e, "code", 3)
                    return
                end
            end
            manager.selectionManager:select(listView.selectionGroup, "code", 3)
        end
    end
    nameItem(manager, name, submit, 1, 2, _w, 1)
end
delete = function(manager, listView, path, select)
    if fs.isReadOnly(path) then
        assert(loadfile("os/sys/infoBox.lua"))({x = _x + 2, y = _y + 2, w = _w - 4, h = _h - 4, text = "Directory is read only.", label = "Directory is read only", select = true, button1 = "Ok"})
    else
        if assert(loadfile("os/sys/infoBox.lua"))({x = _x + 2, y = _y + 2, w = _w - 4, h = _h - 4, text = ("Do you realy want to delete %q?\nA recovery is not possible"):format(fs.getName(path)), label = "Delete", select = select, button1 = "Cancel", button2 = "Delete"}) == 1 then
        else
            fs.delete(path)
            updateListView(manager, listView)
            if select then
                if listView:getContainer()._elements[1] then
                    manager.selectionManager:select(listView.selectionGroup, "key", 3)
                else
                    manager.selectionManager:select(manager.selectionManager.groups[2].elements[1], "key", 3)
                end
            end
        end
    end
    manager:draw()
end
move = function(manager, listView, path, select)
    local isDir = fs.isDir(path)
    local name = fs.getName(path)
    local path = path:sub(1, path:len() - name:len())
    local save = assert(loadfile("os/sys/explorer/main.lua"))({select = select, mode = "move", files = false, path = path, move = name, edit = false})
    if save then
        local newPath = fs.combine(save, name)
        local startPath = path .. name
        if
            pcall(
                function()
                    fs.move(path .. name, newPath)
                end
            )
         then
            manager:draw()
            updateListView(manager, listView)
        else
            assert(loadfile("os/sys/infoBox.lua"))({x = _x + 2, y = _y + 2, w = _w - 4, h = _h - 4, text = "Access denied.\nFile could not be moved.", label = "Move file failed", select = select, button1 = "Ok"})
        end
    end
end
copy = function(manager, listView, path, select)
    local dirPath, name = fs.getDir(path), fs.getName(path)
    local save = assert(loadfile("os/sys/explorer/main.lua"))({select = select, mode = "move", files = false, path = dirPath, move = name, edit = false})
    if save then
        if fs.isReadOnly(save) then
            assert(loadfile("os/sys/infoBox.lua"))({x = _x + 2, y = _y + 2, w = _w - 4, h = _h - 4, text = "Access denied.\nFolder is read only.", label = "Copy file failed", select = select, button1 = "Ok"})
        else
            if save == dirPath then
                local dir = fs.getDir(path)
                local name = fs.getClearName(path)
                local ext = fs.getExtension(path)
                local i = 1
                local newPath
                repeat
                    if ext then
                        newPath = fs.combine(dir, ("%s (%i).%s"):format(name, i, ext))
                    else
                        newPath = fs.combine(dir, ("%s (%i)"):format(name, i))
                    end
                    i = i + 1
                until not fs.exists(newPath)
                fs.copy(path, newPath)
            else
                local T, t
                if fs.isDir(path) then
                    T = "Directory"
                    t = "directory"
                else
                    T = "File"
                    t = "file"
                end
                local newPath = fs.combine(save, name)
                if fs.exists(newPath) then
                    if assert(loadfile("os/sys/infoBox.lua"))({x = _x + 2, y = _y + 2, w = _w - 4, h = _h - 4, text = ("%s already exist.\nShould the %s still be created?"):format(T, t), label = ("%s already exist"):format(T), select = true, button1 = "Cancel", button2 = "Copy"}) == 2 then
                        fs.delete(newPath)
                        fs.copy(path, newPath)
                    end
                else
                    fs.copy(path, newPath)
                end
            end
        end
    end
    manager:draw()
end

addPath(set.path)
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
local fileButton = ui.button.new(manager, "File", theme.button1, 1, 1, 6, 1)
local exitButton = ui.button.new(manager, "<", theme.button2, _w - 2, 1, 3, 1)
local upButton = ui.button.new(manager, "^", theme.button1, 8, 1, 3, 1)
local backButton = ui.button.new(manager, "<", theme.button1, 11, 1, 3, 1)
local forwardButton = ui.button.new(manager, ">", theme.button1, 14, 1, 3, 1)
local pathField = ui.inputField.new(manager, "", getCurrentPath(), false, theme.iField2, 1, 2, _w, 1)
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
function pathField:onSuggestCompletion(text, offset)
    if text:len() == offset then
        local startI, endI = text:match("%/.*$")
        if startI == nil or endI == nil then
            self.autoComplete = fs.complete(text, "", false, false)
        else
            self.autoComplete = fs.complete(text:sub(endI), text:sub(1, startI), false, true)
        end
    else
        self.autoComplete = {}
    end
end
function pathField:onAutoCompletion(text, offset, completion)
    if offset == text:len() then
        return true, text .. completion, text:len() + completion:len()
    else
        return false
    end
end
function pathField:_onSubmit(event, text)
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
function fileButton:onClick(event)
    local select = true
    if event.name == "mouse_up" then
        select = false
        fileButton.mode = 3
        fileButton:recalculate()
    end
    manager:callFunction(
        function()
            local options = {}
            if fs.isReadOnly(getCurrentPath()) then
                table.insert(options, "*New Folder")
                table.insert(options, "*New File")
            elseif set.edit == true then
                table.insert(options, "New Folder")
                table.insert(options, "New File")
            elseif set.mode == "move" or set.mode == "save" then
                table.insert(options, "New Folder")
                table.insert(options, "*New File")
            end
            if #options > 0 then
                local name = assert(loadfile("os/sys/listBox.lua"))({x = 1, y = 1, manager = manager, label = "File", select = select, buttons = options})
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
function upButton:onClick(event)
    addPath(fs.getDir(getCurrentPath()))
    updatePath()
    updateButton(manager)
    if self.mode == 2 then
        local group = manager.selectionManager.groups[2]
        group.current = fileButton
        if event.neme ~= "mouse_up" then
            manager.selectionManager:select(group, "code", 3)
        end
    end
    updateListView(manager, listView)
    manager:draw()
end
function backButton:onClick(event)
    pathsIndex = pathsIndex - 1
    updatePath()
    updateButton(manager)
    if self.mode == 2 then
        local group = manager.selectionManager.groups[2]
        group.current = fileButton
        if event.neme ~= "mouse_up" then
            manager.selectionManager:select(group, "code", 3)
        end
    end
    updateListView(manager, listView)
    manager:draw()
end
function forwardButton:onClick(event)
    pathsIndex = pathsIndex + 1
    updatePath()
    updateButton(manager)
    if self.mode == 2 then
        local group = manager.selectionManager.groups[2]
        group.current = fileButton
        if event.neme ~= "mouse_up" then
            manager.selectionManager:select(group, "code", 3)
        end
    end
    updateListView(manager, listView)
    manager:draw()
end
function exitButton:onClick(event)
    term.setCursorPos(1, 1)
    if term.isColor() then
        term.setBackgroundColor(colors.black)
        term.setTextColor(colors.white)
    end
    term.clear()
    manager:exit()
end

manager.selectionManager:addGroup(listView.selectionGroup)
local menuGroup = manager.selectionManager:addNewGroup(listView.selectionGroup)
local pathGroup = manager.selectionManager:addNewGroup(menuGroup, listView.selectionGroup)

menuGroup.next = pathGroup
menuGroup.previous = listView.selectionGroup
listView.selectionGroup.next = menuGroup
listView.selectionGroup.previous = pathGroup

menuGroup:addElement(fileButton, nil, nil, upButton, pathGroup)
menuGroup:addElement(upButton, fileButton, nil, backButton, pathGroup)
menuGroup:addElement(backButton, upButton, nil, forwardButton, pathGroup)
menuGroup:addElement(forwardButton, backButton, nil, exitButton, pathGroup)
menuGroup:addElement(exitButton, forwardButton, nil, nil, pathGroup)
pathGroup:addElement(pathField, nil, menuGroup, nil, listView.selectionGroup)

menuGroup.current = fileButton
pathGroup.current = pathField

if set.mode == "save" then
    listView:setGlobalRect(nil, nil, nil, listView:getHeight() - 1)
    listView:resetLayout()
    local saveField = ui.inputField.new(manager, "", set.save, false, theme.iField1, 1, _h, _w - 6, 1)
    local saveButton = ui.button.new(manager, "Save", theme.button1, _w - 5, _h, 6, 1)

    local function checkButton(text)
        if text:len() > 0 and (set.override == true or not fs.exists(getCurrentPath() .. "/" .. text)) then
            return true
        else
            return false
        end
    end

    function saveField:_onSubmit(event, text)
        if checkButton(text) then
            saveButton:onClick(event)
        end
    end
    function saveField:onTextEdit(event, ...)
        if event == "char" or event == "paste" then
            local var1 = ...
            local text = self.text:sub(1, self.cursorOffset) .. var1 .. self.text:sub(self.cursorOffset + 1)
            if checkButton(text) then
                saveButton:changeMode(1, true)
            else
                saveButton:changeMode(2, true)
            end
            return var1
        elseif event == "text" then
            local text = ...
            if checkButton(text) then
                saveButton:changeMode(1, true)
            else
                saveButton:changeMode(2, true)
            end
            return text
        elseif event == "delete" then
            if checkButton(self.text) then
                saveButton:changeMode(1, true)
            else
                saveButton:changeMode(2, true)
            end
        end
    end
    function saveButton:onClick(event)
        if saveField ~= "" then
            table.insert(ret, getCurrentPath() .. "/" .. saveField.text)
        end
        saveField.mode = 1
        manager:exit()
    end
    local saveMenuGroup = manager.selectionManager:addNewGroup(listView.selectionGroup, menuGroup)
    menuGroup.previous = saveMenuGroup
    listView.selectionGroup.next = saveMenuGroup

    saveMenuGroup:addElement(saveField, nil, nil, nil, nil)
    saveMenuGroup:addElement(saveButton, saveField, nil, nil, nil)

    saveMenuGroup.current = saveField
    hasUnderMenu = true
elseif set.mode == "move" then
    listView:setGlobalRect(nil, nil, nil, listView:getHeight() - 1)
    listView:resetLayout()
    local label = ui.label.new(manager, set.move, theme.label1, 1, _h, _w - 6, 1)
    local moveButton = ui.button.new(manager, "Move", theme.button1, _w - 5, _h, 6, 1)
    function moveButton:onClick(event)
        table.insert(ret, getCurrentPath())
        manager:exit()
    end
    local moveMenuGroup = manager.selectionManager:addNewGroup(listView.selectionGroup, menuGroup)
    menuGroup.previous = moveMenuGroup
    listView.selectionGroup.next = moveMenuGroup

    moveMenuGroup:addElement(moveButton, nil, nil, nil)

    moveMenuGroup.current = moveButton
    hasUnderMenu = true
elseif set.mode == "select_many" then
    listView:setGlobalRect(nil, nil, nil, listView:getHeight() - 1)
    listView:resetLayout()
    local selectedLabel = ui.label.new(manager, tostring(#set.items), theme.label1, 1, _h, _w - 15, 1)
    local clearSelectionButton = ui.button.new(manager, "Clear", theme.button1, _w - 14, _h, 7, 1)
    clearSelectionButton.onClick = function(event)
        while #set.items > 0 do
            table.remove(set.items)
        end
        updateSelectionLabel(manager)
        updateListView(manager, listView)
        manager:draw()
    end
    local selectSelectionButton = ui.button.new(manager, "Select", theme.button1, _w - 7, _h, 8, 1)
    selectSelectionButton.onClick = function()
        table.insert(ret, set.items)
        manager:exit()
    end
    local selectionMenuGroup = manager.selectionManager:addNewGroup(listView.selectionGroup, menuGroup)
    menuGroup.previous = selectionMenuGroup
    listView.selectionGroup.next = selectionMenuGroup

    selectionMenuGroup:addElement(clearSelectionButton, nil, nil, selectSelectionButton, nil)
    selectionMenuGroup:addElement(selectSelectionButton, clearSelectionButton, nil, nil, nil)

    selectionMenuGroup.current = selectSelectionButton
    hasUnderMenu = true
end
updateButton(manager)
updateListView(manager, listView)
local mode = 3
if set.select == false then
    mode = 1
end
-- if listView:getContainer()._elements[1] then
--     manager.selectionManager:select(listView.selectionGroup, "code", mode)
-- else
manager.selectionManager:select(menuGroup, "code", mode)
--end
manager:draw()
manager:execute()
return table.unpack(ret)
