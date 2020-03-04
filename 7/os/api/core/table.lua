function table.copy(list)
    if type(list) ~= "table" then
        error("bad argument: table expected, got " .. type(list), 2)
    end
    local new = {}
    for key, value in pairs(list) do
        if type(value) == "table" then
            new[key] = table.copy(value)
        else
            new[key] = value
        end
    end
    return new
end
function table.save(list, path)
    if type(table) ~= "table" then
        error("bad argument: table expected, got " .. type(table), 2)
    end
    local save = table.toString(list)
    file = io.open(path, "w")
    file:write("return" .. save)
    file:close()
end
function table.checkType(set, name, kind, needSet, default)
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

function table.swap(list, i, j)
    local temp = list[i]
    list[i] = list[j]
    list[j] = temp
end

function table.order(list, func)
    local values = {}
    local n = #list

    for i = 1, n do
        values[i] = func(list[i])
    end

    repeat
        local newn = 1
        for i = 2, n do
            if values[i - 1] > values[i] then
                table.swap(values, i - 1, i)
                table.swap(list, i - 1, i)
                newn = i
            end
        end
        n = newn
    until n <= 1
end

function table.orderComplex(list, func)
    local values = {}
    local n = #list

    for i = 1, n do
        values[i] = {func(list[i])}
    end
    repeat
        local newn = 1
        for i = 2, n do
            for j = 1, #values[i - 1] do
                local var1, var2 = values[i - 1][j], values[i][j]
                if var1 > var2 then
                    table.swap(values, i - 1, i)
                    table.swap(list, i - 1, i)
                    newn = i
                    break
                elseif var1 < var2 then
                    break
                end
            end
        end
        n = newn
    until n <= 1
end

function table.clear(list)
    for k in pairs(list) do
        list[k] = nil
    end
end

local function _tableToString(list, contains)
    for i = 1, #contains do
        if contains[i] == list then
            error("Table is recursive and can not converted to string.", #contains + 2)
        end
    end
    table.insert(contains, v)

    local i, items = 1, {}
    for k, v in pairs(list) do
        if i == k then
            i = i + 1
        else
            i = nil
        end
        local t, value = type(v), nil
        if t == "table" then
            value = _tableToString(v, contains)
        elseif t == "string" then
            value = '"' .. v:gsub('"', '\\"'):gsub("[\n\r]", "\\n") .. '"'
        elseif t == nil then
            value = t
        else
            value = tostring(v)
        end
        if type(k) == "number" then
            if i then
                table.insert(items, value)
            else
                table.insert(items, ("[%s]=%s"):format(k, value))
            end
        else
            table.insert(items, ("%s=%s"):format(k, value))
        end
    end
    table.remove(contains, #contains)

    return ("{%s}"):format(table.concat(items, ","))
end

function table.toString(list)
    return _tableToString(list, {})
end

function table.crop(list, i, j)
    i, j = math.min(i, j), math.max(i, j)
    while j < #list do
        table.remove(list)
    end
    for i = 2, i do
        table.remove(list, 1)
    end
end

function table.removeAt(list, at)
    if type(at) == "number" then
        table.remove(list, at)
    else
        list[at] = nil
    end
end

function table.combine(...)
    local list = {}
    for _, v in ipairs({...}) do
        if type(v) == "table" then
            for i = 1, #v do
                table.insert(list, v[i])
            end
        elseif type(v) ~= "nil" then
            table.insert(list, v)
        end
    end
    return list
end

function table.reverse(list)
    for i = 1, math.floor(#list / 2) do
        table.swap(list, i, #list - i + 1)
    end
end

function table.contains(list, value)
    for k, v in pairs(list) do
        if v == value then
            return true
        end
    end
    return false
end
