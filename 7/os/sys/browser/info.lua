local args = ...
local data = args.data
local term = ui.input.term
local _x, _y, _w, _h = 1, 1, term.getSize()

local function downloadScreen(...)
    callfile("os/sys/wait.lua", "Downloading", ...)
end

local input = ui.input.new()
local drawer = ui.drawer.new(input, _x, _y, _w, _h)
ui.buffer.fill(drawer.buffer, " ", colors.white, colors.white)

local types = {}
if data.type:find("d") then
    table.insert(types, "Desktop")
end
if data.type:find("t") then
    table.insert(types, "Turtle")
end
if data.type:find("p") then
    table.insert(types, "Pocket")
end
if #types == 0 then
    table.insert(types, "Desktop")
    table.insert(types, "Turtle")
    table.insert(types, "Pocket")
end
if data.color then
    table.insert(types, "Color", 1)
end

local versionText = table.concat(data.version or {"No Version"}, ".")
if data.versionOld then
    versionText = versionText .. " (" .. table.concat(data.versionOld, ".") .. ")"
end

local tBox_info = ui.textBox.new(drawer, "", ("%s\n\nCategory:\n%s\n\nType:\n%s\n\nVersion:\n%s\n\nSource:\n%s"):format(IF(data.description and data.description ~= "", data.description, "No Description."), IF(data.category and data.category ~= "", data.category, "Non."), table.concat(types, ", "), versionText, data.url), theme.tBox2, _x, _y, _w, _h)

local label_title = ui.label.new(tBox_info, data.name, theme.label1, 1, 1, _w - 3, 1)
local button_exit = ui.button.new(tBox_info, "<", theme.button2, _w - 2, 1, 3, 1)
local label_bottom = ui.label.new(tBox_info, "", theme.label1, 1, _h, _w, 1)

local button_delete = ui.button.new(tBox_info, "Delist", theme.button1, 1, _h, 8, 1)
if not data.delete then
    button_delete.mode = 2
    button_delete:recalculate()
end
local button_remove = ui.button.new(tBox_info, "Delete", theme.button1, _w - 16, _h, 8, 1)
local type_do = "Install"
if data.status == 1 then
    type_do = "Update"
elseif data.status == 2 then
    type_do = "Restore"
else
    button_remove.mode = 2
    button_remove:recalculate()
end
local button_do = ui.button.new(tBox_info, type_do, theme.button1, _w - type_do:len() - 1, _h, type_do:len() + 2, 1)

local group_menu = drawer.selectionManager:addNewGroup()
local group_tBox = tBox_info.selectionGroup
drawer.selectionManager:addGroup(group_tBox)

group_menu:addElement(button_delete, nil, nil, button_exit, group_tBox)
group_menu:addElement(button_exit, button_delete, nil, nil, group_tBox)
group_tBox:addElement(button_delete, nil, group_menu, button_do, nil)
group_tBox:addElement(button_do, button_delete, group_menu, nil, nil)

group_menu.current = button_exit
drawer.selectionManager:select(button_do, "code", 3)

function button_exit:onClick(event)
    input:exit()
end

function button_delete:onClick(event)
    input:callFunction(
        function()
            local path = "os/sys/browser/data/unofficial"
            local list = dofile(path)
            for i, v in ipairs(list) do
                if v.name == data.name then
                    table.remove(list, i)
                    break
                end
            end
            table.save(list, path)
            callfile("os/sys/infoBox.lua", {label = "Information", text = data.name .. " is now deleted from the unofficial download list", x = _x + 2, y = _y + 2, w = _w - 4, h = _h - 4, button1 = "Ok", select = event.name ~= "mouse_up"})
            input:exit()
        end
    )
end

function button_remove:onClick(event)
    input:callFunction(
        function()
            local delete = data.deleteOld or data.delete
            if type(delete) == "table" then
                for i, v in ipairs(delete) do
                    if fs.exists(v) then
                        fs.delete(v)
                    end
                end
            else
                if fs.exists(delete) then
                    fs.delete(delete)
                end
            end
            callfile("os/sys/browser/install.lua", 2, data)
            callfile("os/sys/infoBox.lua", {label = "Information", text = data.name .. " is now deleted from the system.", x = _x + 2, y = _y + 2, w = _w - 4, h = _h - 4, button1 = "Ok", select = event.name ~= "mouse_up"})
            input:exit()
        end
    )
end

function button_do:onClick(event)
    input:callFunction(
        function()
            local success, content, text
            local needsReboot = false
            downloadScreen(
                function()
                    if data.path == "run" then
                        local reboot = os.reboot
                        os.reboot = function()
                            needsReboot = true
                        end
                        if data.url:len() == 8 then
                            success, content = www.pasteBinRun(data.url)
                        else
                            success, content = www.run(data.url)
                        end
                        text = ("%s has now run.\n"):format(data.name)
                        if needsReboot then
                            text = text .. "System needs a reboot."
                        end
                        os.reboot = reboot
                    else
                        if data.url:len() == 8 then
                            success, content = www.pasteBinSave(data.url, data.path, true)
                        else
                            success, content = www.save(data.url, data.path, true)
                        end
                        text = ("%s is now installed to the system.\n\nPath:\n%s\n"):format(data.name, data.path)
                    end
                end
            )
            if success then
                callfile("os/sys/browser/install.lua", 1, data)
                callfile("os/sys/infoBox.lua", {label = "Information", text = text, x = _x + 2, y = _y + 2, w = _w - 4, h = _h - 4, button1 = "Ok", select = event.name ~= "mouse_up"})
                if needsReboot then
                    os.reboot()
                end
            else
                callfile("os/sys/infoBox.lua", {label = "Information", text = data.name .. " failed to download.\n\nReason:\n" .. content, x = _x + 2, y = _y + 2, w = _w - 4, h = _h - 4, button1 = "Ok", select = event.name ~= "mouse_up"})
            end
            input:exit()
        end
    )
end

drawer:draw()
input:eventLoop({[term] = drawer.event})
