local _x, _y, _w, _h = 1, 1, term.getSize()
local selected = {}
local savePath = "/"
local code = ""
local function save(path, paths, compress)
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
                        return ("d%'"):format(#d)
                    end
                ):gsub(
                    "'[^\n\r]-'",
                    function(t)
                        table.insert(s, t)
                        return ("s%'"):format(#s)
                    end
                ):gsub("%-%-[^\n]+%[%[", "--"):gsub("%-%-%[%[.*%]%]+", ""):gsub("%-%-.-\n+", "\n"):gsub("\n%s+", "\n"):gsub("[%a%d_]%s[^%a%d_]", emptySpace):gsub("[^%d%a_]%s+[%a%d_]", emptySpace):gsub(
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
    local text = string.format('for key, value in pairs(%s) do\nlocal s, e = key:find(".*/")\nif s then\nlocal path = key:sub(s, e)\nif not fs.exists(path) then\nfs.makeDir(path)\nend\nend\nlocal file = io.open(key, "w+")\nfile:write(value)\nfile:close()\nend', filesText)
    if path == true then
        local key = "0ec2eb25b6166c0c27a394ae118ad829"
        local response = http.post("https://pastebin.com/api/api_post.php", "api_option=paste&" .. "api_dev_key=" .. key .. "&" .. "api_paste_format=lua&" .. "api_paste_name=" .. textutils.urlEncode("file") .. "&" .. "api_paste_code=" .. textutils.urlEncode(text))
        if response then
            local responseText = response.readAll()
            response.close()
            code = string.match(responseText, "[^/]+$")
            return true
        else
            return false
        end
    else
        if path:sub(path:len() - 3) ~= ".avr" then
            path = path .. ".avr"
        end
        local file = io.open(path, "w+")
        file:write(text)
        file:close()
        return true
    end
end
local manager = ui.uiManager.new(_x, _y, _w, _h)
ui.buffer.fillWithColor(manager.buffer, " ", colors.black, colors.white)
local label1 = ui.label.new(manager, "Achivrar", theme.label1, 1, 1, _w - 3, 1)
local button1 = ui.button.new(manager, "x", nil, theme.button2, _w - 2, 1, 3, 1)
local tBox1 = ui.textBox.new(manager, "Files:", "", theme.tBox2, 1, 2, _w, _h - 8)
local button2 = ui.button.new(tBox1, "Edit", nil, theme.button1, _w - 5, _h - 7, 6, 1)
local toggle1 = ui.toggleButton.new(manager, "Compress", true, nil, theme.toggle1, 1, _h - 5, _w, 1)
local toggle2 = ui.toggleButton.new(manager, "Upload to PasteBin", false, nil, theme.toggle1, 1, _h - 3, _w, 1)
local label2 = ui.label.new(manager, "Save: /", theme.label2, 1, _h - 2, _w - 6, 1)
local button3 = ui.button.new(manager, "Edit", nil, theme.button1, _w - 5, _h - 2, 6, 1)
local label3 = ui.label.new(manager, "", theme.label1, 1, _h, _w - 6, 1)
local button4 = ui.button.new(manager, "Save", nil, theme.button1, _w - 5, _h, 6, 1)
local function updateSaveButton()
    if #selected > 0 and (toggle2._checked == true or fs.exists(fs.getDir(savePath))) then
        button4.mode = 1
    else
        button4.mode = 2
    end
    button4.recalculate()
end
updateSaveButton()
local function updateLabelText()
    if toggle2._checked then
        label2.text = "Code: " .. code
    else
        label2.text = "Save: " .. savePath
    end
    label2.recalculate()
end
button1._onClick = function(event)
    manager.exit()
end
button2._onClick = function(event)
    manager.callFunction(
        function()
            local select = true
            if event.name == "mouse_up" then
                select = false
            end
            local s = assert(loadfile("os/system/explorer/explorer.lua"))({select = true, mode = "select_many", select = select, edit = false})
            if s then
                selected = s
            end
            tBox1.setText(table.concat(selected, "\n"))
            updateSaveButton()
            manager.draw()
        end
    )
end
local button3_save = function(event)
    manager.callFunction(
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
            path = assert(loadfile("os/system/explorer/explorer.lua"))({select = true, mode = "save", type = "avr", path = path, save = name, select = select})
            if path then
                savePath = path
            end
            updateLabelText()
            updateSaveButton()
            manager.draw()
        end
    )
end
local button3_pasteBin = function(event)
end
button3._onClick = button3_save
toggle2._onToggle = function(event, toggle)
    if toggle then
        updateLabelText()
        button3._onClick = button3_pasteBin
        button3.text = "Copy"
        if code == "" then
            button3.mode = 2
        else
            button3.mode = 1
        end
    else
        updateLabelText()
        button3._onClick = button3_save
        button3.text = "Edit"
        button3.mode = 1
    end
    button3.recalculate()
    updateSaveButton()
    manager.draw()
end
button4._onClick = function(event)
    manager.callFunction(
        function()
            if toggle2._checked then
                label3.text = "Start Upload"
                label3.recalculate()
                label3.repaint("this")
                if save(true, selected, toggle1._checked) then
                    updateLabelText()
                    updateSaveButton()
                    button3.mode = 1
                    button3.recalculate()
                    label3.text = "Upload succeeded"
                else
                    label3.text = "Upload failed"
                end
                label3.recalculate()
                manager.draw()
            else
                if save(savePath, selected, toggle1._checked) then
                    label3.text = "File created"
                else
                    label3.text = "File creation Failed"
                end
                label3.recalculate()
                manager.draw()
            end
        end
    )
end
manager.draw()
manager.execute()
