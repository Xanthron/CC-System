dofile("os/api/core/vector.lua")

local list = {
    "minecraft:lapis_ore",
    "minecraft:diamond_ore",
    "minecraft:redstone_ore",
    "minecraft:coal_ore",
    "minecraft:iron_ore",
    "minecraft:gold_ore"
}

local start = vector.zero:copy()
local base = start:copy()
local pos = start:copy()
local facing = vector.forward:copy()
---@type vector[]
local undone = {}
---@type vector[]
local done = {}

local function setCurrentPos(x, y, z)
    pos:set(x, y, z)
    for i = 1, #undone do
        if undone[i] == pos then
            table.remove(undone, i)
            return
        end
    end
end
local function addToUndone(v)
    for i = 1, #done do
        if done[i] == v then
            return
        end
    end
    local clone = v:copy()
    table.insert(done, clone)
    table.insert(undone, clone)
end
local function clearVectorLists()
    table.clear(undone)
    table.clear(done)
end
local function orderVectorList()
    table.orderComplex(
        undone,
        function(v)
            return ((v.x - base.x) ^ 2 + (v.y - base.y) ^ 2 + (v.z - base.z) ^ 2)
            --return (v.x - pos.x) ^ 2 + (v.y - pos.y) ^ 2 + (v.z - pos.z) ^ 2, ((v.x - base.x) ^ 2 + (v.y - base.y) ^ 2 + (v.z - base.z) ^ 2)
        end
    )
end

local function getConnected(v, dir)
    if dir == 1 then
        return v + vector.forward
    elseif dir == 2 then
        return v + vector.up
    elseif dir == 3 then
        return v + vector.down
    elseif dir == 4 then
        return v + vector.right
    elseif dir == 5 then
        return v + vector.left
    elseif dir == 6 then
        return v + vector.backward
    end
end

local function inspect(dir)
    local success, data
    if dir == 1 then
        success, data = turtle.inspect()
    elseif dir == 2 then
        success, data = turtle.inspectUp()
    elseif dir == 3 then
        success, data = turtle.inspectDown()
    end
    if success then
        return true
    -- for _, v in ipairs(list) do
    --     if v == data.name then
    --         return true
    --     end
    -- end
    end
    return false
end

local function addAround(forward)
    if forward then
        addToUndone(getConnected(pos, 1))
    end
    -- for i = start, 5 do
    addToUndone(getConnected(pos, 2))
    addToUndone(getConnected(pos, 3))
    -- end
end
local function getNearest(relative, destination)
    local newV, minD
    for i = 1, 6 do
        local tempV = getConnected(destination, i)
        local newD = (tempV.x - relative.x) ^ 2 + (tempV.y - relative.y) ^ 2 + (tempV.z - relative.z) ^ 2
        if not minD or minD > newD then
            newV = tempV
            minD = newD
        end
    end
    return newV
end

local function move(dir)
    if dir == 1 then
        while not turtle.forward() do
            turtle.dig()
        end
        setCurrentPos(pos.x + 1 * facing.x, pos.y + 1 * facing.y)
    elseif dir == 2 then
        while not turtle.up() do
            turtle.digUp()
        end
        setCurrentPos(nil, nil, pos.z + 1)
    elseif dir == 3 then
        while not turtle.down() do
            turtle.digDown()
        end
        setCurrentPos(nil, nil, pos.z - 1)
    elseif dir == 4 then
        turtle.turnRight()
        facing:set(-facing.y, facing.x)
    elseif dir == 5 then
        turtle.turnLeft()
        facing:set(facing.y, -facing.x)
    elseif dir == 6 then
        turtle.back()
        setCurrentPos(pos.x - 1 * facing.x, pos.y - 1 * facing.y)
    end
end
local function go(v)
    if v.x > 0 then
        if facing.x < 0 then
            move(4)
            move(4)
        elseif facing.y > 0 then
            move(5)
        elseif facing.y < 0 then
            move(4)
        end
        for i = 1, v.x do
            move(1)
        end
    elseif v.x < 0 then
        if facing.x > 0 then
            move(4)
            move(4)
        elseif facing.y > 0 then
            move(4)
        elseif facing.y < 0 then
            move(5)
        end
        for i = 1, -v.x do
            move(1)
        end
    end
    if v.z > 0 then
        for i = 1, v.z do
            move(2)
        end
    elseif v.z < 0 then
        for i = 1, -v.z do
            move(3)
        end
    end
    if v.y > 0 then
        if facing.y < 0 then
            move(4)
            move(4)
        elseif facing.x > 0 then
            move(4)
        elseif facing.x < 0 then
            move(5)
        end
        for i = 1, v.y do
            move(1)
        end
    elseif v.y < 0 then
        if facing.y > 0 then
            move(4)
            move(4)
        elseif facing.x > 0 then
            move(5)
        elseif facing.x < 0 then
            move(4)
        end
        for i = 1, -v.y do
            move(1)
        end
    end
end

local function iteration()
    print("start")
    table.insert(done, pos:copy())
    move(1)
    table.insert(done, pos:copy())
    base:set(pos.x, pos.y, pos.z)
    addAround(false)
    while #undone > 0 do
        local current = undone[1]
        table.remove(undone, 1)
        orderVectorList()
        local nearest = getNearest(pos, current)
        term.write(pos)
        term.write(" ")
        term.write(current)
        term.write(" ")
        term.write(nearest)
        term.write(" ")
        if not (nearest == pos) then
            term.write("-> " .. tostring(nearest - pos))
            go(nearest - pos)
        end
        print()
        local dir = current - pos
        dir:set(dir.x * facing.x + dir.y * facing.y, dir.x * -facing.y + dir.y * facing.x)
        if dir.z > 0 then
            if inspect(2) then
                move(2)
                addAround(true)
            end
        elseif dir.z < 0 then
            if inspect(3) then
                move(3)
                addAround(true)
            end
        else
            if dir.x < 0 then
                move(4)
                move(4)
            elseif dir.y > 0 then
                move(5)
            elseif dir.y < 0 then
                move(4)
            end
            if inspect(1) then
                move(1)
                addAround(true)
            end
        end
    end
end

for i = 1, 1 do
    iteration()
end
go(start - pos)
move(4)
move(4)
