ui.input.term = term
local _x, _y, _w, _h = 1, 1, term.getSize()

local size = 16
local threshold = math.floor(size ^ 0.5)
local placesPath, movePath, program = "os/programs/superMiner/data/places.set", "os/programs/superMiner/data/move.set", "os/programs/advanceExcavate/"
local places, move
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
    if fs.exists(movePath) then
        move = dofile(movePath)
        vector.convert(move.pos)
        vector.convert(move.facing)
        vector.convert(move.oldPos)
    else
        move = {}
        move.pos = vector.zero:copy()
        move.oldPos = vector.zero:copy()
        move.facing = vector.forward:copy()
        move.mode = 1
        move.lastTurtle = 0
    end
end
getData()

local function getFacingText()
    if move.facing.x > 0 then
        return "Forward"
    elseif move.facing.x < 0 then
        return "Back"
    elseif move.facing.y > 0 then
        return "Right"
    else
        return "Left"
    end
end

local input = ui.input.new()
local drawer = ui.drawer.new(input, _x, _y, _w, _h)
ui.buffer.fill(drawer.buffer, " ", colors.white, colors.white)

ui.label.new(drawer, "Super Miner Leader", theme.label1, _x, _y, _w, 1)
local label_pos = ui.label.new(drawer, "Position: ", theme.label2, _x, _y + 1, 10, 1)
local label_posX = ui.label.new(drawer, "X: " .. move.oldPos.x + move.pos.x, theme.label2, _x + 10, _y + 1, 8, 1)
local label_posY = ui.label.new(drawer, "Y: " .. move.oldPos.y + move.pos.y, theme.label2, _x + 19, _y + 1, 8, 1)
local label_posZ = ui.label.new(drawer, "Z: " .. move.oldPos.z + move.pos.z, theme.label2, _x + 28, _y + 1, 8, 1)
local label_facing = ui.label.new(drawer, "Facing:   " .. getFacingText(), theme.label2, _x, _y + 2, _w, 1)

ui.label.new(drawer, "Fuel Level:", theme.label2, _x, _y + 3, 11, 1)
local label_fuelLevel = ui.label.new(drawer, "0 / 0", theme.label2, _x + 12, _y + 3, _w - 12, 1)

local text_mode = ui.text.new(drawer, "Mode:\n\n\n\n\n", theme.label2, _x, _h - 6, _w, 3)
text_mode.scaleH = false
function text_mode:setText(text)
    self.text = text
    self:recalculate()
    self:repaint("this")
end

ui.label.new(drawer, "", theme.label1, _x, _h, _w, 1)
local button_exit = ui.button.new(drawer, "Exit", theme.button1, _x + _w - 6, _h, 6, 1)

local group_main = drawer.selectionManager:addNewGroup()
group_main:addElement(button_exit, nil, nil, nil, nil)
drawer.selectionManager:select(button_exit, "code", not term.isColor())

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
        label_facing.text = "Facing:   " .. getFacingText()
        label_facing:recalculate()
        label_facing:repaint("this")
    end
    if p then
        move.pos:set(move.pos.x + (p.x * move.facing.x + p.y * move.facing.y), move.pos.y + (p.x * move.facing.y + p.y * move.facing.x), move.pos.z + p.z)
        save()
        label_posX.text = "X: " .. (move.oldPos.x + move.pos.x)
        label_posY.text = "Y: " .. (move.oldPos.y + move.pos.y)
        label_posZ.text = "Z: " .. (move.oldPos.y + move.pos.z)
        label_posX:recalculate()
        label_posY:recalculate()
        label_posZ:recalculate()
        label_posX:repaint("this")
        label_posY:repaint("this")
        label_posZ:repaint("this")
    end
    inMove = m
end

local function gotoDestination(v)
    return turtle.move.go(v - move.pos, update, move.facing)
end

local function checkHeight()
    local threshold = math.floor((move.pos.x ^ 2 + move.pos.y ^ 2) ^ 0.5 / size + 1) * threshold
    if move.pos.z >= threshold then
        return "top"
    end
    turtle.move.up(update)
    if turtle.digUp() then
        if move.pos.z >= threshold then
            return "top"
        end
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

