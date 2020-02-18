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

    local items = {}
    for k, v in pairs(list) do
        local t, value = type(v), nil
        if t == "table" then
            value = _tableToString(v, contains)
        elseif t == "string" then
            value = '"' .. v:gsub('"', '\\"') .. '"'
        elseif t == nil then
            value = t
        else
            value = tostring(v)
        end
        if type(k) == "number" then
            k = ("[%s]"):format(k)
        end
        table.insert(items, ("%s=%s"):format(k, value))
    end
    table.remove(contains, #contains)

    return ("{%s}"):format(table.concat(items, ","))
end

function table.toString(list)
    return _tableToString(list, {})
end
