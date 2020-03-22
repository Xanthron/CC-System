local args = {...}
local official, unofficial, installed
local term = ui.input.term

--TODO Check if necessary in code
local function downloadScreen(...)
    ui.wait("Downloading\nRequirements", ...)
end

local function doData(data)
    local s, c
    if data.path == "run" then
        if data.url:len() == 8 then
            s, c = www.pasteBinRun(data.url)
        else
            s, c = www.run(data.url)
        end
    else
        if data.url:len() == 8 then
            s, c = www.pasteBinSave(data.url, data.path, true)
        else
            s, c = www.save(data.url, data.path, true)
        end
    end
    if s then
        callfile("os/sys/browser/install.lua", 1, data)
    end
    return s
end

local function compareVersion(required, installed)
    if not installed then
        return false
    end
    for i = 1, min(#required, #installed) do
        if required[i] > installed[i] then --TODO Version
            return false
        elseif required[i] < installed[i] then
            return true
        end
    end
    return true
end

---@param name string
local function doItem(name)
    for i = 1, #installed do
        if installed[i].name == name then
            local s, e = name:find("^%[[0-9]-%.[0-9]%.[0-9]%]%s*") --TODO Überprüfen ob das klappt
            if s then
                local version = {}
                local versionText = name:sub(s + 1, e - 1)
                name = name:sub(e + 1)
                for n in versionText:gmatch("[0-9]+") do
                    table.insert(version, tonumber(n))
                end
                if not compareVersion(version, installed[i].version) then
                    break
                end
            end
            s, e = name:find("^%[force%]%s*")
            if s then
                name = name:sub(e + 1)
                break
            end

            return
        end
    end
    for i = 1, #official do
        if official[i].name == name then
            doData(official[i])
            return
        end
    end
    for i = 1, #unofficial do
        if unofficial[i].name == name then
            doData(unofficial[i])
            return
        end
    end
end

downloadScreen(
    function()
        official, unofficial, installed = dofile("os/sys/browser/getList.lua")
        for i = 1, #args do
            doItem(args[i])
        end
    end
)
term.setCursorPos(1, 1)
term.setTextColor(colors.white)
term.setBackgroundColor(colors.black)
term.clear()