local function placeFuel(Dir)
    local amount = move.coal
    for i = 3, 6 do
        local data = turtle.getItemDetail(i)
        if data and data.name == "minecraft:coal" then
            turtle.select(i)
            turtle["drop" .. Dir](math.min(data.count, amount))
            amount = amount - data.count
        end
        if amount <= 0 then
            break
        end
    end
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
    placeFuel(Dir)
    turtle.select(2)
    turtle["drop" .. Dir](1)
    peripheral.wrap(dir).turnOn()
    sleep(0.2)
    redstone.setAnalogOutput(dir, 1)
    sleep(0.2)
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

local function loop()
    while true do
        if move.mode == 1 then
            text_mode:setText("Refuel")
            if turtle.getFuelLimit() > 0 then
                local neededFuel = size * 8 + threshold * 9 + 80
                while turtle.getFuelLevel() < neededFuel do
                    turtle.select(1)
                    turtle.refuel(1)
                    --TODO it could happen, that not enough coal is there but very unlikely
                end
                local amount = 0
                for i = 3, 6 do
                    turtle.select(i)
                    amount = amount + turtle.getItemCount()
                end
                move.coal = math.floor(amount / 8)
                move.mode = 2
                save()
            end
        elseif move.mode == 2 then
            text_mode:setText("Place Minions")
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
                move.mode = 3
            end
            save()
        elseif move.mode == 3 then
            text_mode:setText("Go to destination.")
            moveToNext({size, size})
            checkHeight()
            places.turtles[9] = move.pos:copy()
            savePositions()
            move.mode = 4
            save()
        elseif move.mode == 4 then
            text_mode:setText("Place Chunk Loader")
            local maxZ = move.pos.z
            for i, v in ipairs(places.turtles) do
                maxZ = math.max(v.z, maxZ)
            end
            places.chunkLoader = vector.new(move.pos.x, move.pos.y, maxZ + 4)
            savePositions()
            placeChuckLoader()
            move.mode = 5
            save()
        elseif move.mode == 5 then
            text_mode:setText("Go to destination")
            gotoDestination(places.turtles[9])
            turtle.move.look("forward", move.facing, update)
            move.mode = 6
            move.lastTurtle = 0
            save()
        elseif move.mode == 6 then
            text_mode:setText("Create Data")
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
            move.mode = 7
            save()
        elseif move.mode == 7 then
            text_mode:setText("Mine")
            dofile(program .. "excavate.lua")
            move.mode = 8
            save()
        elseif move.mode == 8 then
            text_mode:setText("Refuel")
            if turtle.getFuelLimit() > 0 then
                local neededFuel = size * 11 + threshold * 9 + 20
                turtle.select(1)
                while turtle.getFuelLevel() <= neededFuel do
                    turtle.refuel(1)
                end
            end
            move.mode = 9
            save()
        elseif move.mode == 9 then
            text_mode:setText("Remove Minions")
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
                move.mode = 10
            end
            save()
        elseif move.mode == 10 then
            text_mode:setText("Remove Chunk Loader")
            gotoDestination(places.chunkLoader + vector.down)
            turtle.dig()
            checkInventory()
            turtle.select(8)
            turtle.digUp()
            move.mode = 11
            save()
        elseif move.mode == 11 then
            text_mode:setText("Go to next position")
            gotoDestination(vector.new(size * 3, 0, 0))
            checkHeight()
            move.oldPos = move.pos:copy()
            move.pos = vector.zero:copy()
            move.mode = 1
            move.lastTurtle = 0
            places.turtles = {}
            places.chunkLoader = nil
            savePositions()
            save()
        end
    end
end

function button_exit:onClick(event)
    local files = {
        "os/startup/50-superMiner.lua",
        "os/programs/superMiner/data/move.set",
        "os/programs/advanceExcavate/data/data.set",
        "os/programs/advanceExcavate/data/move.set"
    }

    for i, v in ipairs(files) do
        if fs.exists(v) then
            fs.delete(v)
        end
    end
    input:exit()
end

drawer:draw()
parallel.waitForAny(
    function()
        input:eventLoop({[term] = drawer.event})
    end,
    loop
)
