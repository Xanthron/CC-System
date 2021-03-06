--[[
    ####################################################################################################################
    Variables
    ####################################################################################################################
]]
ui.input.term = term
local _x, _y, _w, _h = 1, 1, term.getSize()
local path
local items = {}
--[[
    ####################################################################################################################
    Functions
    ####################################################################################################################
]]
---@param sView scrollView
---@param name string
---@param id integer
local function createListItem(sView, data, func, x, y, w, h)
    local container = sView:getContainer()
    ui.label.new(container, data[1], theme.label2, x, y, w - 10, h)
    if data[2] then
        ui.label.new(container, tostring(data[2]), theme.label2, x + w - 10, y, 7, h)
    end
    local button = ui.button.new(container, "x", theme.button2, x + w - 3, y, 3, h)

    button.onClick = func
    return button
end
---@param drawer drawer
---@param sView scrollView
local function updateList(drawer, sView)
    sView:clear()
    local x, y, w, h = 1, 2, _w - 1, 1
    local buttons = {}
    for i, v in ipairs(items) do
        ---@param self button
        ---@param event event
        local func = function(self, event)
            drawer:getInput():callFunction(
                function()
                    drawer:getParallelManager():removeFunction(self.animation)
                    table.remove(items, i)
                    local id = math.min(#items, i)
                    updateList(drawer, sView)
                    if id > 0 then
                        local mode = 3
                        if event.name == "mouse_up" then
                            mode = 1
                        end
                        drawer.selectionManager:select(sView:getContainer().element[id * 2], "code", mode)
                    end
                    drawer:draw()
                end
            )
        end

        table.insert(buttons, createListItem(sView, v, func, x, y, w, h))

        y = y + 1
    end

    for i = 2, #buttons, 2 do
        sView.selectionGroup:addElement(buttons[i], nil, buttons[i - 1], nil, buttons[i + 1])
    end

    local element = buttons[#buttons]
    sView.current = element
    local group_menu = drawer.selectionManager.groups[1]
    local group_tool = drawer.selectionManager.groups[2]
    if element then
        group_menu.elements[1].select.down = buttons[1]
        for _, v in ipairs(group_tool.elements) do
            v.select.up = element
        end

        group_menu.next = sView.selectionGroup
        group_tool.previous = sView.selectionGroup

        buttons[1].select.up = group_menu
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
local function addItem(name, data, meta)
    for _, v in pairs(items) do
        if v[1] == name and (not meta or v[2] == data) then
            return false
        end
    end
    table.insert(items, {name, IF(meta, data)})
    return true
end
local function addItems(drawer, sView, meta)
    for i = 1, 16 do
        turtle.select(i)
        local data = turtle.getItemDetail()
        if data and addItem(data.name, data.damage, meta) then
            updateList(drawer, sView)
            local elements = sView:getContainer().element
            sView:focusElement(elements[#elements])
            sView:repaint("this")
        end
        turtle.drop()
    end
    turtle.select(1)
end
local function loadFile(path)
    local list = dofile(path)
    for _, v in pairs(list) do
        addItem(v[1], v[2], true)
    end
end
--[[
    ####################################################################################################################
    SetUp
    ####################################################################################################################
]]
local input = ui.input.new()
local drawer = ui.drawer.new(input, _x, _y, _w, _h)
local index
for i = 1, _w * _h do
    if i <= _w or i >= _w * (_h - 1) then
        drawer.buffer.text[i] = " "
        drawer.buffer.textColor[i] = colors.green
        drawer.buffer.textBackgroundColor[i] = colors.green
    else
        drawer.buffer.text[i] = " "
        drawer.buffer.textColor[i] = colors.white
        drawer.buffer.textBackgroundColor[i] = colors.white
    end
end

local label_title = ui.label.new(drawer, "Item List", theme.label1, 1, 1, _w - 3, 1)
local button_exit = ui.button.new(drawer, "<", theme.button2, _w - 2, 1, 3, 1)
local sView_list = ui.scrollView.new(drawer, "", 3, theme.sView1, 1, 2, _w, _h - 2)
local button_load = ui.button.new(drawer, "Load", theme.button1, 1, _h, 6, 1)
local button_clear = ui.button.new(drawer, "Clear", theme.button1, 7, _h, 7, 1)
local button_add = ui.button.new(drawer, "Add", theme.button1, 14, _h, 5, 1)
local button_addPlus = ui.button.new(drawer, "Add+", theme.button1, 19, _h, 6, 1)
local button_sort = ui.button.new(drawer, "Sort", theme.button1, _w - 11, _h, 6, 1)
local button_save = ui.button.new(drawer, "Save", theme.button1, _w - 5, _h, 6, 1)

local group_menu = drawer.selectionManager:addNewGroup()
local group_tool = drawer.selectionManager:addNewGroup()
drawer.selectionManager:addGroup(sView_list.selectionGroup)
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
group_tool:addElement(button_add, button_clear, group_menu, button_addPlus, nil)
group_tool:addElement(button_addPlus, button_add, group_menu, button_sort, nil)
group_tool:addElement(button_sort, button_addPlus, group_menu, button_save, nil)
group_tool:addElement(button_save, button_sort, group_menu, nil, nil)
group_tool.current = button_add

function button_exit:onClick(event)
    input:exit()
end

function button_load:onClick(event)
    input:callFunction(
        function()
            local selection = callfile("os/sys/explorer/main.lua", {mode = "select_one", path = "os/programs", type = "list", edit = false, select = event ~= "mouse_up"})
            if selection then
                path = selection
                loadFile(path)
                updateList(drawer, sView_list)
            end
            drawer:draw()
        end
    )
end

function button_clear:onClick(event)
    items = {}
    updateList(drawer, sView_list)
    drawer:draw()
end

function button_add:onClick(event)
    input:callFunction(
        function()
            addItems(drawer, sView_list, false)
            drawer:draw()
        end
    )
end
function button_addPlus:onClick(event)
    input:callFunction(
        function()
            addItems(drawer, sView_list, true)
            drawer:draw()
        end
    )
end
function button_sort:onClick(event)
    table.orderComplex(
        items,
        function(v)
            local ret = {v[1]:byte(1, v[1]:len())}
            table.insert(ret, v[2])
            return table.unpack(ret)
        end
    )
    updateList(drawer, sView_list)
    drawer:draw()
end

function button_save:onClick(event)
    input:callFunction(
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
            drawer:draw()
        end
    )
end

drawer.selectionManager:select(button_add, "code", 3)

drawer:draw()
input:eventLoop({[term] = drawer.event})
