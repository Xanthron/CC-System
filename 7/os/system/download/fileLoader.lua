--[[

]]
--[[
    ####################################################################################################################
    Variables
    ####################################################################################################################
]]
---@type integer
local _x, _y, _w, _h = 1, 1, term.getSize()
local path = nil
--[[
    ####################################################################################################################
    Functions
    ####################################################################################################################
]]
--[[
    ####################################################################################################################
    SetUp
    ####################################################################################################################
]]
local manager = ui.uiManager.new(_x, _y, _w, _h)
local index
for i = 1, _w * _h do
    if i <= _w or i > (_h - 1) * _w then
        manager.buffer.text[i] = " "
        manager.buffer.textColor[i] = colors.green
        manager.buffer.textBackgroundColor[i] = colors.green
    else
        manager.buffer.text[i] = " "
        manager.buffer.textColor[i] = colors.white
        manager.buffer.textBackgroundColor[i] = colors.white
    end
end

local label_title = ui.label.new(manager, "Download File", theme.label1, 1, 1, _w - 3, 1)
local button_exit = ui.button.new(manager, "x", nil, theme.button2, _w - 2, 1, 3, 1)
local sView_item = ui.scrollView.new(manager, "", 3, theme.sView1, 1, 2, _w, _h - 2)
local container_item = sView_item:getContainer()

local label_code = ui.label.new(container_item, "Code: ", theme.label2, 1, 2, 6)
local iField_code = ui.inputField.new(container_item, "", "", false, nil, theme.iField1, 7, 2, _w - 8, 1)

local toggle_run = ui.toggleButton.new(container_item, "Run", false, nil, theme.toggle1, 1, 4, _w - 1, 1)
local button_savePath = ui.button.new(container_item, "Path", nil, theme.button1, 1, 5, 6, 1)
local label_savePath = ui.label.new(container_item, "No Selection", theme.label2, 8, 5, _w - 9, 1)

local toggle_toList = ui.toggleButton.new(container_item, "Add to list", true, nil, theme.toggle1, 1, 7, _w - 1, 1)
local label_types = ui.label.new(container_item, "Types:", theme.label2, 3, 8, _w - 3, 1)
local toggle_desktop = ui.toggleButton.new(container_item, "Desktop", true, nil, theme.toggle1, 3, 9, _w - 3, 1)
local toggle_turtle = ui.toggleButton.new(container_item, "Turtle", true, nil, theme.toggle1, 3, 10, _w - 3, 1)
local toggle_pocket = ui.toggleButton.new(container_item, "Pocket", true, nil, theme.toggle1, 3, 11, _w - 3, 1)
local toggle_color = ui.toggleButton.new(container_item, "Need Color", false, nil, theme.toggle1, 2, 13, _w - 2, 1)
local label_name = ui.label.new(container_item, "Name:", theme.label2, 3, 15, _w - 3, 1)
local iField_name = ui.inputField.new(container_item, "", "", true, nil, theme.iField1, 3, 16, _w - 4, 1)
local label_description = ui.label.new(container_item, "Description:", theme.label2, 3, 18, _w - 3, 1)
local iField_description = ui.inputField.new(container_item, "", "", true, nil, theme.iField1, 3, 19, _w - 4, 1)
sView_item:resizeContainer()

local button_download = ui.button.new(manager, "Download", nil, theme.button1, _w - 9, _h, 10, 1)
button_download.mode = 2
button_download:recalculate()

local function checkDownloadButton(ignoreText)
    if (ignoreText or iField_code.text:len() == 8) and (not toggle_toList._checked or ((toggle_desktop._checked or toggle_pocket._checked or toggle_turtle._checked) and iField_name.text:len() > 0)) and (toggle_run._checked or path) then
        button_download.mode = 1
    else
        button_download.mode = 2
    end
    button_download:recalculate()
    button_download:repaint("this")
end

function button_exit:_onClick(event)
    manager:exit()
end

