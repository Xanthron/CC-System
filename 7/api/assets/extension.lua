function copyTable(table)
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
