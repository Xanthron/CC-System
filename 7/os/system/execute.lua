local args = {...}

---TODO Edit so settings could be insert. E.g. extra arguments
local file = args[1]

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
        message = text:sub(endI + 1)
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

    print(file)
    if file ~= "" and file == "execute.lua" then
        file = _file
        line = _line
    end

    if file ~= "" then
        message = string.format("%s\n\n%s\n%s\n\n", message, file, line)

        local possibleFiles = {}
        getFilesWithName("", file, possibleFiles)
        if #possibleFiles == 0 then
            message = message .. "File could not be found."
        elseif #possibleFiles == 1 then
            message = message .. "Full path:\n" .. possibleFiles[1]
        else
            message = message .. "Multiple files could be found:\n" .. table.concat(possibleFiles, "\n")
        end

        message = message .. "\n\n\n" .. debug.traceback()
    end

    assert(loadfile("os/system/infoBox.lua"))(
        {
            label = "Error",
            text = message,
            x = 3,
            y = 3,
            w = w - 4,
            h = h - 4,
            button1 = {
                name = "Ok",
                func = function()
                end
            }
        }
    )
end

local function executionHandler()
    term.setCursorPos(1, 1)
    if term.isColor() then
        term.setBackgroundColor(colors.black)
        term.setTextColor(colors.white)
    end
    term.clear()
    assert(loadfile(file))(table.unpack(args, 2, #args))
end

local status, err, ret = xpcall(executionHandler, errorHandler)
return status, ret
