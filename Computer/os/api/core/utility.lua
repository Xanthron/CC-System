function IF(condition, v1, v2)
    if condition then
        return v1
    end
    return v2
end

function callfile(path, ...)
    return assert(loadfile(path))(...)
end
