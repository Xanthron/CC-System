local movePath = "os/programs/superMiner/data/move.set"
local program = "os/programs/advanceExcavate/"

local move
local inMove = false

local function getData()
    if fs.exists(movePath) then
        move = dofile(movePath)
        vector.convert(move.pos)
        vector.convert(move.facing)
    else
        move = {}
        move.pos = vector.zero:copy()
        move.facing = vector.forward:copy()
        move.mode = "start"
    end
end
getData()

local function save()
    table.save(move, movePath)
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

local function minion()
    while true do
        if move.mode == "start" then
            local startPath = "os/startup/50-superMiner.lua"
            if not fs.exists(startPath) then
                local file = fs.open(startPath, "w")
                file.write('dofile("os/programs/superMiner/minion.lua")')
                file.close()
            end
            move.mode = "waitOrder"
            save()
        elseif move.mode == "waitOrder" then
            os.pullEvent("redstone")
            move.mode = "waitStart"
            save()
        elseif move.mode == "waitStart" then
            sleep(3)
            move.mode = "setup"
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

            move.mode = "mine"
            save()
        elseif move.mode == "mine" then
            dofile(program .. "excavate.lua")
            move.mode = "finish"
            save()
        elseif move.mode == "finish" then
            turtle.move.go(vector.up * 2 - move.pos, update, move.facing)
            if fs.exists(movePath) then
                fs.delete(movePath)
            end
            move.pos = vector.zero:copy()
            move.mode = "start"
            save()
            while true do
                sleep(100)
            end
        end
    end
end
minion()
