function fs.doFile(path)
    if fs.exists(path) then
        return true, dofile(path)
    else
        return false
    end
end

function fs.listAll(path, paths)
    local paths = paths or {}
    local list = fs.list(path)
    for _, p in ipairs(list) do
        if path ~= "" then
            p = path .. "/" .. p
        end
        if fs.isDir(p) then
            fs.listAll(p, paths)
        else
            table.insert(paths, p)
        end
    end
    return paths
end

function fs.addExtension(path, ext)
    if not path:sub(path:len() - ext:len()) == ext then
        return path .. "." .. ext
    else
        return path
    end
end

function fs.getExtension(path)
    local ext = path:match("[^/]%.[^/]-$")
    if ext then
        return ext:sub(3)
    else
        return nil
    end
end

function fs.getClearName(path)
    return fs.getName(path):match(".[^%.]+")
end
