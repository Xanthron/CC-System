-- local args = {...}

-- print(table.unpack(args))

-- local path = args[1]
-- local compress = args[2]
local files = {}

local compress = "true"
local paths = assert(loadfile("os/system/explorer/explorer.lua"))({select = true, selectMode = "select_many", saveName = "Compress.avr"})
if not paths then
    error("no paths", 2)
end
local save = assert(loadfile("os/system/explorer/explorer.lua"))({select = true, selectMode = "save", showType = "avr", saveName = "Compress.avr"})
if not save then
    error("no save", 2)
end

if save:sub(save:len() - 4) ~= ".avr" then
    save = save .. ".avr"
end
for i = 1, #paths do
    if fs.exists(paths[i]) then
        local handler = io.open(paths[i], "r")
        local lines = {}
        for line in handler:lines() do
            table.insert(lines, line)
        end
        handler:close()

        local text

        ---FIXME Zeilen können gelöscht werden, wenn im string -- vorkommt.
        if compress:lower() == "true" then
            local removeLine = false
            for i = 1, #lines do
                local line = lines[i]
                if removeLine then
                    --if not line
                    local x, y = line:find("%-%-%[%[.*$")
                else
                end
                if removeLine then
                    line = line:gsub()
                else
                end
            end
            text = text:gsub("%-%-[^\n]+%[%[", "--"):gsub("%-%-%[%[.*%]%]+", ""):gsub("%-%-.-\n+", "\n"):gsub("\n%s+", "\n")
        else
            local text = table.concat(lines, "\n")
        end
        text = text:gsub("\\", "\\\\"):gsub('"', '\\"'):gsub("\n", "\\n")
        files[paths[i]] = text
    end
end

print(type(compress))
local strings = {}
for key, value in pairs(files) do
    table.insert(strings, string.format('["%s"] = "%s"', key, value))
end
local filesText = string.format("{ %s }", table.concat(strings, ","))

local file = io.open(save, "w+")
file:write(string.format('for key, value in pairs(%s) do\nlocal s, e = key:find(".*/")\nif s then\nlocal path = key:sub(s, e)\nif not fs.exists(path) then\nfs.makeDir(path)\nend\nend\nlocal file = io.open(key, "w+")\nfile:write(value)\nfile:close()\nend', filesText))
file:close()
