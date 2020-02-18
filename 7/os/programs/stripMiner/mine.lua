local inMove = false
local start = vector.zero:copy()
local way = vector.up:copy()
local move, slots, mineList, trashList, data
local _x, _y, _w, _h = 1, 1, term.getSize()

local text_fuel, text_facing, text_distance, text_moved, text_detected = "Fuel:            ", "Facing:          ", "Distance Moved:  ", "Total    Moved:  ", "Detected Blocks: "

local manager = ui.uiManager.new(_x, _y, _w, _h)
for i = 1, _w * _h do
    if i <= _w or i > _w * (_h - 1) then
        manager.buffer.text[i] = " "
        manager.buffer.textColor[i] = colors.green
        manager.buffer.textBackgroundColor[i] = colors.green
    else
        manager.buffer.text[i] = " "
        manager.buffer.textColor[i] = colors.white
        manager.buffer.textBackgroundColor[i] = colors.white
    end
end
local label_title = ui.label.new(manager, "Strip Miner", theme.label1, _x, _y, _w, 1)

local label_pos = ui.label.new(manager, "Position: ", theme.label2, _x, _y + 1, 10, 1)
local label_posX = ui.label.new(manager, "X: 0", theme.label2, _x + 10, _y + 1, 8, 1)
local label_posY = ui.label.new(manager, "Y: 0", theme.label2, _x + 19, _y + 1, 8, 1)
local label_posZ = ui.label.new(manager, "Z: 0", theme.label2, _x + 28, _y + 1, 8, 1)

local label_fuel = ui.label.new(manager, text_fuel .. turtle.getFuelLevel() .. " / 0", theme.label2, _x, _y + 3, _w, 1)

local label_facing = ui.label.new(manager, text_facing .. "Forward", theme.label2, _x, _y + 4, _w, 1)
local label_distance = ui.label.new(manager, text_distance .. "0", theme.label2, _x, _y + 5, _w, 1)
local label_moved = ui.label.new(manager, text_moved .. "0", theme.label2, _x, _y + 6, _w, 1)
local label_detected = ui.label.new(manager, text_detected .. "0", theme.label2, _x, _y + 7, _w, 1)

local label_mode = ui.label.new(manager, "Mine", theme.label2, _x, _y + 9, _w, 3)
label_mode:setGlobalRect(nil, nil, _w, 3)
label_mode.scaleH = false
label_mode.scaleW = false

local button_pause = ui.button.new(manager, "Pause", theme.button1, _x, _h, 8, 1)
if move and move.pause then
    button_pause.text = "Resume"
    button_pause:recalculate()
    button_pause:repaint("this")
end
local button_stop = ui.button.new(manager, "Stop", theme.button1, _x + _w - 12, _h, 6, 1)
local button_exit = ui.button.new(manager, "Exit", theme.button1, _x + _w - 6, _h, 6, 1)

local group_mainMenu = manager.selectionManager:addNewGroup()
group_mainMenu.current = button_pause
group_mainMenu:addElement(button_pause, nil, nil, button_stop, nil)
group_mainMenu:addElement(button_stop, button_pause, nil, button_exit, nil)
group_mainMenu:addElement(button_exit, button_stop, nil, nil, nil)

manager:draw()

local function loadSlots()
    slots = {}
    slots.all = data.slots
    slots.data = {}
    slots.chest = {}
    slots.fuel = {}
    slots.build = {}
    slots.torch = {}
    slots.enderChest = nil
    slots.empty = {}

    local function waifForData(slot)
        while turtle.getItemCount(slot) == 0 do
            os.pullEvent("turtle_inventory")
        end
    end

    for i = 1, #slots.all do
        local id = slots.all[i]
        if id == 1 then
            label_mode.text = ("Collecting chest data.\nPlease insert chest in slot %s."):format(i)
            label_mode:recalculate()
            label_mode:repaint("this")
            waifForData(i)
            slots.data[i] = turtle.getItemDetail(i).name
            table.insert(slots.chest, i)
        elseif id == 2 then
            label_mode.text = ("Collecting fuel data.\nPlease insert fuel in slot %s."):format(i)
            label_mode:recalculate()
            label_mode:repaint("this")
            local right = false
            while right == false do
                while turtle.getItemCount(i) <= 1 do
                    os.pullEvent("turtle_inventory")
                end
                turtle.select(i)
                local level = turtle.getFuelLevel()
                if turtle.refuel(1) then
                    level = turtle.getFuelLevel() - turtle.getFuelLimit()
                    slots.data[i] = {name = turtle.getItemDetail(i).name, increase = level}
                    if turtle.getFuelLevel() == turtle.getFuelLimit() then
                        slots.data[i].increase = 80
                    end
                    right = true
                end
            end
            table.insert(slots.fuel, i)
        elseif id == 3 then
            label_mode.text = ("Collecting build data.\nPlease insert blocks in slot %s."):format(i)
            label_mode:recalculate()
            label_mode:repaint("this")
            waifForData(i)
            slots.data[i] = turtle.getItemDetail(i).name
            table.insert(slots.build, i)
        elseif id == 4 then
            label_mode.text = ("Collecting torch data.\nPlease insert torches in slot %s."):format(i)
            label_mode:recalculate()
            label_mode:repaint("this")
            waifForData(i)
            slots.data[i] = turtle.getItemDetail(i).name
            table.insert(slots.torch, i)
        elseif id == 5 then
            label_mode.text = ("Collecting ender chest data.\nPlease insert one ender chest in slot %s."):format(i)
            label_mode:recalculate()
            label_mode:repaint("this")
            waifForData(i)
            slots.enderChest = i
        else
            table.insert(slots.empty, i)
        end
    end
