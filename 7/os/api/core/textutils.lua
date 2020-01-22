function textutils.serializeCompressed()
end
function textutils.getNeatName(path)
    local name = fs.getName(path)
    name =
        name:gsub(
        "^[%c%s_]*.",
        function(t)
            return t:sub(t:len() - 1):upper()
        end
    ):gsub("%.[^%.]*$", ""):gsub(
        "%a[%._]+%a",
        function(t)
            return t:sub(1, 1) .. t:sub(t:len()):upper()
        end
    ):gsub(
        "%l%u",
        function(t)
            return t:sub(1, 1) .. " " .. t:sub(2)
        end
    ):gsub(
        "%a%d",
        function(t)
            return t:sub(1, 1) .. " " .. t:sub(2)
        end
    )
    return name
end
