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
local function removeVector(v)
    for i = 1, #undone do
        if undone[i] == v then
            table.remove(undone, i)
            break
        end
    end
end
local function clearVectorLists()
    table.clear(undone)
    local i = 1
    while i <= #done do
        local v = done[i]
        if
            ((v.y <= 1 and v.y >= -1 and v.z == 0) and (v.z <= 1 or v.z >= -1 and v.y == 0) and
                (v - base):sqLength() < 10)
         then
            i = i + 1
        else
            table.remove(done, i)
        end
    end
end
local function getDir(dir)
    dir:set(dir.x * facing.x + dir.y * facing.y, dir.x * facing.y + dir.y * facing.x)
    return dir
end
local function orderVectorList()
    table.orderComplex(
        undone,
        function(v)
            local turns = 0
            local dir = getDir(v - pos)
            if dir.x < 0 then
                turns = 2
            elseif dir.y ~= 0 then
                turns = 1
            end

            return ((v.x - pos.x) ^ 2 + (v.y - pos.y) ^ 2 + (v.z - pos.z) ^ 2), turns
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
        addToUndone(getConnected(pos, 1))
    end
    -- for i = start, 5 do
    addToUndone(getConnected(pos, 2))
    addToUndone(getConnected(pos, 3))
    addToUndone(getConnected(pos, 4))
    addToUndone(getConnected(pos, 5))
    -- end
end
local function getNearest(r1, r2, d)
    local vs = {}
    for i = 1, 6 do
        vs[i] = getConnected(d, i)
    end
    table.orderComplex(
        vs,
        function(v)
            return (r1 - d):sqLength(), (r2 - d):sqLength()
        end
    )
    return vs[1]
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
    while #undone > 0 do
        orderVectorList()
        local current = undone[1]
        table.remove(undone, 1)
        term.write(pos)
        term.write(" ")
        term.write(current)
        term.write(" ")
        term.write(current)
        term.write(" ")
        if not (current == pos) then
            term.write("-> " .. tostring(current - pos))
            go(current - pos)
        end

        local near = {}
        for i = 1, 6 do
            local add = true
            local v = getConnected(pos, i)
            for j = 1, #done do
                if done[j] == v then
                    add = false
                    break
                end
            end
            if add then
                table.insert(near, v)
            end
        end
        while #near > 0 do
            table.order(
                near,
                function(v)
                    local dir = getDir(v - pos)
                    if v.x < 0 then
                        return 2
                    elseif v.y ~= 0 then
                        return 1
                    else
                        return 0
                    end
                end
            )
            local v = near[1]
            local dir = getDir(v - pos)
            if dir.z > 0 then
                if inspect(2) then
                    addToUndone(v)
                end
            elseif dir.z < 0 then
                if inspect(3) then
                    addToUndone(v)
                end
            else
                if dir.x < 0 then
                    print("turn")
                    move(4)
                    move(4)
                elseif dir.y > 0 then
                    move(4)
                elseif dir.y < 0 then
                    move(5)
                end
                if inspect(1) then
                    addToUndone(v)
                end
            end
            table.remove(near, 1)
        end
    end

    clearVectorLists()

    local v = getConnected(base, 1)
    while #undone == 0 do
        addToUndone(v)
        v:set(v.x + 1)
    end
    base:set(v.x - 1, v.y, v.z)
end

table.insert(done, getConnected(pos, -1))
table.insert(done, pos:copy())
addToUndone(getConnected(pos, 1))
base:set(pos.x + 1, pos.y, pos.z)
while base.x < 20 do
    iteration()
end

go(start - pos)
while facing.x ~= 1 do
    move(4)
end
