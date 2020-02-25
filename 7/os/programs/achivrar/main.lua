local _x, _y, _w, _h = 1, 1, term.getSize()
local selected = {}
local savePath = "/"
local code = ""

local function pathsToText(paths, compress)
    local files = {}
    for i = 1, #paths do
        if fs.exists(paths[i]) then
            local handler = io.open(paths[i], "r")
            local lines = {}
            for line in handler:lines() do
                table.insert(lines, line)
            end
            handler:close()
            local text = table.concat(lines, "\n")
            if tostring(compress):lower() == "true" then
                text = text .. "\n"
                local s = {}
                local d = {}
                local emptySpace = function(t)
                    return t:sub(1, 1) .. t:sub(t:len())
                end
                text =
                    text:gsub('\\"', "d" .. "@"):gsub("\\'", "s" .. "@"):gsub(
                    '"[^\n\r]-"',
                    function(t)
                        table.insert(d, t)
                        return ("d%s" .. "@"):format(#d)
                    end
                ):gsub(
                    "'[^\n\r]-'",
                    function(t)
                        table.insert(s, t)
                        return ("s%s" .. "@"):format(#s)
                    end
                ):gsub("%-%-[^\n]+%[%[", "--"):gsub("%-%-%[%[.-%]%]+", ""):gsub("%-%-.-\n+", "\n"):gsub("\n%s+", "\n"):gsub(
                    "[%a%d_]%s[^%a%d_]",
                    emptySpace
                ):gsub("[^%d%a_]%s+[%a%d_]", emptySpace):gsub(
                    "s[0-9]+@",
                    function(t)
                        local i = tonumber(t:sub(2, t:len() - 1))
                        return s[i]
                    end
                ):gsub(
                    "d[0-9]+@",
                    function(t)
                        local i = tonumber(t:sub(2, t:len() - 1))
                        return d[i]
                    end
                ):gsub("d" .. "@", '\\"'):gsub("s" .. "@", "\\'")
            end
            text = text:gsub("\\", "\\\\"):gsub('"', '\\"'):gsub("\n", "\\n")
            files[paths[i]] = text
        end
    end
    local strings = {}
    for key, value in pairs(files) do
        table.insert(strings, string.format('["%s"] = "%s"', key, value))
    end
    local filesText = string.format("{ %s }", table.concat(strings, ","))
    return string.format(
        'for key, value in pairs(%s) do\nlocal s, e = key:find(".*/")\nif s then\nlocal path = key:sub(s, e)\nif not fs.exists(path) then\nfs.makeDir(path)\nend\nend\nlocal file = io.open(key, "w+")\nfile:write(value)\nfile:close()\nend',
        filesText
    )
end

local function saveText(text, path)
    if path:sub(path:len() - 3) ~= ".avr" then
        path = path .. ".avr"
    end
    local file = io.open(path, "w+")
    file:write(text)
    file:close()
    return true
end

local function uploadText(text)
    assert(loadfile("os/sys/browser/loader.lua"))({mode = "upload", file = text})
end

local manager = ui.uiManager.new(_x, _y, _w, _h)
ui.buffer.fill(manager.buffer, " ", colors.black, colors.white)

local label_title = ui.label.new(manager, "Achivrar", theme.label1, 1, 1, _w - 3, 1)
local button_exit = ui.button.new(manager, "<", theme.button2, _w - 2, 1, 3, 1)

local sView_main = ui.scrollView.new(manager, "", 3, theme.sView1, 1, 2, _w, _h - 2)
local container_main = sView_main:getContainer()

local tBox_files = ui.textBox.new(container_main, "Files:", "", theme.tBox2, 1, 2, _w - 1, 7)

local button_files = ui.button.new(tBox_files, "Edit", theme.button1, _w - 6, 8, 6, 1)

local toggle_compress = ui.toggleButton.new(container_main, "Compress", true, theme.toggle1, 1, 10, _w, 1)

local toggle_upload = ui.toggleButton.new(container_main, "Upload to PasteBin", false, theme.toggle1, 1, 12, _w, 1)

local button_savePath = ui.button.new(container_main, "Path", theme.button1, 1, 13, 6, 1)
local label_savePath = ui.label.new(container_main, "no selection", theme.label2, 8, 13, _w - 8, 1)

local label_arguments = ui.label.new(container_main, "Additional arguments:", theme.label2, 1, 15, _w - 1, 1)
local iField_arguments = ui.inputField.new(container_main, "", "", true, theme.iField1, 1, 16, _w - 1, 5)

local label_info = ui.label.new(manager, "", theme.label1, 1, _h, _w - 6, 1)
local button_start = ui.button.new(manager, "Save", theme.button1, _w - 5, _h, 6, 1)

--sView_main:resetLayout()
sView_main:recalculate()
--sView_main:resetLayout()
sView_main:resizeContainer()
sView_main:repaint("this")

local function updateSaveButton()
    if #selected > 0 and (toggle_upload._checked == true or fs.exists(fs.getDir(savePath))) then
        button_start.mode = 1
    else
        button_start.mode = 2
    end
    button_start:recalculate()
end

updateSaveButton()

function button_exit:onClick(event)
    manager:exit()
end
function button_files:onClick(event)
    manager:callFunction(
        function()
            local select = true
            if event.name == "mouse_up" then
                select = false
            end
            local s =
                assert(loadfile("os/sys/explorer/main.lua"))(
                {select = true, mode = "select_many", select = select, edit = false}
            )
            if s then
                selected = s
            end
            tBox_files:setText(table.concat(selected, "\n"))
            updateSaveButton()
            manager:draw()
        end
    )
end
function button_savePath:onClick(event)
    manager:callFunction(
        function()
            local select = true
            if event.name == "mouse_up" then
                select = false
            end
            local name = fs.getName(savePath)
            if savePath == "/" or name == "" then
                name = "Compress.avr"
            end
            local path = fs.getDir(savePath)
            if not fs.exists(path) then
                path = ""
            end
            path =
                assert(loadfile("os/sys/explorer/main.lua"))(
                {select = true, mode = "save", override = true, type = "avr", path = path, save = name, select = select}
            )
            if path then
                savePath = path
                label_savePath.text = savePath
                label_savePath:recalculate()
            --label_savePath:repaint("this")
            end
            updateSaveButton()
            manager:draw()
        end
    )
end
function toggle_upload:onToggle(event, toggle)
    if toggle then
        button_savePath:changeMode(2, true)
        label_savePath:changeMode(2, true)
    else
        button_savePath:changeMode(1, true)
        label_savePath:changeMode(1, true)
    end
    updateSaveButton()
    manager:draw()
end
function button_start:onClick(event)
    manager:callFunction(
        function()
            if toggle_upload._checked then
                uploadText(pathsToText(selected, toggle_compress._checked))
            else
                if saveText(pathsToText(selected, toggle_compress._checked), savePath) then
                    label_info.text = "File created"
                else
                    label_info.text = "File creation Failed"
                end
                label_info:recalculate()
            end
            manager:draw()
        end
    )
end
local group_menu = manager.selectionManager:addNewGroup()
group_menu:addElement(button_exit, nil, nil, nil, button_files)

local group_main = sView_main.selectionGroup
manager.selectionManager:addGroup(group_main)

group_main:addElement(button_files, nil, button_exit, nil, toggle_compress)
group_main:addElement(toggle_compress, nil, button_files, nil, toggle_upload)
group_main:addElement(toggle_upload, nil, toggle_compress, nil, button_savePath)
group_main:addElement(button_savePath, nil, toggle_upload, nil, button_start)
group_main:addElement(button_start, nil, button_savePath, nil, nil)
manager.selectionManager:addGroup(tBox_files.selectionGroup)
manager.selectionManager:select(button_files, "code", 3)

manager:draw()
manager:execute()
