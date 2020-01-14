local moves = {}
local list = {
    "minecraft:lapis_ore",
    "minecraft:diamond_ore",
    "minecraft:redstone_ore",
    "minecraft:coal_ore",
    "minecraft:iron_ore",
    "minecraft:gold_ore"
}
local function InspectMineDig(direction)
end
local function Check(mode)
    local success, data
    if mode == 1 then
        success, data = turtle.inspectUp()
    elseif mode == 2 then
        success, data = turtle.inspect()
    else
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
local function CheckAround(start)
    --forward down up left right
    if start == 1 then
        --if Check(2) then
        turtle.dig()
        turtle.forward()
        table.insert(moves, 1)
        CheckAround(1)
        turtle.back()
        table.remove(moves)
        --end
        start = 2
    end
    if start == 2 then
        if Check(1) then
            turtle.digDown()
            turtle.down()
            table.insert(moves, 2)
            CheckAround(1)
            turtle.up()
            table.remove(moves)
        end
        start = start + 1
    end
    if start == 3 then
        if Check(2) then
            turtle.digUp()
            turtle.up()
            table.insert(moves, 3)
            CheckAround(1)
            turtle.down()
            table.remove(moves)
        end
        start = start + 1
    end
    if start == 4 then
        turtle.turnLeft()
        table.insert(moves, 4)
        if Check(1) then
            CheckAround(1)
            start = start + 1
        end
        turtle.turnRight()
        table.remove(moves)
    end
    if start == 5 then
        turtle.turnRight()
        table.insert(moves, 5)
        if Check(1) then
            CheckAround(1)
        end
        turtle.turnLeft()
        table.remove(moves)
    end
end
while true do
    turtle.dig()
    turtle.forward()
    CheckAround(2)
end