function iField_code:onTextEdit(event, ...)
    if event == "char" then
        local text = ...
        if self.text:len() < 8 then
            text = (text:match("%w") or ""):sub(1, 8 - self.text:len())
        else
            text = ""
        end
        if self.text:len() + text:len() == 8 then
            checkDownloadButton(true)
        else
            button_download.mode = 2
            button_download:recalculate()
            button_download:repaint("this")
        end

        return text
    elseif event == "delete" then
        button_download.mode = 2
        button_download:recalculate()
        button_download:repaint("this")
        return true
    end
end

function button_savePath:_onClick(event)
    manager:callFunction(
        function()
            local savePath = assert(loadfile("os/system/explorer/explorer.lua"))({mode = "save", select = event.name ~= "mouse_up"})
            if savePath then
                path = savePath
                label_savePath.text = path
                label_savePath:recalculate()
            end
            checkDownloadButton()
            manager:draw()
        end
    )
end

function toggle_toList:_onToggle(event, checked)
    if checked then
        label_types.mode = 1
        toggle_desktop.mode = 1
        toggle_turtle.mode = 1
        toggle_pocket.mode = 1
        toggle_color.mode = 1
        label_name.mode = 1
        iField_name.mode = 1
        label_description.mode = 1
        iField_description.mode = 1
    else
        label_types.mode = 2
        toggle_desktop.mode = 2
        toggle_turtle.mode = 2
        toggle_pocket.mode = 2
        toggle_color.mode = 2
        label_name.mode = 2
        iField_name.mode = 2
        label_description.mode = 2
        iField_description.mode = 2
    end
    label_types:recalculate()
    toggle_desktop:recalculate()
    toggle_turtle:recalculate()
    toggle_pocket:recalculate()
    toggle_color:recalculate()
    label_name:recalculate()
    iField_name:recalculate()
    label_description:recalculate()
    iField_description:recalculate()
    checkDownloadButton()
    manager:repaint("this")
end

function toggle_run:_onToggle(event, checked)
    if checked then
        label_savePath.mode = 2
        button_savePath.mode = 2
    else
        label_savePath.mode = 1
        button_savePath.mode = 1
    end
    label_savePath:recalculate()
    button_savePath:recalculate()
    label_savePath:repaint("this")
    button_savePath:repaint("this")
    checkDownloadButton()
end

function button_download:_onClick(event)
    manager:callFunction(
        function()
            if toggle_toList._checked then
                local types = {}
                if toggle_desktop._checked then
                    table.insert(types, "d")
                end
                if toggle_turtle._checked then
                    table.insert(types, "t")
                end
                if toggle_pocket._checked then
                    table.insert(types, "p")
                end
                local path = path
                if toggle_run._checked then
                    path = "run"
                end

                local data = {name = iField_name.text, description = iField_description.text, color = toggle_color._checked, type = table.concat(types, ""), url = iField_code.text, path = path}

                local datas = dofile("os/system/download/unofficial")
                for i, v in ipairs(datas) do
                    if v.name == iField_name.text then
                        table.remove(datas, i)
                        break
                    end
                end
                table.insert(datas, data)

                assets.variables.save("os/system/download/unofficial", datas)
            end
            manager:draw()
        end
    )
end

-- local group_menu = manager.selectionManager:addNewGroup()
-- group_menu:addElement(button_update, nil, nil, button_upload, sView_list.selectionGroup)
-- group_menu:addElement(button_upload, button_update, nil, button_download, sView_list.selectionGroup)
-- group_menu:addElement(button_download, button_upload, nil, button_option, sView_list.selectionGroup)
-- group_menu:addElement(button_option, button_download, nil, button_exit, sView_list.selectionGroup)
-- group_menu:addElement(button_exit, button_option, nil, nil, sView_list.selectionGroup)
-- group_menu.current = button_update
-- manager.selectionManager:addGroup(sView_list.selectionGroup)

-- sView_list.selectionGroup.previous = group_menu
-- sView_list.selectionGroup.next = group_menu

manager:draw()
manager:execute()
sleep(10)
