local list = {
    "minecraft:lapis_ore",
    "minecraft:diamond_ore",
    "minecraft:redstone_ore",
    "minecraft:coal_ore",
    "minecraft:iron_ore",
    "minecraft:gold_ore"
}
local todo = {}
local done = {}
local start = vector.new(0, 0, 0)
local base = vector.new(0, 0, 0)
local current = vector.new(0, 0, 0)
local facing = vector.new(1, 0, 0)

local function setCurrent(v)
    current = v
    print(current:tostring())
end

local function getVector(dir, v)
    if dir == 1 then --     forward
        return v + facing
    elseif dir == 2 then -- up
        return vector.new(v.x, v.y, v.z + 1)
    elseif dir == 3 then -- down
        return vector.new(v.x, v.y, v.z - 1)
    elseif dir == 4 then -- right
        return vector.new(v.x + facing.y, v.y - facing.x, v.z)
    elseif dir == 5 then -- left
        return vector.new(v.x - facing.y, v.y + facing.x, v.z)
    elseif dir == 6 then -- back
        return v - facing
    else
        error("enter a valid direction", 2)
    end
end

local function addVectorLists(v)
    for i = 1, #done do
        local d = done[i]
        if v.x == d.x and v.y == d.y and v.z == d.z then
            return false
        end
    end
    table.insert(todo, 1)
    table.insert(done, 1)
    return true
end
local function clearVectorLists()
    table.clear(todo)
    table.clear(done)
end
local function orderVectorList()
    table.orderComplex(
        todo,
        function(v)
            return (v.x - current.x) ^ 2 + (v.y - current.y) ^ 2 + (v.z - current.z) ^ 2, -((v.x - base.x) ^ 2 +
                (v.y - base.y) ^ 2 +
                (v.z - base.z) ^ 2)
        end
    )
end

local function turnLeft()
    turtle.turnLeft()
    if facing.x == 1 then
        facing.x = 0
        facing.y = -1
    elseif facing.x == -1 then
        facing.x = 0
        facing.y = 1
    elseif facing.y == 1 then
        facing.x = 1
        facing.y = 0
    elseif facing.y == -1 then
        facing.x = -1
        facing.y = 0
    end
end
local function turnRight()
    turtle.turnRight()
    if facing.x == 1 then
        facing.x = 0
        facing.y = 1
    elseif facing.x == -1 then
        facing.x = 0
        facing.y = -1
    elseif facing.y == 1 then
        facing.x = -1
        facing.y = 0
    elseif facing.y == -1 then
        facing.x = 1
        facing.y = 0
    end
end
local function move(dir)
    if dir == 1 then
        if turtle.forward() then
            setCurrent(vector.new(current.x + current.x * facing.x, current.y + current.y * facing.y, current.z))
            return true
        end
    elseif dir == 2 then
        if turtle.up() then
            setCurrent(vector.new(current.x, current.y, current.z + 1))
            return true
        end
    elseif dir == 3 then
        if turtle.down() then
            setCurrent(vector.new(current.x, current.y, current.z - 1))
            return true
        end
    elseif dir == 4 then
        turnRight()
        return true
    elseif dir == 5 then
        turnLeft()
        return true
    elseif dir == 6 then
        if turtle.back() then
            setCurrent(vector.new(current.x + current.x * facing.x, current.y + current.y * facing.y, current.z))
            return true
        end
    else
        error("enter a valid direction", 2)
    end
end

local function Check(direction)
    local success, data
    if direction == "down" then
        success, data = turtle.inspectDown()
    elseif direction == "forward" then
        success, data = turtle.inspect()
    elseif direction == "up" then
        success, data = turtle.inspectUp()
    end
    if success then
        for _, v in ipairs(list) do
            if v == data.name then
                return true
            end
        end
    end
    return false
end
local function addAround(forward)
    if forward then
        addVectorLists(getVector("front", current))
    end
    addVectorLists(getVector("up", current))
    addVectorLists(getVector("down", current))
    addVectorLists(getVector("right", current))
    addVectorLists(getVector("left", current))
end
local function getNearest(v)
    local newV, minD
    for i = 1, 6 do
        local tempV = getVector(i, v)
        local newD = (tempV.x - v.x) ^ 2 + (tempV.x - v.x) ^ 2 + (tempV.x - v.x) ^ 2
        if not minD or minD < newD then
            newV = tempV
            minD = newD
        end
    end
    return newV
end
local function goTo(v)
    local to = v - current
    local x = to.x * facing.x + to.y * facing.y
    local y = to.x * facing.y + to.y * facing.x
    local z = to.z
    local turn = 0

    while z > 0 do
        move(2)
        z = z - 1
    end
    while z < 0 do
        move(3)
        z = z + 1
    end

    while x > 0 do
        move(1)
        x = x - 1
    end
    if x < 0 then
        move(4)
        move(4)
        while x < 0 do
            move(1)
            x = x + 1
        end
    end

    if y > 0 then
        move(4)
        while y > 0 do
            move(1)
            y = y - 1
        end
    end
    if y < 0 then
        move(5)
        while y < 0 do
            move(1)
            y = y + 1
        end
    end
end

while true do
    break
end

goTo(vector.new(-5, 5, 0))
