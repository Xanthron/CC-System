local path, data, mode = "os/sys/browser/data/installed", ...
local install = dofile(path)
if mode ~= 1 or mode ~= 2 then
    error("mode needs to be set to a valide number", 2)
end
for i, v in ipairs(install) do
    if v.name == data.name then
        table.remove(install, i)
    end
end
if mode == 1 then
    table.insert(install, {name = data.name, version = data.version, delete = data.delete})
    table.save(install, path)
end
