local args = {...}
local official, unofficial

local function downloadScreen(...)
    callfile("os/sys/wait.lua", "Downloading", ...)
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
    return s
end

local function doItem(name)
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
        official, unofficial = dofile("os/sys/browser/getList.lua")
        for i = 1, #args do
            doItem(args[i])
        end
    end
)
