local path, mode, data = "os/sys/browser/data/installed", ...
local list = dofile(path)
if mode ~= 1 and mode ~= 2 then
    error("mode needs to be set to a valid number", 2)
end
for i, v in ipairs(list) do
    if v.name == data.name then
        table.remove(list, i)
    end
end
if mode == 1 then
    table.insert(list, {name = data.name, version = data.version, delete = data.delete})
end
table.save(list, path)
