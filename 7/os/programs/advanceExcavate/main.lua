ui.input.term = term

local savePath = "os/programs/advanceExcavate/data/move.set"
local set = {}
--dofile("os/programs/advanceExcavate/data/data.set")
set.size = 3
local move = {}
local inMove = false

local function getData()
    if false and fs.exists(savePath) then
        move = dofile(savePath)
        vector.convert(move.pos)
        vector.convert(move.facing)
    else
        move.pos = vector.zero:copy()
        move.facing = vector.forward:copy()
    end
end
getData()

local function save()
    table.save(move, savePath)
end

local function update(f, p, m)
    if m then
        inMove = true
    end
    if f then
        move.facing:set(move.facing.y * f.x, move.facing.x * f.y)
        save()
    end
    if p then
        move.pos:set(move.pos.x + (p.x * move.facing.x + p.y * move.facing.y), move.pos.y + (p.x * move.facing.y + p.y * move.facing.x), move.pos.z + p.z)
        save()
    end
    inMove = m
end

local function fillFuel()
    local data = turtle.getItemDetail(1)
    for i = 2, 16 do
        if data then
            if turtle.getItemSpace(1) == 0 then
                return
            end
            local new = turtle.getItemDetail(i)
            if new and new.name == data.name and new.damage == data.damage then
                turtle.select(i)
                turtle.transferTo(1)
            end
        else
            turtle.select(i)
            if turtle.refuel(1) then
                turtle.transferTo(1)
                data = turtle.getItemDetail(1)
            end
        end
    end
end

local function refuel(amount)
    local limit = turtle.getFuelLimit()
    if limit == 0 then
        return true
    end

    turtle.select(1)
    while true do
        if turtle.getItemCount(1) <= 1 then
            fillFuel()
        end
        if turtle.getItemCount(1) == 0 then
            return false
        elseif amount < turtle.getFuelLevel() then
            return true
        end
        turtle.refuel(1)
    end
end

local function getMoveDistance(from, to)
    local v = to - from
    return math.abs(v.x) + math.abs(v.y) + math.abs(v.z)
end

local function getNextPos(offset, current, size)
    local v = current - offset
    local elevation = math.min((v.z) % 6, 1) * 2 - 1
    local direction = (v.y % 2 * 2 - 1) * -elevation

    local x, y, z = 0, 0, 0
    if (direction < 0 and v.x < size) or (direction > 0 and v.x > 0) then
        x = -direction
    elseif (elevation < 0 and v.y < size) or (elevation > 0 and v.y > 0) then
        y = -elevation
    else
        z = -3
    end
    return vector.new(current.x + x, current.y + y, current.z + z)
end

local function mine()
    local offset = vector.new(1, 0, -1)
    turtle.move.go(offset, update)
    turtle.digUp()
    turtle.digDown()

    repeat
        turtle.digUp()
        turtle.digDown()
        local next = getNextPos(offset, move.pos, set.size - 1) - move.pos
        next:set(next.x * move.facing.x + next.y * move.facing.y, -next.x * move.facing.y + next.y * move.facing.x, next.z)
    until not turtle.move.go(next, update)
    turtle.move.go(vector.new(0, 0, -move.pos.z), update)
    turtle.move.go(turtle.move.dir(offset - move.pos, move.facing), update)
    turtle.move.go(vector.zero, update)
end
mine()

print("end")
