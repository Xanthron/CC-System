--[[
        download list of downloadable files
        description for downloadable files
        create additional own list
        upload files and paste in own list
]]
--[[
    ####################################################################################################################
    Variables
    ####################################################################################################################
]]
local args = ...
args.term = args.term or term
local defaultPasteBin = "ZbWvc7x9"
---@type integer
local _x, _y, _w, _h = 1, 1, term.getSize()
local sortType = 3
---@type table
local official, unofficial, installed, list, updateSView

--[[
    ####################################################################################################################
    Functions
    ####################################################################################################################
]]
local function getInstalled(name)
    for k, v in pairs(installed) do
        if v.name == name then
            return true, v.version, v.delete
        end
    end
    return false
end

local function applyData(list, removable)
    for k, v in pairs(list) do
        v.removable = removable
        local installed, version, delete = getInstalled(v.name)
        if installed then
            v.status = 2
            for i = 1, math.min(#v.version or 0, #version) do
                if v.version[i] > version[i] then
                    v.status = 1
                    v.versionOld = version
                    break
                end
            end
            v.deleteOld = delete
        else
            if (v.type == "all" or (pocket and v.type:find("p")) or (turtle and v.type:find("t")) or v.type:find("d")) and (term.isColor() or not v.color) then
                v.status = 3
            else
                v.status = 4
            end
        end
    end
end
local function sortFiles()
    list = table.combine(official, unofficial)
    if sortType > 1 then
        table.orderComplex(
            list,
            function(data)
                return data.name:byte(1, data.name:len())
            end
        )
        if sortType == 3 then
            table.orderComplex(
                list,
                function(data)
                    return data.status
                end
            )
        end
    end
end
local function updateFiles(mode)
    callfile(
        "os/sys/wait.lua",
        args.term,
        "Downloading",
        function()
            local l1, l2, l3 = callfile("os/sys/browser/getList.lua", mode)
            installed = l3
            if mode then
                official = l1
            end
            unofficial = l2
            applyData(official, false)
            applyData(unofficial, true)
            sortFiles()
        end
    )
end

---@param manager uiManager
---@param sView scrollView
---@param elements element[]
local function createSViewButton(manager, sView, official, data, elements, x, y, w, h)
    local container = sView:getContainer()
    local name = data.name
    local image = ui.element.new(container, "image", x, y, 1, h)
    if data.status == 1 then
        image.buffer.text[1] = "\21"
        image.buffer.textColor[1] = colors.orange
    elseif data.status == 2 then
        image.buffer.text[1] = "\25"
        image.buffer.textColor[1] = colors.green
    elseif data.status == 3 then
        image.buffer.text[1] = "\7"
        image.buffer.textColor[1] = colors.blue
    else
        image.buffer.text[1] = "x"
        image.buffer.textColor[1] = colors.red
    end
    image.buffer.textBackgroundColor[1] = colors.white
    local button_item = ui.button.new(container, name, theme.button3, x + 2, y, w - 5, h)

    ---@type event
    function button_item:onClick(event)
        manager.parallelManager:removeFunction(self.animation)
        manager:callFunction(
            function()
                callfile("os/sys/browser/info.lua", {term = args.term, data = data})
                updateFiles(false)
                updateSView(manager, sView)
                manager:draw()
            end
        )
    end

    table.insert(elements, button_item)
end

---@param manager uiManager
---@param sView scrollView
function updateSView(manager, sView)
    sView:clear()
    local container = sView:getContainer()
    ---@type element[]
    local elements = {}
    local x, y, w, h = 1, 2, _w - 1, 1
    for _, data in ipairs(list) do
        createSViewButton(manager, sView, true, data, elements, x, y, w, h)
        y = y + 1
    end
    local group_menu = manager.selectionManager.groups[1]
    if #elements > 0 then
        for i = 1, #elements do
            sView.selectionGroup:addElement(elements[i], nil, elements[i - 1], nil, elements[i + 1])
        end
        sView.selectionGroup.current = elements[1]
        elements[1].select.up = group_menu

        group_menu.next = sView.selectionGroup
        group_menu.previous = sView.selectionGroup
        for i = 1, #group_menu.elements do
            group_menu.elements[i].select.down = sView.selectionGroup
        end
    else
        group_menu.next = nil
        group_menu.previous = nil
        for i = 1, #group_menu.elements do
            group_menu.elements[i].select.down = nil
        end
    end

    sView:resizeContainer()
    sView:recalculate()
end
--[[
    ####################################################################################################################
    SetUp
    ####################################################################################################################
]]
local manager = ui.uiManager.new(_x, _y, _w, _h)
manager.term = args.term
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

local button_update = ui.button.new(manager, "\21", theme.button1, 1, 1, 3, 1)
local button_upload = ui.button.new(manager, "\24", theme.button1, 5, 1, 3, 1)
local button_download = ui.button.new(manager, "\25", theme.button1, 9, 1, 3, 1)
local button_sort = ui.button.new(manager, "Sort", theme.button1, _w - 11, 1, 6, 1)
local button_option = ui.button.new(manager, "\164", theme.button1, _w - 5, 1, 3, 1)
local button_exit = ui.button.new(manager, "<", theme.button2, _w - 2, 1, 3, 1)
local sView_list = ui.scrollView.new(manager, "", 3, theme.sView1, 1, 2, _w, _h - 1)

local group_menu = manager.selectionManager:addNewGroup()
group_menu:addElement(button_update, nil, nil, button_upload, sView_list.selectionGroup)
group_menu:addElement(button_upload, button_update, nil, button_download, sView_list.selectionGroup)
group_menu:addElement(button_download, button_upload, nil, button_option, sView_list.selectionGroup)
group_menu:addElement(button_option, button_download, nil, button_exit, sView_list.selectionGroup)
group_menu:addElement(button_exit, button_option, nil, nil, sView_list.selectionGroup)
group_menu.current = button_update
manager.selectionManager:addGroup(sView_list.selectionGroup)

sView_list.selectionGroup.previous = group_menu
sView_list.selectionGroup.next = group_menu

updateFiles(true)
updateSView(manager, sView_list)

function button_exit:onClick(event)
    manager:exit()
end
function button_update:onClick(event)
    manager:callFunction(
        function()
            updateFiles(true)
            updateSView(manager, sView_list)
            manager:draw()
        end
    )
end
function button_download:onClick(event)
    manager:callFunction(
        function()
            callfile("os/sys/browser/loader.lua", {term = args.term, mode = 2})
            updateFiles(false)
            updateSView(manager, sView_list)
            manager:draw()
        end
    )
end
function button_upload:onClick(event)
    manager:callFunction(
        function()
            callfile("os/sys/browser/loader.lua", {term = args.term, mode = 1})
            updateFiles(false)
            updateSView(manager, sView_list)
            manager:draw()
        end
    )
end
function button_sort:onClick(event)
    manager:callFunction(
        function()
            local buttons = {"Normal", "Name", "Status", "Version", "Type"}
            buttons[sortType] = "*" .. buttons[sortType]
            local name = callfile("os/sys/listBox.lua", {x = _w - 11, y = 1, w = 10, h = 6, label = "Sort", buttons = buttons, manager = manager})
            for i, v in ipairs(buttons) do
                if v == name then
                    sortType = i
                    sortFiles()
                    updateSView(manager, sView_list)
                    break
                end
            end
            manager:draw()
        end
    )
end

manager.selectionManager:select(sView_list.selectionGroup, "code", 3)

manager:draw()
manager:execute()
