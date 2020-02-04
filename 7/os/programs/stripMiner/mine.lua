--TODO Daten einladen
--TODO Enderchest
--TODO Menu
--TODO trash
--TODO Statistik
--TODO Pause

local function mine()
    local start = vector.zero:copy()
    local success, move = fs.doFile("os/programs/stripMiner/data/move.set")
    if not success then
        move = {}
        move.pos = start:copy()
        move.facing = vector.forward:copy()
        move.base = start:copy()
        ---@type vector[]
        move.undone = {}
        ---@type vector[]
        move.done = {}
        move.mode = {name = nil, data = nil}
    else
        vector.convert(move.pos)
        vector.convert(move.facing)
        vector.convert(move.base)
        for i = 1, #move.undone do
            vector.convert(move.undone[i])
        end
        for i = 1, #move.done do
            vector.convert(move.done[i])
        end
    end

    local success, data = fs.doFile("os/programs/stripMiner/data/data.set")
    local mineList = dofile(data.pathSearchList)
    if data.pathTrashList then
        local trashList = dofile(data.pathTrashList)
    end
    local slots = {}
    slots.all = data.slots
    slots.data = {}
    slots.data[1] = "minecraft:chest"
    slots.data[2] = {name = "minecraft:coal", increase = 80}
    slots.data[3] = "minecraft:cobblestone"
    slots.data[4] = "minecraft:torch"
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

    local placeTorch = false
    local update, startMode

    local function fillBuild(slot)
        local ret = false
        local name = slots.data[slot]
        for i = 1, #slots.empty do
            local s = slots.empty[i]
            local data = turtle.getItemDetail(s)
            print(name, data)
            if data and data.name == name then
                turtle.select(s)
                turtle.transferTo(slot)
                ret = true
            end
            if turtle.getItemSpace(slot) == 0 then
                return true
            end
        end
        return ret
    end
    local function checkBuild()
        for i = 1, #slots.build do
            local slot = slots.build[i]
            if turtle.getItemCount(slot) > 1 then
                return true
            else
                if fillBuild(slot) then
                    return true
                end
            end
        end
        return false
    end
    local function selectBuild()
        if checkBuild() then
            for i = 1, #slots.build do
                local slot = slots.build[i]
                if turtle.getItemCount(slot) > 1 then
                    turtle.select(slot)
                    return
                end
            end
        else
            error("no buildingblock")
        end
    end

    local function checkTorch()
        for i = 1, #slots.torch do
            local slot = slots.torch[i]
            if turtle.getItemCount(slot) > 0 then
                return true
            end
        end
        return false
    end
    local function selectTorch()
        if not checkTorch() then
            error("no buildingblock")
        else
            for i = 1, #slots.torch do
                local slot = slots.torch[i]
                if turtle.getItemCount(slot) > 0 then
                    turtle.select(slot)
                    return
                end
            end
        end
    end

    local function checkChest()
        for i = 1, #slots.chest do
            local slot = slots.chest[i]
            if turtle.getItemCount(slot) > 0 then
                return true
            end
        end
        return false
    end
    local function selectChest()
        if not checkTorch() then
            error("no buildingblock")
        else
            for i = 1, #slots.chest do
                local slot = slots.chest[i]
                if turtle.getItemCount(slot) > 0 then
                    turtle.select(slot)
                    return
                end
            end
        end
    end

    local function checkFuelLevel(v1, v2)
        local fuelLimit = turtle.getFuelLimit()
        if fuelLimit == 0 then
            return true
        end
        local v = v1 - v2
        local distance, fuelLevel, level = math.abs(v.x) + math.abs(v.y) + math.abs(v.z), turtle.getFuelLevel(), 0

        for i = 1, #slots.fuel do
            if distance < fuelLevel then
                turtle.select(1)
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
        turtle.select(1)
        if distance < fuelLevel + level then
            return true
        end
        return false
    end

    local function setCurrentPos(x, y, z)
        move.pos:set(x, y, z)
        for i = 1, #move.undone do
            if move.undone[i] == move.pos then
                table.remove(move.undone, i)
                return
            end
        end
    end
    local function addToUndone(v)
        for i = 1, #move.done do
            if move.done[i] == v then
                return
            end
        end
        local clone = v:copy()
        table.insert(move.done, clone)
        table.insert(move.undone, clone)
    end
    local function removeVector(v)
        for i = 1, #move.undone do
            if move.undone[i] == v then
                table.remove(move.undone, i)
                break
            end
        end
    end
    local function clearVectorLists()
        table.clear(move.undone)
        local i = 1
        local v1, v2 = vector.new(move.base.x - 5, move.base.y - 1, move.base.z - 1), vector.new(move.base.x + 5, move.base.y + 1, move.base.z + 2)
        while i <= #move.done do
            local v = move.done[i]
            if vector.contains(v1, v2, v) then
                i = i + 1
            else
                table.remove(move.done, i)
            end
        end
    end
    local function getDir(dir)
        dir:set(dir.x * move.facing.x + dir.y * move.facing.y, dir.x * -move.facing.y + dir.y * move.facing.x)
        return dir
    end
    local function orderVectorList()
        table.orderComplex(
            move.undone,
            ---@type vector
            function(v)
                local value = 0
                local dir = getDir(v - move.pos)
                if dir.x > 0 then
                    value = 1
                elseif dir.x < 0 then
                    value = 3
                elseif dir.y ~= 0 then
                    value = 2
                end

                return (v - move.pos):sqLength(), (v - move.base).x, value
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
            for _, v in ipairs(mineList) do
                if v == data.name then
                    return true
                end
            end
        end
        return false
    end

    local function turn(dir)
        if dir == 1 then
            if move.facing.x < 0 then
                turtle.move.turnRight(update)
                turtle.move.turnRight(update)
            elseif move.facing.y > 0 then
                turtle.move.turnRight(update)
            elseif move.facing.y < 0 then
                turtle.move.turnLeft(update)
            end
        elseif dir == 2 then
            if move.facing.y < 0 then
                turtle.move.turnRight(update)
                turtle.move.turnRight(update)
            elseif move.facing.x > 0 then
                turtle.move.turnRight(update)
            elseif move.facing.x < 0 then
                turtle.move.turnLeft(update)
            end
        elseif dir == 3 then
            if move.facing.x > 0 then
                turtle.move.turnRight(update)
                turtle.move.turnRight(update)
            elseif move.facing.y > 0 then
                turtle.move.turnLeft(update)
            elseif move.facing.y < 0 then
                turtle.move.turnRight(update)
            end
        elseif dir == 4 then
            if move.facing.y > 0 then
                turtle.move.turnRight(update)
                turtle.move.turnRight(update)
            elseif move.facing.x > 0 then
                turtle.move.turnLeft(update)
            elseif move.facing.x < 0 then
                turtle.move.turnRight(update)
            end
        end
    end
    ---@param v vector
    local function goToDestination(v)
        if not move.mode.name and not checkFuelLevel(start, move.pos) then
            startMode("fuel", move.pos)
        end

        local go = v - move.pos
        print("GO:", go)
        local chest = vector.new(move.base.x - 1, 0, move.base.z)
        if v ~= chest and ((go.x < 0 and move.pos.x > chest.x) or (go.x > 0 and move.pos.x < chest.x)) and (move.pos.y == 0 and go.z ~= 0 and math.min(v.z, move.pos.z) <= chest.z and math.min(v.z, move.pos.z) >= chest.z) then
            if move.facing.y == 0 then
                turtle.move.turnRight(update)
            end
            turtle.move.forward(update)
            goToDestination(v)
        else
            turtle.move.go(getDir(go), update)
        end
    end

    local function checkSpace()
        local free = false
        for i = 1, #slots.empty do
            if turtle.getItemCount(slots.empty[i]) == 0 then
                return true
            end
        end

        return false
    end

    local function save()
        table.save(move, "os/programs/stripMiner/data/move.set")
    end

    local gotoChest = false
    update = function(f, p)
        if f then
            move.facing:set(move.facing.y * f.x, move.facing.x * f.y)
            save()
        end
        if p then
            move.pos:set(move.pos.x + (p.x * move.facing.x + p.y * move.facing.y), move.pos.y + (p.x * move.facing.y + p.y * move.facing.x), move.pos.z + p.z)
            save()

            if move.mode.name then
                startMode("clear", move.pos)
            end
        end
        --sleep(5)
    end

    startMode = function(mode, position)
        move.mode.name = mode
        move.mode.data = position
        save()

        if mode == "fuel" then
            goToDestination(vector.new(move.pos.x, 0, 0))
            goToDestination(start)
            print("wait for fuel")
            os.pullEvent("turtle_inventory")
            while not checkFuelLevel(start, move.base + vector.forward * 40) do
                print("no fuel")
                os.pullEvent("turtle_inventory")
            end
        elseif mode == "chest" then
            goToDestination(vector.new(move.pos.x, 0, 0))
            goToDestination(start)
            print("wait for Chest")
            os.pullEvent("turtle_inventory")
            while not checkChest() do
                print("no Chest")
                os.pullEvent("turtle_inventory")
            end
        elseif mode == "torch" then
            goToDestination(vector.new(move.pos.x, 0, 0))
            goToDestination(start)
            print("wait for Torch")
            os.pullEvent("turtle_inventory")
            while not checkChest() do
                print("no Torch")
                os.pullEvent("turtle_inventory")
            end
        elseif mode == "build" then
            goToDestination(vector.new(move.pos.x, 0, 0))
            goToDestination(start)
            print("wait for Build")
            os.pullEvent("turtle_inventory")
            while not checkChest() do
                print("no Build")
                os.pullEvent("turtle_inventory")
            end
        elseif mode == "wall" then
            if not (move.pos.x == move.base.x and move.pos.y == 0 and move.pos.z >= 0 and move.pos.z <= 1) then
                goToDestination(vector.new(move.base.x, 0, move.pos.z))
                goToDestination(vector.new(move.base.x, 0, math.min(1, math.max(0, move.pos.z))))
            end

            if move.facing.x == -1 then
                turtle.move.turnLeft(update)
            elseif move.facing.x == 1 then
                turtle.move.turnRight(update)
            end

            selectBuild()
            turtle.place()
            turtle.move.turnRight(update)
            turtle.move.turnRight(update)
            selectBuild()
            turtle.place()
            if move.pos.z == 0 then
                selectBuild()
                turtle.placeDown()
                --TODO check for fuel when moving and stone
                goToDestination(move.pos + vector.up)
                selectBuild()
                turtle.placeUp()
            else
                selectBuild()
                turtle.placeUp()
                goToDestination(move.pos + vector.down)
                selectBuild()
                turtle.placeDown()
            end
            selectBuild()
            turtle.place()
            turtle.move.turnRight(update)
            turtle.move.turnRight(update)
            selectBuild()
            turtle.place()
        elseif mode == "light" then
            placeTorch = false
            goToDestination(move.pos + vector.down)

            selectTorch()
            if not turtle.placeUp() then
                placeTorch = true
            end
        elseif mode == "clear" and not checkSpace() then
            goToDestination(move.base + vector.up)
            turn(3)

            if turtle.inspect() then
                turtle.dig()
                placeTorch = true
            end
            selectChest()
            turtle.place()
            for i = 1, #slots.empty do
                local slot = slots.empty[i]
                if turtle.getItemCount(slot) > 0 then
                    turtle.select(slot)
                    turtle.drop()
                end
            end
            turtle.select(1)
        end
        print("go to position")
        if move.pos ~= position then
            goToDestination(vector.new(position.x, 0, 1))
            goToDestination(position)
        end

        move.mode.name = nil
        move.mode.data = nil
    end

    local function checkSurrounding()
        local near = {}
        for i = 1, 6 do
            local add = true
            local v = getConnected(move.pos, i)
            for j = 1, #move.done do
                if move.done[j] == v then
                    add = false
                    break
                end
            end
            if add then
                table.insert(near, v)
            end
        end
        while #near > 0 do
            table.orderComplex(
                near,
                function(v)
                    local dir = getDir(v - move.pos)
                    if dir.x > 0 then
                        return 1
                    elseif dir.x < 0 then
                        return 3
                    elseif dir.y ~= 0 then
                        return 2
                    else
                        return 1
                    end
                end
            )
            local v = near[1]
            local dir = getDir(v - move.pos)
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
                    turtle.move.turnRight(update)
                    turtle.move.turnRight(update)
                elseif dir.y > 0 then
                    turtle.move.turnRight(update)
                elseif dir.y < 0 then
                    turtle.move.turnLeft(update)
                end
                if inspect(1) then
                    addToUndone(v)
                end
            end
            table.remove(near, 1)
        end
    end
    local function iteration()
        while #move.undone > 0 do
            orderVectorList()
            local current = move.undone[1]
            table.remove(move.undone, 1)
            term.write(move.pos)
            term.write(" ")
            term.write(current)
            term.write(" ")
            print("")
            if not (current == move.pos) then
                print("->", current - move.pos)
                goToDestination(current)
            end

            checkSurrounding()
        end

        clearVectorLists()
    end

    if #move.done == 0 then
        table.insert(move.done, getConnected(move.pos, -1))
        table.insert(move.done, move.pos:copy())
        move.base:set(move.base.x + 1, move.base.y, move.base.z)
        addToUndone(move.base)
        addToUndone(move.base + vector.up)
        iteration()
    elseif move.mode.name then
        startMode(move.mode.name, move.mode.data)
    else
        checkSurrounding()
    end
    if #move.undone > 0 then
        iteration()
    end
    while move.base.x <= data.length or data.length == 0 do
        if #slots.build > 0 then --TODO build mode
            iteration()
            startMode("wall", move.pos)

            if #slots.torch and (placeTorch or (move.base.x - 1) % 12 == 0) then
                startMode("light", move.pos)
            end

            turtle.select(1)

            move.base:set(move.base.x + 1, move.base.y, move.base.z)
            addToUndone(move.base)
            addToUndone(move.base + vector.up)
        else
            iteration()
            local v = vector.new(move.base.x + 1, move.base.y, move.base.z)
            while #move.undone == 0 do
                addToUndone(v)
                addToUndone(v + vector.down)
                v:set(v.x + 1)
            end
            move.base:set(v.x - 1, v.y, v.z)
        end
    end

    goToDestination(start)
    turn(1)
    fs.delete("os/programs/stripMiner/data/move.set")
    fs.delete("os/programs/stripMiner/data/data.set")
end
local co = coroutine.create(parallel.waitForAny)
coroutine.resume(co, mine)
