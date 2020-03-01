local function loadAPIs(dir)
    local apiFiles = fs.list(dir)
    for i = 1, #apiFiles do
        local path = dir .. "/" .. apiFiles[i]

        if fs.isDir(path) == false then
            dofile(path)
        else
            loadAPIs(path)
        end
    end
end

loadAPIs("os/api")

local _
_, _G.theme = ui.theme.load("main.lua")
_G.shell = shell

if not fs.exists("os/programs") then
    fs.makeDir("os/programs")
end

if not fs.exists("os/startup") then
    fs.makeDir("os/startup")
end
