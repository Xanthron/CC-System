local _x, _y, _w, _h = 1, 1, term.getSize()

local files = {}

local function loadFiles(path, files)
    local list = fs.list(path)
    for _, v in ipairs(list) do
        local path = fs.combine(path, v)
        if fs.isDir(path) then
            local main = fs.combine(path, "main.lua")
            if fs.exists(main) then
                local success, data
                fs.doFile(fs.combine(path, "start.lua"))
                table.insert(files, {path = main, name = textutils.getNeatName(path), data = data or {}})
            end
        else
            table.insert(files, {path = path, name = textutils.getNeatName(path), data = {}})
        end
    end
end
local function createEntry(sView, file, func1, func2, x, y, w, h)
    local container = sView:getContainer()

    local button_item = ui.button.new(container, file.name, nil, theme.button3, x, y, w - 6, h)
    local button_info = ui.button.new(container, "i", nil, theme.button3, x + w - 6, y, 3, h)
    local element = ui.element.new(container, "image", x + w - 3, y, 3, h)
    ---@type boolean
    local startup, enter, argument = false, true, false
    if file.data then
        startup = file.startup or false
        enter = file.enter or false
        argument = file.argument or false
    end
    local buffer = element.buffer
    if startup then
        buffer.text[1] = "s"
        buffer.textColor[1] = colors.black
        buffer.textBackgroundColor[1] = colors.lime
    else
        if term.isColor() then
            buffer.text[1] = "s"
            buffer.textColor[1] = colors.lightGray
            buffer.textBackgroundColor[1] = colors.gray
        else
            buffer.text[1] = " "
            buffer.textColor[1] = colors.white
            buffer.textBackgroundColor[1] = colors.black
        end
    end
    if enter then
        buffer.text[2] = "e"
        buffer.textColor[2] = colors.white
        buffer.textBackgroundColor[2] = colors.blue
    else
        if term.isColor() then
            buffer.text[2] = "e"
            buffer.textColor[2] = colors.lightGray
            buffer.textBackgroundColor[2] = colors.gray
        else
            buffer.text[2] = " "
            buffer.textColor[2] = colors.white
            buffer.textBackgroundColor[2] = colors.black
        end
    end
    if argument then
        buffer.text[3] = "a"
        buffer.textColor[3] = colors.red
        buffer.textBackgroundColor[3] = colors.yellow
    else
        if term.isColor() then
            buffer.text[3] = "a"
            buffer.textColor[3] = colors.lightGray
            buffer.textBackgroundColor[3] = colors.gray
        else
            buffer.text[3] = " "
            buffer.textColor[3] = colors.white
            buffer.textBackgroundColor[3] = colors.black
        end
    end

    button_item._onClick = func1
    button_info._onClick = func2
end
---@param manager uiManager
---@param sView scrollView
local function updateSView(manager, sView)
    sView:clear()
    local x, y, w, h = 1, 2, _w - 1, 1
    for i, file in ipairs(files) do
        local function start(self, event)
            manager:callFunction(
                function()
                    local success, select = assert(loadfile("os/sys/execute.lua"))({file = file.path, select = event.name ~= "mouse_up", edit = file.data.enter, args = {load(file.data.argument or "")()}})
                    manager:draw()
                end
            )
        end
        createEntry(sView, file, start, nil, x, y, w, h)
        y = y + 1
    end

    local elements = sView:getContainer()._elements
    for i = 1, #elements, 3 do
        sView.selectionGroup:addElement(elements[i], nil, elements[i - 3], elements[i + 1], elements[i + 3])
        sView.selectionGroup:addElement(elements[i + 1], elements[i], elements[i - 2], nil, elements[i + 4])
    end
    sView.selectionGroup.current = elements[1]
    local group_menu = manager.selectionManager.groups[1]
    if #elements > 0 then
        for i = 1, #group_menu.elements do
            group_menu.elements[i].select.down = sView.selectionGroup
        end
        elements[1].select.up = group_menu
        elements[2].select.up = group_menu
        group_menu.next = sView.selectionGroup
        group_menu.previous = sView.selectionGroup
    else
        for i = 1, #group_menu.elements do
            group_menu.elements[i].select.down = nil
        end
        group_menu.next = nil
        group_menu.previous = nil
    end

    sView:resizeContainer()
    sView:recalculate()
end

local manager = ui.uiManager.new(_x, _y, _w, _h)
for i = 1, _w * _h do
    if i <= _w then
        manager.buffer.text[i] = " "
        manager.buffer.textColor[i] = colors.green
        manager.buffer.textBackgroundColor[i] = colors.green
    else
        manager.buffer.text[i] = " "
        manager.buffer.textColor[i] = colors.white
        manager.buffer.textBackgroundColor[i] = colors.white
    end
end
local button_browser = ui.button.new(manager, "Browser", nil, theme.button1, 1, 1, 9, 1)
local button_explorer = ui.button.new(manager, "Explorer", nil, theme.button1, 10, 1, 10, 1)
local button_options = ui.button.new(manager, "\164", nil, theme.button1, _w - 5, 1, 3, 1)
local button_exit = ui.button.new(manager, "x", nil, theme.button2, _w - 2, 1, 3, 1)
local sView_list = ui.scrollView.new(manager, "", 3, theme.sView1, 1, 2, _w, _h - 1)

function button_browser:_onClick(event)
    manager:callFunction(
        function()
            local success, select = assert(loadfile("os/sys/execute.lua"))({file = "os/sys/browser/main.lua", select = event ~= "mouse_up", args = {{select = event ~= "mouse_up"}}})
            manager:draw()
        end
    )
end

function button_explorer:_onClick(event)
    manager:callFunction(
        function()
            local success, select = assert(loadfile("os/sys/execute.lua"))({file = "os/sys/explorer/main.lua", select = event ~= "mouse_up", args = {{select = event ~= "mouse_up"}}})
            manager:draw()
        end
    )
end

function button_options:_onClick(event)
end

function button_exit:_onClick(event)
    manager:exit()
    term.setCursorPos(1, 1)
    term.setTextColor(colors.white)
    term.setBackgroundColor(colors.black)
    term.clear()
end

local group_menu = manager.selectionManager:addNewGroup()
local group_list = sView_list.selectionGroup
manager.selectionManager:addGroup(group_list)
group_list.previous = group_menu
group_list.next = group_menu

group_menu:addElement(button_browser, nil, nil, button_explorer, nil)
group_menu:addElement(button_explorer, button_browser, nil, button_options, nil)
group_menu:addElement(button_options, button_explorer, nil, button_exit, nil)
group_menu:addElement(button_exit, button_options, nil, nil, nil)
group_menu.current = button_browser

files = {}
loadFiles("os/programs", files)
updateSView(manager, sView_list)

local mode = 3
if term.isColor() then
    mode = 1
end
if #sView_list:getContainer()._elements > 0 then
    manager.selectionManager:select(group_list, "code", mode)
else
    manager.selectionManager:select(group_menu, "code", mode)
end

manager:draw()
manager:execute()
