function copyTable(table, pr)
    if not table then
        error("no table", 2)
    end
    if pr then
        print(pr)
    end
    local new = {}
    for key, value in pairs(table) do
        if type(value) == "table" then
            new[key] = copyTable(value)
        else
            new[key] = value
        end
    end
    return new
end
function getAllFilePaths(path, paths)
    local paths = paths or {}
    local list = fs.list(path)
    for _, p in ipairs(list) do
        if path ~= "" then
            p = path .. "/" .. p
        end
        if fs.isDir(p) then
            getAllFilePaths(p, paths)
        else
            table.insert(paths, p)
        end
    end
    return paths
end
