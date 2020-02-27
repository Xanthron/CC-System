--[[
    ####################################################################################################################
    Variables
    ####################################################################################################################
]]
local _x, _y, _w, _h = 1, 1, term.getSize()
local path
local items = {}
--[[
    ####################################################################################################################
    Functions
    ####################################################################################################################
]]
local function addItem(name)
    for _, v in pairs(items) do
        if v == name then
            return false
        end
    end
    table.insert(items, name)
    return true
end
local function loadFile(path)
    local list = dofile(path)
    for _, v in pairs(list) do
        addItem(v)
    end
end
---@param sView scrollView
---@param name string
---@param id integer
local function createListItem(sView, name, func, x, y, w, h)
    local container = sView:getContainer()
    local element = ui.label.new(container, name, theme.label2, x, y, w - 3, h)
    local button = ui.button.new(container, "x", theme.button2, x + w - 3, y, 3, h)

    button.onClick = func

    return element, button
end
---@param manager uiManager
---@param sView scrollView
local function updateList(manager, sView)
    sView:clear()
    local x, y, w, h = 1, 2, _w - 1, 1
    for i, v in ipairs(items) do
        ---@param self button
        ---@param event event
        local func = function(self, event)
            manager:callFunction(
                function()
                    manager.parallelManager:removeFunction(self.animation)
                    table.remove(items, i)
                    local id = math.min(#items, i)
                    updateList(manager, sView)
                    if id > 0 then
                        local mode = 3
                        if event.name == "mouse_up" then
                            mode = 1
                        end
                        manager.selectionManager:select(sView:getContainer().element[id * 2], "code", mode)
                    end
                    manager:draw()
                end
            )
        end

        createListItem(sView, v, func, x, y, w, h)

        y = y + 1
    end

    local elements = sView:getContainer().element
    for i = 2, #elements, 2 do
        sView.selectionGroup:addElement(elements[i], nil, elements[i - 2], nil, elements[i + 2])
    end

    local element = elements[#elements]
    sView.current = element
    local group_menu = manager.selectionManager.groups[1]
    local group_tool = manager.selectionManager.groups[2]
    if element then
        group_menu.elements[1].select.down = elements[2]
        for _, v in ipairs(group_tool.elements) do
            v.select.up = element
        end

        group_menu.next = sView.selectionGroup
        group_tool.previous = sView.selectionGroup

        elements[2].select.up = group_menu
        element.select.down = group_tool

        sView:focusElement(element)
    else
        group_menu.elements[1].select.down = group_tool
        for _, v in ipairs(group_tool.elements) do
            v.select.up = group_menu
        end

        group_menu.next = group_tool
        group_tool.previous = group_menu
    end

    sView:resizeContainer()
end
--[[
    ####################################################################################################################
    SetUp
    ####################################################################################################################
]]
local manager = ui.uiManager.new(_x, _y, _w, _h)
local index
for i = 1, _w * _h do
    if i <= _w or i >= _w * (_h - 1) then
        manager.buffer.text[i] = " "
        manager.buffer.textColor[i] = colors.green
        manager.buffer.textBackgroundColor[i] = colors.green
    else
        manager.buffer.text[i] = " "
        manager.buffer.textColor[i] = colors.white
        manager.buffer.textBackgroundColor[i] = colors.white
    end
end

local label_title = ui.label.new(manager, "Item List", theme.label1, 1, 1, _w - 3, 1)
local button_exit = ui.button.new(manager, "<", theme.button2, _w - 2, 1, 3, 1)
local sView_list = ui.scrollView.new(manager, "", 3, theme.sView1, 1, 2, _w, _h - 2)
local button_load = ui.button.new(manager, "Load", theme.button1, 1, _h, 6, 1)
local button_clear = ui.button.new(manager, "Clear", theme.button1, 7, _h, 7, 1)
local button_add = ui.button.new(manager, "Add", theme.button1, 14, _h, 5, 1)
local button_save = ui.button.new(manager, "Save", theme.button1, _w - 5, _h, 6, 1)

local group_menu = manager.selectionManager:addNewGroup()
local group_tool = manager.selectionManager:addNewGroup()
manager.selectionManager:addGroup(sView_list.selectionGroup)
local group_list = sView_list.selectionGroup
group_menu.next = group_tool
group_menu.previous = group_tool
group_tool.next = group_menu
group_tool.previous = group_menu
group_list.next = group_tool
group_list.next = group_menu

group_menu:addElement(button_exit, nil, nil, nil, group_tool)
group_menu.current = button_exit
group_tool:addElement(button_load, nil, group_menu, button_clear, nil)
group_tool:addElement(button_clear, button_load, group_menu, button_add, nil)
group_tool:addElement(button_add, button_clear, group_menu, button_save, nil)
group_tool:addElement(button_save, button_add, group_menu, nil, nil)
group_tool.current = button_add

function button_exit:onClick(event)
    manager:exit()
end

function button_load:onClick(event)
    manager:callFunction(
        function()
            local selection = callfile("os/sys/explorer/main.lua", {mode = "select_one", path = "os/programs", type = "list", edit = false, select = event ~= "mouse_up"})
            if selection then
                path = selection
                loadFile(path)
                updateList(manager, sView_list)
            end
            manager:draw()
        end
    )
end

function button_clear:onClick(event)
    items = {}
    updateList(manager, sView_list)
    manager:draw()
end

function button_add:onClick(event)
    manager:callFunction(
        function()
            for i = 1, 16 do
                turtle.select(i)
                local data = turtle.getItemDetail()
                if data and addItem(data.name) then
                    updateList(manager, sView_list)
                    local elements = sView_list:getContainer().element
                    sView_list:focusElement(elements[#elements])
                    sView_list:repaint("this")
                end
                turtle.drop()
            end
            turtle.select(1)
            --self:recalculate()
            manager:draw()
        end
    )
end

function button_save:onClick(event)
    manager:callFunction(
        function()
            local save = "os/programs/"
            local name = "List.list"
            if path then
                name = fs.getName(path)
                save = fs.getDir(path)
            end
            local save = callfile("os/sys/explorer/main.lua", {mode = "save", override = true, save = name, path = save, type = "list", edit = false, select = event.name ~= "mouse_up"})
            if save then
                if
                    pcall(
                        function()
                            save = fs.addExtension(save, "list")
                            path = save
                            table.save(items, save)
                        end
                    )
                 then
                    callfile("os/sys/infoBox.lua", {x = _x + 2, y = _y + 2, w = _w - 4, h = _h - 4, text = "File creation succeeded.", button1 = "Ok", select = event.name ~= "mouse_up"})
                else
                    callfile("os/sys/infoBox.lua", {x = _x + 2, y = _y + 2, w = _w - 4, h = _h - 4, text = "File creation failed.", button1 = "Ok", select = event.name ~= "mouse_up"})
                end
            end
            manager:draw()
        end
    )
end

manager.selectionManager:select(button_add, "code", 3)

manager:draw()
manager:execute()
