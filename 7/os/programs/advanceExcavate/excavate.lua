ui.input.term = term
local _x, _y, _w, _h = 1, 1, term.getSize()

local savePath = "os/programs/advanceExcavate/data/move.set"
local setPath = "os/programs/advanceExcavate/data/data.set"
local startPath = "os/startup/50-advanceExcavate.lua"
local set = dofile(setPath)
local move = {}
local inMove = false
local offset = vector.new(0, 0, -1)
local trashList
local stop = false

local function getData()
    if fs.exists(savePath) then
        move = dofile(savePath)
        vector.convert(move.pos)
        vector.convert(move.facing)
        if move.next then
            vector.convert(move.next)
        end
    else
        move.pos = vector.zero:copy()
        move.facing = vector.forward:copy()
        move.excavated = 0
    end
    if set.pathTrashList then
        trashList = dofile(set.pathTrashList)
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

ui.label.new(drawer, "Advance Excavate", theme.label1, _x, _y, _w, 1)
local label_pos = ui.label.new(drawer, "Position: ", theme.label2, _x, _y + 1, 10, 1)
local label_posX = ui.label.new(drawer, "X: " .. move.pos.x, theme.label2, _x + 10, _y + 1, 8, 1)
local label_posY = ui.label.new(drawer, "Y: " .. move.pos.y, theme.label2, _x + 19, _y + 1, 8, 1)
local label_posZ = ui.label.new(drawer, "Z: " .. move.pos.z, theme.label2, _x + 28, _y + 1, 8, 1)
local label_facing = ui.label.new(drawer, "Facing:   " .. getFacingText(), theme.label2, _x, _y + 2, _w, 1)

ui.label.new(drawer, "Size:", theme.label2, _x, _y + 4, 11, 1)
local label_size = ui.label.new(drawer, tostring(set.size), theme.label2, _x + 12, _y + 4, _w - 12, 1)
--error("jo")

ui.label.new(drawer, "Excavated:", theme.label2, _x, _y + 5, 11, 1)
local label_excavated = ui.label.new(drawer, tostring(move.excavated or 0), theme.label2, _x + 12, _y + 5, _w - 12, 1)

ui.label.new(drawer, "Fuel Level:", theme.label2, _x, _y + 6, 11, 1)
local label_fuelLevel = ui.label.new(drawer, "0 / 0", theme.label2, _x + 12, _y + 6, _w - 12, 1)

local text_mode = ui.text.new(drawer, "Mode:\n\n\n", theme.label2, _x, _h - 4, _w, 3)
text_mode.scaleH = false
function text_mode:setText(text)
    self.text = text
    self:recalculate()
    self:repaint("this")
end

ui.label.new(drawer, "", theme.label1, _x, _h, _w, 1)
local button_pause = ui.button.new(drawer, IF(move.pause, "Resume", "Pause"), theme.button1, _x, _h, 8, 1)
local button_stop = ui.button.new(drawer, "Stop", theme.button1, _x + _w - 12, _h, 6, 1)
local button_exit = ui.button.new(drawer, "Exit", theme.button1, _x + _w - 6, _h, 6, 1)

local group_main = drawer.selectionManager:addNewGroup()
group_main:addElement(button_pause, nil, nil, button_stop, nil)
group_main:addElement(button_stop, button_pause, nil, button_exit, nil)
group_main:addElement(button_exit, button_stop, nil, nil, nil)
drawer.selectionManager:select(button_pause, "code", not term.isColor())

local function save()
    table.save(move, savePath)
end

local function deleteFiles()
    if fs.exists(savePath) then
        fs.delete(savePath)
    end
    if fs.exists(setPath) then
        fs.delete(setPath)
    end
    if fs.exists(startPath) then
        fs.delete(startPath)
    end
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
        label_posX.text = "X: " .. move.pos.x
        label_posY.text = "Y: " .. move.pos.y
        label_posZ.text = "Z: " .. move.pos.z
        --label_moved.text = text_moved .. move.moved
        --label_distance.text = text_distance .. move.distance .. " / " .. data.length

        label_posX:recalculate()
        label_posY:recalculate()
        label_posZ:recalculate()
        --label_moved:recalculate()
        --label_distance:recalculate()

        label_posX:repaint("this")
        label_posY:repaint("this")
        label_posZ:repaint("this")
    --label_moved:repaint("this")
    --label_distance:repaint("this")
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

