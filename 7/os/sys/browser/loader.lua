--[[
    ####################################################################################################################
    Variables
    ####################################################################################################################
]]
local args = ...
local mode, file = args.mode, args.file
---@type integer
local _x, _y, _w, _h = 1, 1, term.getSize()
local pathSave, pathUpload = args.savePath, args.filePath
--[[
    ####################################################################################################################
    Functions
    ####################################################################################################################
]]
local function loadScreen(label, ...)
    assert(loadfile("os/sys/wait.lua"))(label, ...)
end
--[[
    ####################################################################################################################
    SetUp
    ####################################################################################################################
]]
local manager, index = ui.uiManager.new(_x, _y, _w, _h), nil
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

if mode == "upload" then
    mode = "Upload"
else
    mode = "Download"
end

local label_title = ui.label.new(manager, mode .. " File", theme.label1, 1, 1, _w - 3, 1)
local button_exit = ui.button.new(manager, "<", theme.button2, _w - 2, 1, 3, 1)
local sView_item = ui.scrollView.new(manager, "", 3, theme.sView1, 1, 2, _w, _h - 2)
local container_item = sView_item:getContainer()

local y = 2

local label_code, element_code, button_uploadPath, label_uploadPath, button_copy
if mode == "Upload" then
    element_code = ui.label.new(container_item, "", theme.label2, 7, y, _w - 8, 1)
    label_code = ui.label.new(container_item, "File: ", theme.label2, 1, y, 6)
    y = y + 1
    button_uploadPath = ui.button.new(container_item, "Path", theme.button1, 1, y, 6, 1)
    label_uploadPath = ui.label.new(container_item, "No Selection", theme.label2, 8, y, _w - 9, 1)
    if file then
        button_uploadPath.mode = 2
        label_uploadPath.text = "File passed."
        button_uploadPath:recalculate()
        label_uploadPath:recalculate()
    end
    y = y + 2
else
    label_code = ui.label.new(container_item, "Code: ", theme.label2, 1, y, 6)
    element_code = ui.inputField.new(container_item, "", "", false, theme.iField1, 7, y, _w - 8, 1)
    y = y + 2
end

local toggle_run = ui.toggleButton.new(container_item, "Run", args.run or false, theme.toggle1, 1, y, _w - 1, 1)
y = y + 1
local button_savePath = ui.button.new(container_item, "Path", theme.button1, 1, y, 6, 1)
local label_savePath = ui.label.new(container_item, "No Selection", theme.label2, 8, y, _w - 9, 1)
y = y + 2
local toggle_toList = ui.toggleButton.new(container_item, "Add to list", true, theme.toggle1, 1, y, _w - 1, 1)
y = y + 1
local label_types = ui.label.new(container_item, "Types:", theme.label2, 3, y, _w - 3, 1)
y = y + 1
local toggle_desktop = ui.toggleButton.new(container_item, "Desktop", true, theme.toggle1, 3, y, _w - 3, 1)
y = y + 1
local toggle_turtle = ui.toggleButton.new(container_item, "Turtle", true, theme.toggle1, 3, y, _w - 3, 1)
y = y + 1
local toggle_pocket = ui.toggleButton.new(container_item, "Pocket", true, theme.toggle1, 3, y, _w - 3, 1)
y = y + 2
local toggle_color = ui.toggleButton.new(container_item, "Need Color", false, theme.toggle1, 2, y, _w - 2, 1)
y = y + 2
local label_name = ui.label.new(container_item, "Name:", theme.label2, 3, y, _w - 3, 1)
y = y + 1
local iField_name = ui.inputField.new(container_item, "", args.name or "", false, theme.iField1, 3, y, _w - 4, 1)
y = y + 2
local label_description = ui.label.new(container_item, "Description:", theme.label2, 3, y, _w - 3, 1)
y = y + 1
local iField_description = ui.inputField.new(container_item, "", "", true, theme.iField1, 3, y, _w - 4, 5)

local button_load = ui.button.new(manager, mode, theme.button1, _w - 9, _h, 10, 1)
button_load.mode = 2
button_load:recalculate()

