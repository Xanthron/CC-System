local args = {...}

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

local function errorHandler(text)
    local w, h = term.getSize()

    local startI, endI = text:find(":[0-9]+:")

    if endI then
        local file = text:sub(0, startI - 1)
        local line = text:sub(startI + 1, endI - 1)
        local message = text:sub(endI + 1)
        local possibleFiles = {}
        getFilesWithName("", file, possibleFiles)
        text = string.format("%s\n\n%s\n%s\n\n", message, file, line)

        if #possibleFiles == 0 then
            text = text .. "File could not be found."
        elseif #possibleFiles == 1 then
            text = text .. "Full path:\n" .. possibleFiles[1]
        else
            text = text .. "Multiple files could be found:\n" .. table.concat(possibleFiles, "\n")
        end
    end
    assert(loadfile("os/system/infoBox.lua"))(
        {
            label = "Error",
            text = text,
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
