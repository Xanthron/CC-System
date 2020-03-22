local term = ui.input.term
--[[
    ####################################################################################################################
    Variables
    ####################################################################################################################
]]
local args = ...

---@type integer
local _x, _y, _w, _h = 1, 1, term.getSize()
local mode = args.mode
--[[
    ####################################################################################################################
    Functions
    ####################################################################################################################
]]
local function loadScreen(label, ...)
    ui.wait(label, ...)
end

local modeName = IF(mode == 1, "Upload", "Download")

--[[
    ####################################################################################################################
    SetUp
    ####################################################################################################################
]]
local input = ui.input.new()
local drawer, index = ui.drawer.new(input, _x, _y, _w, _h), nil
for i = 1, _w * _h do
    if i <= _w or i > (_h - 1) * _w then
        drawer.buffer.text[i] = " "
        drawer.buffer.textColor[i] = colors.green
        drawer.buffer.textBackgroundColor[i] = colors.green
    else
        drawer.buffer.text[i] = " "
        drawer.buffer.textColor[i] = colors.white
        drawer.buffer.textBackgroundColor[i] = colors.white
    end
end

local label_title = ui.label.new(drawer, modeName .. " File", theme.label1, 1, 1, _w - 3, 1)
local button_exit = ui.button.new(drawer, "<", theme.button2, _w - 2, 1, 3, 1)
local sView_item = ui.scrollView.new(drawer, "", 3, theme.sView1, 1, 2, _w, _h - 2)
local container_item = sView_item:getContainer()

local y = 2

local iField_code, label_code
if mode == 1 then
    label_code = ui.label.new(drawer, "", theme.label1, 1, _h, _w - 8, 1)
else
    label_code = ui.label.new(container_item, "Code:", theme.label2, 1, y, 6)
    iField_code = ui.inputField.new(container_item, nil, "", false, theme.iField2, 7, y, _w - 8, 1)
    y = y + 2
end

local label_file = ui.label.new(container_item, IF(mode == 1, "File Path:", "Save Path:"), theme.label2, 1, y, _w - 1)
y = y + 1
local button_path = ui.button.new(container_item, "Path", theme.button1, 1, y, 6, 1)
local label_path = ui.label.new(container_item, "No Selection", theme.label2, 8, y, _w - 9, 1)
if args.file then
    button_path.mode = 2
    label_path.text = "File passed."
    button_path:recalculate()
    label_path:recalculate()
end
y = y + 2
local toggle_toList = ui.toggle.new(container_item, "Add to list", true, theme.toggle1, 1, y, _w - 1, 1)
y = y + 1
local label_types = ui.label.new(container_item, "Types:", theme.label2, 3, y, _w - 3, 1)
y = y + 1
local toggle_desktop = ui.toggle.new(container_item, "Desktop", true, theme.toggle1, 3, y, _w - 3, 1)
y = y + 1
local toggle_turtle = ui.toggle.new(container_item, "Turtle", true, theme.toggle1, 3, y, _w - 3, 1)
y = y + 1
local toggle_pocket = ui.toggle.new(container_item, "Pocket", true, theme.toggle1, 3, y, _w - 3, 1)
y = y + 2
local toggle_color = ui.toggle.new(container_item, "Need Color", false, theme.toggle1, 2, y, _w - 2, 1)
y = y + 2
local iField_name = ui.inputField.new(container_item, "Name", args.name or "", false, theme.iField1, 3, y, _w - 4, 3)
y = y + 4
local iField_version = ui.inputField.new(container_item, "Version", args.version or "", false, theme.iField1, 3, y, _w - 4, 3)
y = y + 4
local iField_category = ui.inputField.new(container_item, "Category", args.version or "", false, theme.iField1, 3, y, _w - 4, 3)
y = y + 4
local iField_description = ui.inputField.new(container_item, "Description", "", true, theme.iField1, 3, y, _w - 4, 7)

local button_load = ui.button.new(drawer, modeName, theme.button1, _w - 9, _h, 10, 1)
button_load.mode = 2
button_load:recalculate()

--local label_code = ui.label.new(drawer, "", theme.label1, 1, _h, _w - 8, 1)

sView_item:resetLayout()
sView_item:recalculate()

local group_menu = drawer.selectionManager:addNewGroup()
drawer.selectionManager:addGroup(sView_item.selectionGroup)
local group_list = sView_item.selectionGroup
local group_download = drawer.selectionManager:addNewGroup()
if mode == 1 then
    group_menu:addElement(button_exit, nil, nil, nil, button_path)
    group_list:addElement(button_path, nil, button_exit, nil, toggle_toList)
else
    group_menu:addElement(button_exit, nil, nil, nil, iField_code)
    group_list:addElement(iField_code, nil, button_exit, nil, button_path)
    group_list:addElement(button_path, nil, iField_code, nil, toggle_toList)
end

group_list:addElement(toggle_toList, nil, button_path, nil, toggle_desktop)
group_list:addElement(toggle_desktop, nil, toggle_toList, nil, toggle_turtle)
group_list:addElement(toggle_turtle, nil, toggle_desktop, nil, toggle_pocket)
group_list:addElement(toggle_pocket, nil, toggle_turtle, nil, toggle_color)
group_list:addElement(toggle_color, nil, toggle_pocket, nil, iField_name)
group_list:addElement(iField_name, nil, toggle_color, nil, iField_version)
group_list:addElement(iField_version, nil, iField_name, nil, iField_category)
group_list:addElement(iField_category, nil, iField_version, nil, iField_description)
group_list:addElement(iField_description, nil, iField_category, nil, button_load)
group_download:addElement(button_load, nil, iField_description, nil, nil)

