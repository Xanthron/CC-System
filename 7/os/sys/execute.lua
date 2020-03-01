local set = ...

table.checkType(set, "file", "string", true)
table.checkType(set, "args", "table", false)
table.checkType(set, "select", "boolean", true)

local function getFilesWithName(path, name, tab)
    local paths = fs.list(path)
    for key, value in pairs(paths) do
        local newPath = path .. "/" .. value
        if path == "" then
            newPath = value
        end
        if fs.isDir(newPath) then
            getFilesWithName(newPath, name, tab)
        elseif value == name then
            table.insert(tab, newPath)
        end
    end
end
local function getErrorText(text)
    local startI, endI = text:find(":[0-9]+:")
    local file, message, line, possibleFiles = "", text, "", {}
    if endI then
        file = text:sub(0, startI - 1)
        line = text:sub(startI + 1, endI - 1)
        message = text:sub(endI + 2)
    end
    return message, file, line, possibleFiles
end
local function getFallBackInfo()
    local _, message, file, line
    _, message =
        pcall(
        function()
            error(" ", 5)
        end
    )
    message, file, line = getErrorText(message)
    if file == "bios.lua" then
        _, message =
            pcall(
            function()
                error(" ", 9)
            end
        )
        message, file, line = getErrorText(message)
    end
    return file, line
end
local _file, _line, errorLevel = getFallBackInfo()
local function errorHandler(text)
    local w, h = term.getSize()
    local possibleFiles = {}
    local message, file, line = getErrorText(text)
    if file ~= "" and file == "execute.lua" then
        file = _file
        line = _line
    end
    if file ~= "" then
        message = string.format("[tc=red]%s[tc=clear]\n\n%s\n%s\n\n", message, file, line)
        local possibleFiles = {}
        getFilesWithName("", file, possibleFiles)
        if #possibleFiles == 0 then
            message = message .. "File could not be found."
        elseif #possibleFiles == 1 then
            message = message .. "Full path:\n" .. possibleFiles[1]
        else
            message = message .. "Multiple files could be found:\n" .. table.concat(possibleFiles, "\n")
        end
        message = message .. "\n\n\n[tc=gray]" .. debug.traceback()
    end
    callfile("os/sys/infoBox.lua", {label = "Error", text = message, x = 3, y = 3, w = w - 4, h = h - 4, button1 = "Ok", select = set.select})
end
local function executionHandler()
    term.setCursorPos(1, 1)
    if term.isColor() then
        term.setBackgroundColor(colors.black)
        term.setTextColor(colors.white)
    end
    term.clear()
    local button, select = callfile(set.file, table.unpack(set.args))
    return select
end
--executionHandler()
local ret = {xpcall(executionHandler, errorHandler)}
return table.unpack(ret)
