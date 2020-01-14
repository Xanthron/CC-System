function copy(table)
    if type(table) ~= "table" then
        error("bad argument: table expected, got " .. type(table), 2)
    end
    local new = {}
    for key, value in pairs(table) do
        if type(value) == "table" then
            new[key] = copy(value)
        else
            new[key] = value
        end
    end
    return new
end
function save(list, path)
    if type(table) ~= "table" then
        error("bad argument: table expected, got " .. type(table), 2)
    end
    local save = textutils.serialize(list)
    file = io.open(path, "w")
    file:write("return" .. save)
    file:close()
end
function checkType(set, name, kind, needSet, default)
    if not (set[name] or set[name] == false) then
        set[name] = default
    end
    local value = set[name]
    local valueType = type(value)
    if value or value == false then
        if valueType ~= kind then
            error(("'%s' is set but has the wrong type. (expected '%s' got '%s')"):format(name, kind, valueType), 3)
        end
    elseif needSet then
        error(("'%s' is not set. (expected '%s' got 'nil')"):format(name, kind), 3)
    end
end
