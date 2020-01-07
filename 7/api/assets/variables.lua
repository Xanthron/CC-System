function save(path, ...)
    local saveString = {}
    local args = {...}
    for index, value in ipairs(args) do
        local valueString = getString(value)
        if valueString then
            table.insert(saveString, valueString)
        end
    end
    local file = nil
    file = io.open(path, "w")
    file:write("return" .. table.concat(saveString, ","))
    file:close()
end
function getString(value)
    local valueType = type(value)
    if valueType == "string" then
        return '"' .. string.gsub(value, '%"', '\\"') .. '"'
    elseif valueType == "number" then
        return tostring(value)
    elseif valueType == "table" then
        local tableString = {}
        for key, value in pairs(value) do
            local valueString = getString(value)
            if valueString then
                if type(key) == "number" then
                    table.insert(tableString, valueString)
                else
                    table.insert(tableString, table.concat({key, "=", valueString}))
                end
            end
        end
        return ("{%s}"):format(table.concat(tableString, ","))
    else
        return "nil"
    end
end
function open(path)
    if fs.exists(path) then
        return true, dofile(path)
    else
        return false
    end
end
