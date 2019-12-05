local args = {...}

print(table.unpack(args))

local path = args[1]
local compress = args[2]
local files = {}

for i = 3, #args do
    if fs.exists(args[i]) then
        local handler = io.open(args[i], "r")
        local lines = {}
        for line in handler:lines() do
            table.insert(lines, line)
        end
        handler:close()

        local text = table.concat(lines, "\n")
        ---FIXME Zeilen können gelöscht werden, wenn im string -- vorkommt.
        if compress:lower() == "true" then
            text =
                text:gsub("%-%-[^\n]+%[%[", "--"):gsub("%-%-%[%[.*%]%]+", ""):gsub("%-%-.-\n+", "\n"):gsub(
                "\n%s+",
                "\n"
            )
        end
        text = text:gsub("\\", "\\\\"):gsub('"', '\\"'):gsub("\n", "\\n")
        files[args[i]] = text
    end
end

print(type(compress))
local strings = {}
for key, value in pairs(files) do
    table.insert(strings, string.format('["%s"] = "%s"', key, value))
end
local filesText = string.format("{ %s }", table.concat(strings, ","))

local file = io.open(path, "w+")
file:write(
    string.format(
        'for key, value in pairs(%s) do\nlocal s, e = key:find(".*/")\nif s then\nlocal path = key:sub(s, e)\nif not fs.exists(path) then\nfs.makeDir(path)\nend\nend\nlocal file = io.open(key, "w+")\nfile:write(value)\nfile:close()\nend',
        filesText
    )
)
file:close()
