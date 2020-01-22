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
    --print(v.x, v.y, v.z)
    for i = 1, #todo do
        if todo[i].x == v.x and todo[i].y == v.y and todo[i].z == v.z then
            table.remove(todo, i)
            break
        end
    end
    table.insert(done, vector.new(v.x, v.y, v.z))
end

local function getVector(dir, v)
    if dir == 1 then --     forward
        return vector.new(v.x + 1, v.y, v.z)
    elseif dir == 2 then -- up
        return vector.new(v.x, v.y, v.z + 1)
    elseif dir == 3 then -- down
        return vector.new(v.x, v.y, v.z - 1)
    elseif dir == 4 then -- right
        return vector.new(v.x, v.y + 1, v.z)
    elseif dir == 5 then -- left
        return vector.new(v.x, v.y - 1, v.z)
    elseif dir == 6 then -- back
        return vector.new(v.x - 1, v.y, v.z)
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
    table.insert(todo, vector.new(v.x, v.y, v.z))
    table.insert(done, vector.new(v.x, v.y, v.z))
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
            --return ((v.x - base.x) ^ 2 + (v.y - base.y) ^ 2 + (v.z - base.z) ^ 2)
            return (v.x - current.x) ^ 2 + (v.y - current.y) ^ 2 + (v.z - current.z) ^ 2, ((v.x - base.x) ^ 2 + (v.y - base.y) ^ 2 + (v.z - base.z) ^ 2)
        end
    )
end

local function turnLeft()
    turtle.turnLeft()
    facing.x, facing.y = facing.y, -facing.x
end
local function turnRight()
    turtle.turnRight()
    facing.x, facing.y = -facing.y, facing.x
end
local function move(dir)
    if dir == 1 then
        while not turtle.forward() do
            turtle.dig()
        end
        setCurrent(vector.new(current.x + 1 * facing.x, current.y + 1 * facing.y, current.z))
    elseif dir == 2 then
        while not turtle.up() do
            turtle.digUp()
        end
        setCurrent(vector.new(current.x, current.y, current.z + 1))
    elseif dir == 3 then
        while not turtle.down() do
            turtle.digDown()
        end
        setCurrent(vector.new(current.x, current.y, current.z - 1))
    elseif dir == 4 then
        turnRight()
    elseif dir == 5 then
        turnLeft()
    elseif dir == 6 then
        turnRight()
        turnRight()
        move(1)
    else
        error("enter a valid direction", 2)
    end
end

local function Check(direction)
    local success, data
    if direction == 1 then
        success, data = turtle.inspect()
    elseif direction == 2 then
        success, data = turtle.inspectUp()
    elseif direction == 3 then
        success, data = turtle.inspectDown()
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
    if forward == true then
        addVectorLists(getVector(1, current))
    end
    addVectorLists(getVector(2, current))
    addVectorLists(getVector(3, current))
    addVectorLists(getVector(4, current))
    addVectorLists(getVector(5, current))
end
local function getNearest(relative, destination)
    local newV, minD
    for i = 1, 6 do
        local tempV = getVector(i, destination)
        local newD = (tempV.x - relative.x) ^ 2 + (tempV.y - relative.y) ^ 2 + (tempV.z - relative.z) ^ 2
        if not minD or minD > newD then
            newV = tempV
            minD = newD
        end
    end
    return newV
end
local function goTo(v)
    local to = v - current
    local x = to.x * facing.x + to.y * facing.y
    local y = to.x * -facing.y + to.y * facing.x
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

    if y > 0 then
        move(4)
        turn = 1
        while y > 0 do
            move(1)
            y = y - 1
        end
    end
    if y < 0 then
        move(5)
        turn = 2
        while y < 0 do
            move(1)
            y = y + 1
        end
    end

    if x < 0 then
        if turn == 1 then
            move(4)
        elseif turn == 2 then
            move(5)
        else
            move(4)
            move(4)
        end
        while x < 0 do
            move(1)
            x = x + 1
        end
    end
end
local function iteration()
    turtle.dig()
    move(1)
    addAround(false)
    base.x, base.y, base.z = current.x, current.y, current.z
    while #todo > 0 do
        orderVectorList()
        local v = getNearest(current, todo[1])
        if not (v.x == current.x and v.y == current.y and v.z == current.z) then
            goTo(v)
        end
        local vDir = vector.new((todo[1].x - current.x) * facing.x, (todo[1].y - current.y) * facing.y, todo[1].z - current.z)
        print(vDir)
        --sleep(1)
        local mined = false
        if vDir.x > 0 then
            if Check(1) then
                move(1)
                mined = true
            end
        elseif vDir.x < 0 then
            move(4)
            move(4)
            if Check(1) then
                move(1)
                mined = true
            end
        elseif vDir.y > 0 then
            move(4)
            if Check(1) then
                move(1)
                mined = true
            end
        elseif vDir.y < 0 then
            move(5)
            if Check(1) then
                move(1)
                mined = true
            end
        elseif vDir.z > 0 then
            if Check(2) then
                move(2)
                mined = true
            end
        elseif vDir.z < 0 then
            if Check(3) then
                move(3)
                mined = true
            end
        end
        if mined then
            addAround(true)
        else
            table.remove(todo, 1)
        end
    end
    clearVectorLists()
    goTo(base)
end

for i = 1, 1 do
    iteration()
end
goTo(vector.new(0, 0, 0))
turnLeft()
turnLeft()
