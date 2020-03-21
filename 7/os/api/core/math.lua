function math.clamp(num1, num2, value)
    local min, max = math.min(num1, num2), math.max(num1, num2)
    return math.min(max, math.max(min, value))
end