end
local function loadData()
    local success
    success, move = fs.doFile("os/programs/stripMiner/data/move.set")
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
    if not move.distance then
        move.distance = 0
        move.moved = 0
        move.detected = 0
        move.pause = false
    end

    success, data = fs.doFile("os/programs/stripMiner/data/data.set")
    mineList = dofile(data.pathSearchList)
    if data.pathTrashList then
        trashList = dofile(data.pathTrashList)
    end
    if not data.slot then
        loadSlots()
        table.save(data, "os/programs/stripMiner/data/data.set")
    else
        slots = data.slots
    end
end
loadData()

local function save()
    table.save(move, "os/programs/stripMiner/data/move.set")
end

local function update(f, p, m)
    if m then
        inMove = true
    end
    if f then
        move.facing:set(move.facing.y * f.x, move.facing.x * f.y)
        local facing
        if move.facing.x == 1 then
            facing = "Forward"
        elseif move.facing.x == -1 then
            facing = "Backward"
        elseif move.facing.y == 1 then
            facing = "Right"
        else
            facing = "Left"
        end
        save()

        label_facing.text = text_facing .. facing

        label_facing:recalculate()

        label_facing:repaint("this")
    end
    if p then
        move.pos:set(move.pos.x + (p.x * move.facing.x + p.y * move.facing.y), move.pos.y + (p.x * move.facing.y + p.y * move.facing.x), move.pos.z + p.z)
        move.moved = move.moved + math.abs(p.x) + math.abs(p.y) + math.abs(p.z)
        move.distance = math.max(move.distance, move.pos.x)
        save()

        label_posX.text = "X: " .. move.pos.x
        label_posY.text = "Y: " .. move.pos.y
        label_posZ.text = "Z: " .. move.pos.z
        label_moved.text = text_moved .. move.moved
        label_distance.text = text_distance .. move.distance

        label_posX:recalculate()
        label_posY:recalculate()
        label_posZ:recalculate()
        label_moved:recalculate()
        label_distance:recalculate()

        label_posX:repaint("this")
        label_posY:repaint("this")
        label_posZ:repaint("this")
        label_moved:repaint("this")
        label_distance:repaint("this")

        manager:draw()
    end
    inMove = m
end