local function checkDownloadButton(codeText, nameText, versionText)
    if (args.run or args.path) and (toggle_toList._checked == false or ((toggle_desktop._checked or toggle_pocket._checked or toggle_turtle._checked) and (nameText or iField_name.text:len() > 0) and #textutils.split(versionText or iField_version.text, "[^%.]+") == 3)) then
        button_load.mode = 1
    else
        button_load.mode = 2
    end
    button_load:recalculate()
    button_load:repaint("this")
end

function button_exit:onClick(event)
    input:exit()
end

if mode == 2 then
    function iField_code:onTextEdit(event, ...)
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
                button_load:changeMode(2)
            end

            return var1
        elseif event == "delete" then
            button_load:changeMode(2)
            return true
        end
    end
end

function button_path:onClick(event)
    input:callFunction(
        function()
            local changeName = textutils.getNeatName(args.path or "") == iField_name.text or iField_name.text:len() == 0
            local path = ""
            if args.path then
                path = fs.getDir(args.path)
            end
            path = callfile("os/sys/explorer/main.lua", IF(mode == 1, {mode = "select_one", path = path, edit = false, select = event.name ~= "mouse_up"}, {mode = "save", save = iField_name.text, override = true, path = path, edit = false, select = event.name ~= "mouse_up"}))
            if path then
                args.path = path
                label_path.text = path
                label_path:recalculate()
                if changeName then
                    iField_name:setText(textutils.getNeatName(path))
                    iField_name:recalculate()
                    iField_name:repaint("this")
                end
            end
            checkDownloadButton()
            drawer:draw()
        end
    )
end

function toggle_toList:onToggle(event, checked)
    local m = 2
    if checked then
        m = 1
    end
    label_types:changeMode(m, true)
    toggle_desktop:changeMode(m, true)
    toggle_turtle:changeMode(m, true)
    toggle_pocket:changeMode(m, true)
    toggle_color:changeMode(m, true)
    iField_name:changeMode(m, true)
    iField_version:changeMode(m, true)
    iField_category:changeMode(m, true)
    iField_description:changeMode(m, true)
    checkDownloadButton()
    drawer:draw()
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

function iField_version:onTextEdit(event, ...)
    if event == "char" then
        local c = ...
        if ((c == "." and self.text:gsub("[^%.]+", ""):len() < 2) or tonumber(c) ~= nil) and c ~= "-" then
            checkDownloadButton(nil, nil, self.text .. c)
            return c
        end
        return ""
    elseif event == "delete" then
        if self.text:len() <= 1 then
            checkDownloadButton(nil, nil, self.text:sub(1, self.text:len() - 1))
        end
    end
end

function button_load:onClick(event)
    input:callFunction(
        function()
            local success, content, text, code

            if mode == 1 then
                local fileText
                if args.file then
                    fileText = args.file
                else
                    local file = fs.open(args.path, "r")
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
                    label_code.text = code
                    label_code:recalculate()
                    text = ("Uploading from\n%s\nto: %s\n"):format(args.path or "Program", code)
                else
                    text = ("Uploading  %s from\n%s\n"):format(args.path)
                end
            else
                code = iField_code.text
                loadScreen(
                    modeName,
                    function()
                        success, content = www.pasteBinSave(code, args.path, true)
                        text = ("Save %s at\n%s\n"):format(code, args.path)
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
                    local version = textutils.split(iField_version.text, "[^%.]+")
                    for i = 1, #version do
                        version[i] = tonumber(version[i])
                    end
                    local data = {
                        name = iField_name.text,
                        description = iField_description.text,
                        color = toggle_color._checked,
                        type = table.concat(types, ""),
                        url = code,
                        path = args.path or "run",
                        delete = args.path or args.delete,
                        category = iField_category.text,
                        version = version
                    }

                    local datas = dofile("os/sys/browser/data/unofficial")
                    for i, v in ipairs(datas) do
                        if v.name == iField_name.text then
                            table.remove(datas, i)
                            break
                        end
                    end
                    table.insert(datas, data)

                    table.save(datas, "os/sys/browser/data/unofficial")
                    callfile("os/sys/browser/install.lua", 1, data)
                end
                --error("lol")
                callfile("os/sys/infoBox.lua", {x = _x + 2, y = _y + 2, w = _w - 4, h = _h - 4, text = ("%sSucceeded"):format(text), label = modeName, select = true, button1 = "Ok"})
            else
                callfile("os/sys/infoBox.lua", {x = _x + 2, y = _y + 2, w = _w - 4, h = _h - 4, text = ("%sFailed\n\n%s"):format(text, content), label = modeName, select = true, button1 = "Ok"})
            end
            drawer:draw()
        end
    )
end

if mode == 1 then
    drawer.selectionManager:select(button_path, "code", 3)
else
    drawer.selectionManager:select(iField_code, "code", 3)
end
drawer:draw()
input:eventLoop({[term] = drawer.event})
--sleep(10)
