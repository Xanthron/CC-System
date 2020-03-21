local size = 3
local threshold = math.floor(size ^ 0.5 + 1)
local placesPath, movePath, program = "os/programs/superMiner/data/places.set", "os/programs/superMiner/data/move.set", "os/programs/advanceExcavate/"
local places, move
local coal = 64 * 4
local inMove = false

local function getData()
    if fs.exists(placesPath) then
        places = dofile(placesPath)
        for i, v in ipairs(places.turtles) do
            vector.convert(v)
        end
        if places.chunkLoader then
            vector.convert(places.chunkLoader)
        end
    else
        places = {turtles = {}, chunkLoader = nil}
    end
    if false and fs.exists(movePath) then
        move = dofile(movePath)
        vector.convert(move.pos)
        vector.convert(move.facing)
    else
        move = {}
        move.pos = vector.zero:copy()
        move.facing = vector.forward:copy()
        move.mode = "start"
        move.lastTurtle = 0
    end
end
getData()

local function save()
    table.save(move, movePath)
end

local function savePositions()
    table.save(places, placesPath)
end

local function update(f, p, m)
    if m then
        inMove = true
    end
    if f then
        move.facing:set(move.facing.y * f.x, move.facing.x * f.y)
        save()
    -- label_facing.text = "Facing:   " .. getFacingText()
    -- label_facing:recalculate()
    -- label_facing:repaint("this")
    end
    if p then
        move.pos:set(move.pos.x + (p.x * move.facing.x + p.y * move.facing.y), move.pos.y + (p.x * move.facing.y + p.y * move.facing.x), move.pos.z + p.z)
        save()
    -- label_posX.text = "X: " .. move.pos.x
    -- label_posY.text = "Y: " .. move.pos.y
    -- label_posZ.text = "Z: " .. move.pos.z
    -- --label_moved.text = text_moved .. move.moved
    -- --label_distance.text = text_distance .. move.distance .. " / " .. data.length

    -- label_posX:recalculate()
    -- label_posY:recalculate()
    -- label_posZ:recalculate()
    -- --label_moved:recalculate()
    -- --label_distance:recalculate()

    -- label_posX:repaint("this")
    -- label_posY:repaint("this")
    -- label_posZ:repaint("this")
    --label_moved:repaint("this")
    --label_distance:repaint("this")
    end
    inMove = m
end

local function gotoDestination(v)
    return turtle.move.go(v - move.pos, update, move.facing)
end

local function checkHeight()
    local threshold = math.floor((move.pos.x ^ 2 + move.pos.y ^ 2) ^ 0.5 / size + 1) * threshold
    if turtle.digUp() then
        turtle.move.up(update)
        while move.pos.z <= threshold and turtle.digUp() do
            turtle.move.up(update)
        end
        return "top"
    else
        print("down")
        while move.pos.z >= -threshold and not turtle.digDown() do
            turtle.move.down(update)
        end
        return "bottom"
    end
end

local function placeFuel()
end

---Save!
local function placeTurtle(i, dir)
    print("place turtle")

    local slot = 8 + i
    local Dir
    local pos = places.turtles[i]
    if dir == "top" then
        Dir = "Up"
    else
        Dir = "Down"
    end
    turtle.select(1)
    local inspect, data = turtle["inspect" .. Dir]()
    if inspect and data.name:find("computercraft:turtle") then
        while turtle["suck" .. Dir]() do
        end
    else
        turtle.select(slot)
        while not turtle["place" .. Dir]() and turtle.getItemCount(slot) > 0 do
            turtle["dig" .. Dir]()
            turtle["attack" .. Dir]()
        end
    end
    placeFuel(dir)
    turtle.select(2)
    turtle["drop" .. Dir](1)
    --peripheral.wrap(dir).turnOn()
    redstone.setAnalogOutput(dir, 1)
    sleep(0.4)
    redstone.setAnalogOutput(dir, 0)
end

--Save!
local function placeChuckLoader()
    gotoDestination(places.chunkLoader + vector.down)
    turtle.select(8)
    while not turtle.placeUp() do
        turtle.digUp()
        turtle.attackUp()
    end
end

local function moveToNext(v)
    local next = vector.new(v[1], v[2], 0)
    -- if (move.pos.x ~= v.x or move.pos.y ~= v.y) and (move.pos.z == 1 or move.pos.z == -1) then
    --     local v = next - move.pos
    --     gotoDestination(move.pos + vector.new(math.clamp(-1, 1, v.x), math.clamp(-1, 1, v.y), 0))
    -- end
    gotoDestination(next)
end