sView_item:resetLayout()
sView_item:recalculate()

local group_menu = manager.selectionManager:addNewGroup()
manager.selectionManager:addGroup(sView_item.selectionGroup)
local group_list = sView_item.selectionGroup
local group_download = manager.selectionManager:addNewGroup()
if mode == "Upload" then
    group_menu:addElement(button_exit, nil, nil, nil, button_uploadPath)
    group_list:addElement(button_uploadPath, nil, button_exit, nil, toggle_run)
    group_list:addElement(toggle_run, nil, button_uploadPath, nil, button_savePath)
else
    group_menu:addElement(button_exit, nil, nil, nil, element_code)
    group_list:addElement(element_code, nil, button_exit, nil, toggle_run)
    group_list:addElement(toggle_run, nil, element_code, nil, button_savePath)
end
group_list:addElement(button_savePath, nil, toggle_run, nil, toggle_toList)
group_list:addElement(toggle_toList, nil, button_savePath, nil, toggle_desktop)
group_list:addElement(toggle_desktop, nil, toggle_toList, nil, toggle_turtle)
group_list:addElement(toggle_turtle, nil, toggle_desktop, nil, toggle_pocket)
group_list:addElement(toggle_pocket, nil, toggle_turtle, nil, toggle_color)
group_list:addElement(toggle_color, nil, toggle_pocket, nil, iField_name)
group_list:addElement(iField_name, nil, toggle_color, nil, iField_description)
group_list:addElement(iField_description, nil, iField_name, nil, button_load)
group_download:addElement(button_load, nil, iField_description, nil, nil)

local function checkDownloadButton(codeText, nameText)
    if (mode == "Upload" or (codeText or element_code.text:len() - 7) == 1) and (mode ~= "Upload" or pathUpload or file) and (not toggle_toList._checked or ((toggle_desktop._checked or toggle_pocket._checked or toggle_turtle._checked) and (nameText or iField_name.text:len()) > 0)) and (toggle_run._checked or pathSave) then
        button_load.mode = 1
    else
        button_load.mode = 2
    end
    button_load:recalculate()
    button_load:repaint("this")
end

function button_exit:onClick(event)
    manager:exit()
end

if mode == "Upload" then
    function button_uploadPath:onClick(event)
        manager:callFunction(
            function()
                local wasSame = pathUpload == pathSave
                local path = ""
                if pathUpload then
                    path = fs.getDir(pathUpload)
                end
                path = assert(loadfile("os/sys/explorer/main.lua"))({mode = "select_one", path = path, edit = false, select = event.name ~= "mouse_up"})
                if path then
                    pathUpload = path
                    label_uploadPath.text = pathUpload
                    label_uploadPath:recalculate()
                    if wasSame then
                        if pathSave then
                            wasSame = iField_name.text == textutils.getNeatName(pathSave)
                        else
                            wasSame = true
                        end
                        pathSave = path
                        label_savePath.text = pathUpload
                        label_savePath:recalculate()
                        if wasSame then
                            iField_name:setText(textutils.getNeatName(pathSave))
                            iField_name:recalculate()
                            iField_name:repaint("this")
                        end
                    end
                end
                checkDownloadButton()
                manager:draw()
            end
        )
    end
else
    function element_code:onTextEdit(event, ...)
        if event == "char" or event == "paste" then
            local var1 = ...
            if self.text:len() < 8 then
                var1 = (var1:match("%w*") or ""):sub(1, 8 - self.text:len())
            else
                var1 = ""
            end
            if self.text:len() + var1:len() == 8 then
                checkDownloadButton(1)
            else
                button_load.mode = 2
                button_load:recalculate()
                button_load:repaint("this")
            end

            return var1
        elseif event == "delete" then
            button_load.mode = 2
            button_load:recalculate()
            button_load:repaint("this")
            return true
        end
    end
end

