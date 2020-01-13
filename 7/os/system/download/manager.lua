--[[
    Fetchers:
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
local defaultPasteBin = "ZbWvc7x9"
---@type integer
local _x, _y, _w, _h = 1, 1, term.getSize()
---@type table
local official, unofficial, updateSView
--[[
    ####################################################################################################################
    Functions
    ####################################################################################################################
]]
local function downloadScreen(...)
    assert(loadfile("os/system/wait.lua"))("Downloading", ...)
end

local function updateFiles()
    local success, content = www.pasteBinSave(defaultPasteBin, "os/system/download/official", true)
    if success then
        official = dofile("os/system/download/official")
    else
        official = {}
    end
    unofficial = dofile("os/system/download/unofficial")
end

---@param manager uiManager
---@param sView scrollView
---@param elements element[]
local function createSViewButton(manager, sView, official, data, elements, x, y, w, h)
    local container = sView:getContainer()
    local name = data.name
    local image = ui.element.new(container, "image", x, y, 1, h)
    if (data.type == "all" or (pocket and data.type:find("p")) or (turtle and data.type:find("t")) or data.type:find("d")) and (term.isColor() or not data.color) then
        image.buffer.text[1] = "\7"
        image.buffer.textColor[1] = colors.green
        image.buffer.textBackgroundColor[1] = colors.white
    else
        image.buffer.text[1] = "<"
        image.buffer.textColor[1] = colors.red
        image.buffer.textBackgroundColor[1] = colors.white
    end
    local button_item = ui.button.new(container, name, nil, theme.button3, x + 2, y, w - 5, h)
    local button_info = ui.button.new(container, "i", nil, theme.button4, x + w - 3, y, 3, h)

    ---@type event
    function button_item:_onClick(event)
        manager:callFunction(
            function()
                local success, content, text
                downloadScreen(
                    function()
                        if data.path == "run" then
                            if data.url:len() == 8 then
                                success, content = www.pasteBinRun(data.url)
                            else
                                success, content = www.run(data.url)
                            end
                            text = ("Run\n%s\n"):format(data.name)
                        else
                            if data.url:len() == 8 then
                                success, content = www.pasteBinSave(data.url, data.path, true)
                            else
                                success, content = www.save(data.url, data.path, true)
                            end
                            text = ("Save\n%s\nat\n%s\n"):format(data.name, data.path)
                        end
                    end
                )
                if success then
                    text = text .. "Succeeded."
                    assert(loadfile("os/system/infoBox.lua"))({label = "Information", text = text, x = _x + 2, y = _y + 2, w = _w - 4, h = _h - 4, button1 = "Ok", select = event.name ~= "mouse_up"})
                else
                    text = text .. "failed.\n\n" .. content
                    assert(loadfile("os/system/infoBox.lua"))({label = "Information", text = text, x = _x + 2, y = _y + 2, w = _w - 4, h = _h - 4, button1 = "Ok", select = event.name ~= "mouse_up"})
                end
                manager:draw()
            end
        )
    end

    ---@type event
    function button_info:_onClick(event)
        local color = "no"
        if data.color then
            color = "yes"
        end
        local types = {}
        if data.type:find("d") then
            table.insert(types, "desktop")
        end
        if data.type:find("t") then
            table.insert(types, "turtle")
        end
        if data.type:find("p") then
            table.insert(types, "pocket")
        end
        if #types == 0 then
            table.insert(types, "all")
        end
        local text = string.format("%s\n\n%s\n\nColor: %s\n Type:  %s\n\n\nSource:\n%s", name, data.description, color, table.concat(types, ", "), data.url)
        local button2
        if not official then
            button2 = "Remove"
        end
        manager.parallelManager:removeFunction(self._pressAnimation)
        manager:callFunction(
            function()
                local number, select = assert(loadfile("os/system/infoBox.lua"))({label = "Information", text = text, x = _x + 2, y = _y + 2, w = _w - 4, h = _h - 4, button1 = "Ok", button2 = button2, select = event.name ~= "mouse_up"})
                if number == 2 then
                    for i = 1, #unofficial do
                        if unofficial[i] == data then
                            table.remove(unofficial, i)
                            break
                        end
                    end
                    assets.variables.save("os/system/download/unofficial", unofficial)
                    updateSView(manager, sView)
                end
                manager:draw()
            end
        )
    end

    table.insert(elements, button_item)
    table.insert(elements, button_info)
end

---@param manager uiManager
---@param sView scrollView
function updateSView(manager, sView)
    sView:clear()
    local container = sView:getContainer()
    ---@type element[]
    local elements = {}
    local x, y, w, h = 1, 2, _w - 1, 1
    for _, data in ipairs(official) do
        createSViewButton(manager, sView, true, data, elements, x, y, w, h)
        y = y + 1
    end
    if #official > 0 and #unofficial > 0 then
        local element = ui.element.new(container, "image", x, y, w, h)
        for i = 1, w do
            element.buffer.text[i] = "-"
            element.buffer.textColor[i] = colors.lightGray
            element.buffer.textBackgroundColor[i] = colors.white
        end
        y = y + 1
    end
    for _, data in ipairs(unofficial) do
        createSViewButton(manager, sView, false, data, elements, x, y, w, h)
        y = y + 1
    end
    local group_menu = manager.selectionManager.groups[1]
    if #elements > 0 then
        for i = 1, #elements, 2 do
            sView.selectionGroup:addElement(elements[i], nil, elements[i - 2], elements[i + 1], elements[i + 2])
            sView.selectionGroup:addElement(elements[i + 1], elements[i], elements[i - 1], nil, elements[i + 3])
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

    sView:recalculate()
end
--[[
    ####################################################################################################################
    SetUp
    ####################################################################################################################
]]
local manager = ui.uiManager.new(_x, _y, _w, _h)
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

local button_update = ui.button.new(manager, "\21", nil, theme.button1, 1, 1, 3, 1)
local button_upload = ui.button.new(manager, "\24", nil, theme.button1, 5, 1, 3, 1)
local button_download = ui.button.new(manager, "\25", nil, theme.button1, 9, 1, 3, 1)
local button_option = ui.button.new(manager, "\164", nil, theme.button1, _w - 5, 1, 3, 1)
local button_exit = ui.button.new(manager, "x", nil, theme.button2, _w - 2, 1, 3, 1)
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

downloadScreen(updateFiles)
updateSView(manager, sView_list)

function button_exit:_onClick(event)
    manager:exit()
end
function button_update:_onClick(event)
    manager:callFunction(
        function()
            downloadScreen(updateFiles)
            updateSView(manager, sView_list)
            manager:draw()
        end
    )
end
function button_download:_onClick(event)
    manager:callFunction(
        function()
            assert(loadfile("os/system/download/fileLoader.lua"))({mode = "download"})
            unofficial = dofile("os/system/download/unofficial")
            updateSView(manager, sView_list)
            manager:draw()
        end
    )
end
function button_upload:_onClick(event)
    manager:callFunction(
        function()
            assert(loadfile("os/system/download/fileLoader.lua"))({mode = "upload"})
            unofficial = dofile("os/system/download/unofficial")
            updateSView(manager, sView_list)
            manager:draw()
        end
    )
end

manager.selectionManager:select(sView_list.selectionGroup, "code", 3)

manager:draw()
manager:execute()