local function checkInventory()
    turtle.select(2)
    turtle.place()

    local removeSlots = {7, 8}
    local coalSlots = {1, 3, 4, 5, 6}
    for i, v in ipairs(coalSlots) do
        local data = turtle.getItemDetail(v)
        if data and data.name ~= "minecraft:coal" then
            table.insert(removeSlots, v)
        end
    end
    for i = 9, 16 do
        local data = turtle.getItemDetail(i)
        if data and not data.name:find("computercraft:turtle") then
            table.insert(removeSlots, i)
        end
    end

    for i, v in ipairs(removeSlots) do
        turtle.select(v)
        local data = turtle.getItemDetail()
        if data then
            if data.name == "minecraft:coal" then
                for j, v2 in ipairs(coalSlots) do
                    turtle.transferTo(v2)
                    if turtle.getItemCount(v) == 0 then
                        break
                    end
                end
            elseif data.name:find("computercraft:turtle") then
                for j = 9, 16 do
                    turtle.transferTo(j)
                    if turtle.getItemCount(j) == 0 then
                        break
                    end
                end
            elseif data.name == "enderstorage:ender_storage" then
                turtle.transferTo(2)
            end
            turtle.drop()
        end
    end
    turtle.select(2)
    turtle.dig()
end

local positions = {
    {0, 0},
    {size, 0},
    {size * 2, 0},
    {size * 2, size},
    {size * 2, size * 2},
    {size, size * 2},
    {0, size * 2},
    {0, size}
}
while move.mode ~= "end" do
    if move.mode == "start" then
        local i = move.lastTurtle + 1
        moveToNext(positions[i])
        local dir
        if i == 1 then
            dir = "bottom"
        else
            dir = checkHeight()
        end
        places.turtles[i] = move.pos:copy() + IF(dir == "bottom", vector.down, vector.up)
        savePositions()
        turtle.move.look("forward", move.facing, update)
        placeTurtle(i, dir)
        move.lastTurtle = i
        if i >= 8 then
            move.mode = "turtleHeight"
        end
        save()
    elseif move.mode == "turtleHeight" then
        moveToNext({size, size})
        checkHeight()
        places.turtles[9] = move.pos:copy()
        savePositions()
        move.mode = "chunkLoader"
        save()
    elseif move.mode == "chunkLoader" then
        local maxZ = move.pos.z
        for i, v in ipairs(places.turtles) do
            maxZ = math.max(v.z, maxZ)
        end
        places.chunkLoader = vector.new(move.pos.x, move.pos.y, maxZ + 2)
        savePositions()
        placeChuckLoader()
        move.mode = "finish"
        save()
    elseif move.mode == "finish" then
        gotoDestination(places.turtles[9])
        turtle.move.look("forward", move.facing, update)
        move.mode = "setup"
        move.lastTurtle = 0
        save()
    elseif move.mode == "setup" then
        local movePath = program .. "data/data.set"
        if fs.exists(movePath) then
            fs.delete(movePath)
        end

        local dataPath = program .. "data/data.set"
        if fs.exists(dataPath) then
            fs.delete(dataPath)
        end
        fs.copy("os/programs/superMiner/data/copy.set", dataPath)

        local startPath = "os/startup/50-superMiner.lua"
        if not fs.exists(startPath) then
            local file = fs.open(startPath, "w")
            file.write('dofile("os/programs/superMiner/leader.lua")')
            file.close()
        end
        move.mode = "mine"
        save()
    elseif move.mode == "mine" then
        dofile(program .. "excavate.lua")
        move.mode = "destructTurtle"
        save()
    elseif move.mode == "destructTurtle" then
        local i = move.lastTurtle + 1
        gotoDestination(places.turtles[9 - i] + vector.up * 3)
        local inspect, data = turtle.inspectDown()
        while not (inspect and data.name:find("computercraft:turtle")) do
            sleep(3)
            inspect, data = turtle.inspectDown()
        end
        turtle.dig()
        checkInventory()
        turtle.select(1)
        while turtle.suckDown() do
        end
        turtle.select(8 + i)
        turtle.digDown()
        move.lastTurtle = i
        if i >= 8 then
            move.mode = "destructChunkLoader"
        end
        save()
    elseif move.mode == "destructChunkLoader" then
        gotoDestination(places.chunkLoader + vector.down)
        turtle.dig()
        checkInventory()
        turtle.select(8)
        turtle.digUp()
        move.mode = "startNew"
        save()
    elseif move.mode == "startNew" then
        gotoDestination(vector.new(0, size * 3, 0))
        checkHeight()
        move.pos = vector.zero:copy()
        move.mode = "start"
        move.lastTurtle = 0
        places.turtles = {}
        places.chunkLoader = nil
        savePositions()
        save()
    end
end