function button_savePath:onClick(event)
    manager:callFunction(
        function()
            local path = ""
            local name = ""
            if pathSave then
                name = fs.getName(pathSave)
                path = fs.getDir(pathSave)
            end
            path =
                assert(loadfile("os/sys/explorer/main.lua"))(
                {
                    mode = "save",
                    save = name,
                    path = path,
                    edit = false,
                    override = true,
                    select = event.name ~= "mouse_up"
                }
            )
            if path then
                local wasSame = true
                if pathSave then
                    wasSame = iField_name.text == textutils.getNeatName(pathSave)
                end
                pathSave = path
                label_savePath.text = pathSave
                label_savePath:recalculate()
                if wasSame then
                    iField_name:setText(textutils.getNeatName(pathSave))
                    iField_name:recalculate()
                    iField_name:repaint("this")
                end
            end
            checkDownloadButton()
            manager:draw()
        end
    )
end

function toggle_toList:onToggle(event, checked)
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

function toggle_desktop:onToggle(event, checked)
    checkDownloadButton()
end
function toggle_turtle:onToggle(event, checked)
    checkDownloadButton()
end
function toggle_pocket:onToggle(event, checked)
    checkDownloadButton()
end

function toggle_run:onToggle(event, checked)
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

function iField_name:onTextEdit(event, ...)
    if event == "char" then
        checkDownloadButton(nil, 1)
        return ...
    elseif event == "delete" then
        if self.text:len() <= 1 then
            checkDownloadButton(nil, 0)
        end
    end
end

function button_load:onClick(event)
    manager:callFunction(
        function()
            local code = element_code.text
            local success, content, text

            if mode == "Upload" then
                local fileText
                if file then
                    fileText = file
                else
                    local file = fs.open(pathUpload, "r")
                    fileText = file.readAll()
                    file:close()
                end

                loadScreen(
                    "Upload",
                    function()
                        success, content = www.pasteBinPut(fileText)
                    end
                )
                if content:len() ~= 8 then
                    success = false
                end
                if success then
                    code = content
                    element_code.text = code
                    element_code:recalculate()
                    text = ("Uploading from\n%s\nto: %s\n"):format(pathUpload or "Program", code)
                else
                    text = ("Uploading  %s from\n%s\n"):format(pathUpload)
                end
            else
                loadScreen(
                    "Download",
                    function()
                        if toggle_run._checked then
                            success, content = www.pasteBinRun(code)
                            text = ("Run %s "):format(code)
                        else
                            success, content = www.pasteBinSave(code, pathSave, true)
                            text = ("Save %s at\n%s\n"):format(code, pathSave)
                        end
                    end
                )
            end

            if success then
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
                    local path = pathSave
                    if toggle_run._checked then
                        path = "run"
                    end

                    local data = {
                        name = iField_name.text,
                        description = iField_description.text,
                        color = toggle_color._checked,
                        type = table.concat(types, ""),
                        url = code,
                        path = path
                    }

                    local datas = dofile("os/sys/browser/unofficial")
                    for i, v in ipairs(datas) do
                        if v.name == iField_name.text then
                            table.remove(datas, i)
                            break
                        end
                    end
                    table.insert(datas, data)

                    table.save(datas, "os/sys/browser/unofficial")
                end
                --error("lol")
                assert(loadfile("os/sys/infoBox.lua"))(
                    {
                        x = _x + 2,
                        y = _y + 2,
                        w = _w - 4,
                        h = _h - 4,
                        text = ("%sSucceeded"):format(text),
                        label = mode,
                        select = true,
                        button1 = "Ok"
                    }
                )
            else
                assert(loadfile("os/sys/infoBox.lua"))(
                    {
                        x = _x + 2,
                        y = _y + 2,
                        w = _w - 4,
                        h = _h - 4,
                        text = ("%sFailed\n\n%s"):format(text, content),
                        label = mode,
                        select = true,
                        button1 = "Ok"
                    }
                )
            end
            manager:draw()
        end
    )
end

if mode == "Upload" then
    manager.selectionManager:select(button_uploadPath, "code", 3)
else
    manager.selectionManager:select(element_code, "code", 3)
end
manager:draw()
manager:execute()