local function refuelTo(amount)
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

local function checkFuelLevel(distance)
    if turtle.getFuelLimit() == 0 then
        return true
    end
    local level = turtle.getFuelLevel
    if distance < level() then
        turtle.select(1)
        label_fuelLevel.text = level() .. " / " .. distance
        label_fuelLevel:recalculate()
        label_fuelLevel:repaint("this")
        return true
    end
    if refuelTo(distance) then
        label_fuelLevel.text = level() .. " / " .. distance
        label_fuelLevel:recalculate()
        label_fuelLevel:repaint("this")
        return true
    else
        fillFuel()
        label_fuelLevel.text = level() .. " / " .. distance
        label_fuelLevel:recalculate()
        label_fuelLevel:repaint("this")
        return refuelTo(distance)
    end
end

local function makeSpace()
    local free = false
    if trashList then
        local space = 0
        for i = IF(set.enderChest, 3, 2), 16 do
            local ret = not set.trashWhiteList
            local data = turtle.getItemDetail(i)
            if data then
                for k, v in pairs(trashList) do
                    if v[1] == data.name and IF(v[2], v[2] == data.damage, true) then
                        ret = not ret
                        break
                    end
                end
                if ret then
                    turtle.select(i)
                    turtle.dropDown()
                    space = space + 1
                end
                if space > 2 then
                    free = true
                end
            end
        end
    end
    turtle.select(1)
    return free
end

local function hasSpace()
    local free = false
    for i = IF(set.enderChest, 3, 2), 16 do
        if turtle.getItemCount(i) == 0 then
            return true
        end
    end
    fillFuel()
    for i = IF(set.enderChest, 3, 2), 16 do
        if turtle.getItemCount(i) == 0 then
            free = true
            break
        end
    end
    if not free and trashList then
        free = makeSpace()
    end
    return free
end

local function getNextPos(offset, current, size)
    local v = current - offset
    local elevation
    if set.mineMode then
        elevation = math.min((v.z) % 6, 1) * 2 - 1
    else
        elevation = math.min((v.z) % 2, 1) * 2 - 1
    end
    local direction = (v.y % 2 * 2 - 1) * -elevation

    local x, y, z = 0, 0, 0
    if (direction < 0 and v.x < size) or (direction > 0 and v.x > 0) then
        x = -direction
    elseif (elevation < 0 and v.y < size) or (elevation > 0 and v.y > 0) then
        y = -elevation
    else
        if set.mineMode then
            z = -3
        else
            z = -1
        end
    end
    return vector.new(current.x + x, current.y + y, current.z + z)
end

local function gotoDestination(v)
    return turtle.move.go(v - move.pos, update, move.facing)
end

local function gotoStart()
    turtle.move.go(vector.new(0, 0, -move.pos.z + math.min(0, offset.z)), update)
    gotoDestination(vector.zero)
    --turtle.move.go(vector.new(move.pos.x, move.pos.y, 0), update, move.facing)
end

local function gotoNext()
    gotoDestination(offset)
    gotoDestination(vector.new(move.next.x, move.next.y, move.pos))
    gotoDestination(move.next)
end