local function mine()
    --local chestPos = vector.down:copy()
    local placeTorch = false
    local startMode

    local function fillBuild(slot)
        local ret = false
        local name = slots.data[slot]
        for i = 1, #slots.empty do
            local s = slots.empty[i]
            local data = turtle.getItemDetail(s)
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
    local function checkBuild(count)
        count = count or 0
        for i = 1, #slots.build do
            local slot = slots.build[i]
            local slotCount = turtle.getItemCount(slot) - 1
            if slotCount > count then
                return true
            else
                if fillBuild(slot) then
                    slotCount = turtle.getItemCount(slot) - 1
                    if slotCount > count then
                        return true
                    else
                        count = count - slotCount
                    end
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
            startMode("build", move.pos)
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
        if checkTorch() then
            for i = 1, #slots.torch do
                local slot = slots.torch[i]
                if turtle.getItemCount(slot) > 0 then
                    turtle.select(slot)
                    return
                end
            end
        else
            startMode("torch", move.pos)
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
        if checkChest() then
            for i = 1, #slots.chest do
                local slot = slots.chest[i]
                if turtle.getItemCount(slot) > 0 then
                    turtle.select(slot)
                    return
                end
            end
        else
            startMode("chest", move.pos)
        end
    end

    local function getNeededFuelLevel(v1, v2)
        local v = v1 - v2
        return math.abs(v.x) + math.abs(v.y) + math.abs(v.z)
    end
    local function checkFuelLevel(distance)
        local fuelLimit = turtle.getFuelLimit()
        if fuelLimit == 0 then
            return true
        end
        local fuelLevel, level = turtle.getFuelLevel(), 0

        for i = 1, #slots.fuel do
            if distance < fuelLevel then
                turtle.select(1)
                label_fuel.text = text_fuel .. fuelLevel .. " / " .. distance
                label_fuel:recalculate()
                label_fuel:repaint("this")
                return true
            end
            local slot = slots.fuel[i]
            local name, increase = slots.data[slot].name, slots.data[slot].increase
            local detail = turtle.getItemDetail(slot)
            if detail and name == detail.name then
                local refuel = math.min(detail.count - 1, math.ceil((distance - fuelLevel) / increase))
                if refuel > 0 then
                    turtle.select(slot)
                    turtle.refuel(refuel)
                end
                level = level + (detail.count - refuel) * increase
                fuelLevel = turtle.getFuelLevel()
            end
        end
        turtle.select(1)
        label_fuel.text = text_fuel .. fuelLevel + level .. " / " .. distance
        label_fuel:recalculate()
        label_fuel:repaint("this")
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
                return false
            end
        end
        local clone = v:copy()
        table.insert(move.done, clone)
        table.insert(move.undone, clone)
        return true
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
        if not move.mode.name and not checkFuelLevel(getNeededFuelLevel(start, move.pos)) then
            startMode("fuel", move.pos)
        end

        local go = v - move.pos
        local chest = vector.new(move.base.x, 0, 0)
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
                free = true
                break
            end
        end

        if not free and trashList then
            local space = 0
            for i = 1, #slots.empty do
                local slot = slots.empty[i]
                local data = turtle.getItemDetail(slot)
                if data then
                    for j = 1, #trashList do
                        if (data.name == trashList[i]) == (data.trashWhiteList == "White List") then --TODO Whitelist
                            turtle.select(slot)
                            turtle.drop()
                            space = space + 1
                            break
                        end
                    end
                end
                if space > 2 then
                    free = true
                    break
                end
            end
        end

        return free
    end

    local gotoChest = false

    startMode = function(mode, position)
        move.mode.name = mode
        move.mode.data = position
        save()

        if mode == "fuel" then
            label_mode.text = "Fuel is to low!\nGo back to start and request fuel."
            label_mode:recalculate()
            label_mode:repaint("this")

            goToDestination(vector.new(move.pos.x, 0, way.z))
            goToDestination(way)

            label_mode.text = "Fuel is to low!\nPlease insert enough fuel."
            label_mode:recalculate()
            label_mode:repaint("this")

            repeat
                os.pullEvent("turtle_inventory")
            until checkFuelLevel(getNeededFuelLevel(start, move.base) + 40)
        elseif mode == "chest" then
            label_mode.text = "Chest is required to empty inventory!\nGo back to start and request chest."
            label_mode:recalculate()
            label_mode:repaint("this")

            goToDestination(vector.new(move.pos.x, 0, way.z))
            goToDestination(way)

            label_mode.text = "Chest is required to empty inventory!\nPlease insert enough chests."
            label_mode:recalculate()
            label_mode:repaint("this")

            repeat
                os.pullEvent("turtle_inventory")
            until checkChest()
        elseif mode == "torch" then
            label_mode.text = "Torches are required to light the way!\nGo back to start and request torches."
            label_mode:recalculate()
            label_mode:repaint("this")

            goToDestination(vector.new(move.pos.x, 0, way.z))
            goToDestination(way)

            label_mode.text = "Torches are required to light the way!\nPlease insert enough torches."
            label_mode:recalculate()
            label_mode:repaint("this")

            repeat
                os.pullEvent("turtle_inventory")
            until checkChest()
        elseif mode == "build" then
            label_mode.text = "Blocks are required to build the way!\nGo back to start and request blocks."
            label_mode:recalculate()
            label_mode:repaint("this")

            goToDestination(vector.new(move.pos.x, 0, way.z))
            goToDestination(way)

            label_mode.text = "Blocks are required to build the way!\nPlease insert enough blocks."
            label_mode:recalculate()
            label_mode:repaint("this")

            repeat
                os.pullEvent("turtle_inventory")
            until checkChest(6)
        elseif mode == "wall" then
            label_mode.text = "A safe path is being built."
            label_mode:recalculate()
            label_mode:repaint("this")

            if not (move.pos.x == move.base.x and move.pos.y == 0 and move.pos.z >= 0 and move.pos.z <= 1) then
                goToDestination(vector.new(move.base.x, 0, move.pos.z))
                goToDestination(vector.new(move.base.x, 0, math.min(1, math.max(0, move.pos.z))))
            end

            if move.facing.x == -1 then
                turn(4)
            elseif move.facing.x == 1 then
                turn(2)
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
            label_mode.text = "Path is being illuminated."
            label_mode:recalculate()
            label_mode:repaint("this")

            placeTorch = false
            goToDestination(move.base + way)

            selectTorch()
            if not turtle.placeDown() then
                placeTorch = true
            end
        elseif mode == "clear" and slots.enderChest then
            label_mode.text = "Inventory gets cleared."
            label_mode:recalculate()
            label_mode:repaint("this")

            if inspect(2) then
                if addToUndone(getConnected(position, 2)) then
                    move.detected = move.detected + 1
                end
                label_detected.text = text_detected .. move.detected
                label_detected:recalculate()
                label_detected:repaint("this")
            end
            turtle.digUp()
            turtle.select(slot.enderChest)
            turtle.placeUp()
            for i = 1, #slots.empty do
                local slot = slots.empty[i]
                turtle.select(slot)
                turtle.droptUp()
            end
            turtle.select(slot.enderChest)
            turtle.digUp()
        elseif mode == "clear" then
            label_mode.text = "Inventory gets cleared."
            label_mode:recalculate()
            label_mode:repaint("this")
            goToDestination(move.base)
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
        end
        turtle.select(1)
        label_mode.text = "Move to resume position."
        label_mode:recalculate()
        label_mode:repaint("this")
        if move.pos ~= position then
            goToDestination(vector.new(position.x, 0, way.z))
            goToDestination(position)
        end
        label_mode.text = "Continue Mining."
        label_mode:recalculate()
        label_mode:repaint("this")

        move.mode.name = nil
        move.mode.data = nil
    end

    local function checkSurrounding()
        label_mode.text = "Inspect surrounding blocks."
        label_mode:recalculate()
        label_mode:repaint("this")
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
                    if addToUndone(v) then
                        move.detected = move.detected + 1
                    end
                end
            elseif dir.z < 0 then
                if inspect(3) then
                    if addToUndone(v) then
                        move.detected = move.detected + 1
                    end
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
                    if addToUndone(v) then
                        move.detected = move.detected + 1
                    end
                end
            end
            label_detected.text = text_detected .. move.detected
            label_detected:recalculate()
            label_detected:repaint("this")
            table.remove(near, 1)
        end
    end
    local function iteration()
        while #move.undone > 0 do
            orderVectorList()
            local current = move.undone[1]
            table.remove(move.undone, 1)
            if not (current == move.pos) then
                if not checkSpace() then
                    startMode("clear", move.pos)
                end
                label_mode.text = "Mine blocks."
                label_mode:recalculate()
                label_mode:repaint("this")
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
        if #slots.build > 0 then
            iteration()

            if not move.mode.name and not checkFuelLevel(getNeededFuelLevel(start, move.pos) + 3) then
                startMode("fuel", move.pos)
            end

            if not checkBuild(6) then
                startMode("build", move.pos)
            end

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

    label_mode.text = "Finished Job!\nGo back to start."
    label_mode:recalculate()
    label_mode:repaint("this")
    goToDestination(way)
    goToDestination(start)
    turn(1)
    fs.delete("os/programs/stripMiner/data/move.set")
    fs.delete("os/programs/stripMiner/data/data.set")
end

local checkPause = true
local function waitForPause()
    while checkPause or inMove == true do
        coroutine.yield()
    end
    move.pause = not move.pause
    checkPause = true
    save()
    if move.pause == true then
        button_pause.text = "Resume"
        button_pause:recalculate()
        button_pause:repaint("this")
    else
        button_pause.text = "Pause"
        button_pause:recalculate()
        button_pause:repaint("this")
    end
end

function button_pause:onClick(event)
    checkPause = false
end

function button_stop:onClick(event)
    data.length = -1
    button_pause:changeMode(2, true)
    button_stop:changeMode(2, true)
    button_exit:changeMode(2, true)
end
function button_exit:onClick(event)
    manager:exit()
end

while manager._exit == false do
    if move.pause then
        local exit = parallel.waitForAny(waitForPause, manager.execute)
    else
        local exit = parallel.waitForAny(mine, waitForPause, manager.execute)
        if exit == 1 then
            button_pause:changeMode(2, true)
            button_stop:changeMode(2, true)
            button_exit:changeMode(1, true)
            manager.execute()
        end
    end
end
