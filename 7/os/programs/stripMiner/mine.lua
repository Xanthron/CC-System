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

local slots = {}
slots.all = {}
for i = 1, 16 do
    if i < 5 then
        slots.all[i] = i
    else
        slots.all[i] = 0
    end
end
slots.data = {}
slots.data[1] = "minecraft:chest"
slots.data[2] = {name = "minecraft:coal", increase = 80}
slots.data[3] = "minecraft:torch"
slots.data[4] = "minecraft:cobblestone"
slots.chest = {}
slots.fuel = {}
slots.build = {}
slots.torch = {}
slots.enderChest = nil
slots.empty = {}
for i = 1, #slots.all do
    local id = slots.all[i]
    if id == 1 then
        table.insert(slots.chest, i)
    elseif id == 2 then
        table.insert(slots.fuel, i)
    elseif id == 3 then
        table.insert(slots.build, i)
    elseif id == 4 then
        table.insert(slots.torch, i)
    elseif id == 5 then
        slots.enderChest = i
    else
        table.insert(slots.empty, i)
    end
end

local function checkFuel(v1, v2)
    local fuelLimit = turtle.getFuelLimit()
    if fuelLimit == 0 then
        return true
    end
    local v = v1 - v2
    local distance, slot, fuelLevel, level = math.abs(v.x) + math.abs(v.y) + math.abs(v.z), turtle.getSelectedSlot(), turtle.getFuelLevel(), 0

    for i = 1, #slots.fuel do
        if distance < fuelLevel then
            turtle.select(slot)
            return true
        end
        local slot = slots.fuel[i]
        local name, increase = slots.data[slot].name, slots.data[slot].increase
        local detail = turtle.getItemDetail(slot)
        if detail and name == detail.name then
            local refuel = math.min(detail.count, math.floor((fuelLimit - fuelLevel) / increase))
            if refuel > 0 then
                turtle.select(slot)
                turtle.refuel(refuel)
            end
            level = level + (detail.count - refuel) * increase
            fuelLevel = turtle.getFuelLevel()
        end
    end
    --turtle.select(slot)
    if distance < fuelLevel + level then
        return true
    end
    return false
end

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
        if ((v.y <= 1 and v.y >= -1 and v.z == 0) and (v.z <= 1 or v.z >= -1 and v.y == 0) and (v - base):sqLength() < 10) then
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
    local v
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
        print("")
        if not (current == pos) then
            term.write("-> " .. tostring(current - pos))
            print("")
            if checkFuel(start, current) then
                print("go")
                go(current - pos)
            else
                print("go to start")
                --TODO zu erst auf den pfad und dann den weg zurück
                go(-pos)
                print("wait for fuel")
                os.pullEvent("turtle_inventory")
                while not checkFuel(start, current) do
                    print("no fuel")
                    os.pullEvent("turtle_inventory")
                end
                print("go to position")
                go(current)
            end
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
                    print("inspected up")
                    addToUndone(v)
                end
            elseif dir.z < 0 then
                if inspect(3) then
                    print("inspected down")
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
                    print("inspected front")
                    addToUndone(v)
                end
            end
            table.remove(near, 1)
        end
    end

    clearVectorLists()

    local v = getConnected(base, 1)
    while #undone == 0 do
        print("next iteration", v)
        addToUndone(v)
        v:set(v.x + 1)
    end
    base:set(v.x - 1, v.y, v.z)
end

print(#slots.fuel)

table.insert(done, getConnected(pos, -1))
table.insert(done, pos:copy())
base:set(pos.x + 1, pos.y, pos.z)
addToUndone(base)
while base.x <= 80 do
    iteration()
end
print("end")
go(start - pos)
while facing.x ~= 1 do
    move(4)
end