local function setMode(mode)
    move.mode = mode

    if mode == "empty_chest" then
        --fillFuel()
        if set.enderChest == true then
            text_mode:setText("Empty Chest\nPlace Ender Chest and emptying inventory.")
            turtle.select(2)
            turtle.digUp()
            turtle.placeUp()
            for i = 3, 16 do
                if turtle.getItemCount(i) > 0 then
                    turtle.select(i)
                    turtle.dropUp()
                end
            end
            turtle.select(2)
            turtle.digUp()
            turtle.select(1)
        else
            text_mode:setText("Empty Chest\nGo to Start position.")
            --turtle.move.go(turtle.move.dir(offset, move.facing), update)
            gotoStart()
            turtle.move.look("back", move.facing, update)
            text_mode:setText("Empty Chest\nEmptying inventory.")
            for i = 2, 16 do
                if turtle.getItemCount(i) > 0 then
                    turtle.select(i)
                    turtle.drop()
                end
            end
            turtle.select(1)
            if not checkFuelLevel(getMoveDistance(move.pos, move.next) * 2 + 2) then
                setMode("request_fuel")
            end
            text_mode:setText("Resume mining\nGo back to position.")
            gotoNext()
        end
    elseif mode == "request_fuel" then
        text_mode:setText("Request Fuel\nGo to Start position.")
        gotoStart()
        local amount = getMoveDistance(vector.zero, move.next) + 20
        text_mode:setText(("Request Fuel\nA fuel level of %s is needed.\nCurrent fuel level is %s."):format(amount, turtle.getFuelLevel()))
        while true do
            if checkFuelLevel(amount) then
                break
            end
            os.pullEvent("turtle_inventory")
        end
        text_mode:setText("Resume mining\nGo back to position.")
        gotoNext()
    elseif mode == "stop" then
        button_pause:changeMode(2, true)
        button_stop:changeMode(2, true)
        button_exit:changeMode(2, true)
        text_mode:setText("Stop\nGo back to start position.")
        gotoStart()
        text_mode:setText("Stop\nEmptying inventory.")
        if set.enderChest == true then
            turtle.select(2)
            turtle.digUp()
            turtle.placeUp()
            for i = 3, 16 do
                if turtle.getItemCount(i) > 0 then
                    turtle.select(i)
                    turtle.dropUp()
                end
            end
            turtle.select(2)
            turtle.digUp()
            turtle.select(1)
        else
            turtle.move.look("back", move.facing, update)
            for i = 2, 16 do
                if turtle.getItemCount(i) > 0 then
                    turtle.select(i)
                    turtle.drop()
                end
            end
            turtle.select(1)
        end
        turtle.move.look("forward", move.facing, update)
        text_mode:setText("Stop")
        deleteFiles()
        input:exit()
    end

    turtle.select(1)

    move.mode = nil
end

local function mine()
    if move.mode then
        setMode(move.mode)
    elseif not hasSpace() then
        setMode("empty_chest")
    elseif move.next then
        text_mode:setText("Resume mining\nGo back to position.")
        if not checkFuelLevel(getMoveDistance(move.pos, move.next) + 1) then
            setMode("request_fuel")
        end
        gotoDestination(vector.new(move.next.x, move.next.y, move.pos.z))
        gotoDestination(move.next)
    else
        text_mode:setText("Mining\nGo to start position.")
        if not checkFuelLevel(getMoveDistance(vector.zero, offset) + 1) then
            setMode("request_fuel")
        end
        gotoDestination(offset)
        turtle.digUp()
        turtle.digDown()
    end
    text_mode:setText("Mining")

    repeat
        if not hasSpace() then
            setMode("empty_chest")
            text_mode:setText("Mining")
        end
        if set.mineMode == true then
            if turtle.digUp() and not hasSpace() then
                setMode("empty_chest")
                text_mode:setText("Mining")
            end
            if turtle.digDown() and not hasSpace() then
                setMode("empty_chest")
                text_mode:setText("Mining")
            end
        end
        move.excavated = move.excavated + 3
        label_excavated.text = tostring(move.excavated)
        label_excavated:recalculate()
        label_excavated:repaint("this")
        move.next = getNextPos(offset, move.pos, set.size - 1) -- move.pos
        if not checkFuelLevel(getMoveDistance(vector.zero, move.next) + 1) then
            setMode("request_fuel")
            text_mode:setText("Mining")
        end
    until stop or not gotoDestination(move.next)
    setMode("stop")
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
    stop = true
    button_pause:changeMode(2, true)
    button_stop:changeMode(2, true)
    button_exit:changeMode(2, true)
end
function button_exit:onClick(event)
    deleteFiles()
    input:exit()
end

local function execute()
    input:eventLoop({[term] = drawer.event})
end

drawer:draw()
while true do
    if move.pause then
        if parallel.waitForAny(waitForPause, execute) == 2 then
            break
        end
    else
        local exit = parallel.waitForAny(mine, waitForPause, execute)
        if exit == 1 then
            button_pause:changeMode(2, true)
            button_stop:changeMode(2, true)
            button_exit:changeMode(1, true)
            execute()
            break
        elseif exit == 3 then
            break
        end
    end
end
