ui.input.term = term
local _x, _y, _w, _h = 1, 1, term.getSize()

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
        move.mode = 1
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
local label_posX = ui.label.new(drawer, "X: " .. move.pos.x, theme.label2, _x + 10, _y + 1, 8, 1)
local label_posY = ui.label.new(drawer, "Y: " .. move.pos.y, theme.label2, _x + 19, _y + 1, 8, 1)
local label_posZ = ui.label.new(drawer, "Z: " .. move.pos.z, theme.label2, _x + 28, _y + 1, 8, 1)
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
        label_posX:recalculate()
        label_posY:recalculate()
        label_posZ:recalculate()
        label_posX:repaint("this")
        label_posY:repaint("this")
        label_posZ:repaint("this")
    end
    inMove = m
end

local function loop()
    while true do
        if move.mode == 1 then
            text_mode:setText("Create data")
            local startPath = "os/startup/50-superMiner.lua"
            if not fs.exists(startPath) then
                local file = fs.open(startPath, "w")
                file.write('dofile("os/programs/superMiner/minion.lua")')
                file.close()
            end
            move.mode = 2
            save()
        elseif move.mode == 2 then
            text_mode:setText("Wait for start signal")
            os.pullEvent("redstone")
            move.mode = 3
            save()
        elseif move.mode == 3 then
            sleep(3)
            move.mode = 4
            save()
        elseif move.mode == 4 then
            text_mode:setText("Create data")
            local movePath = program .. "data/data.set"
            if fs.exists(movePath) then
                fs.delete(movePath)
            end

            local dataPath = program .. "data/data.set"
            if fs.exists(dataPath) then
                fs.delete(dataPath)
            end
            fs.copy("os/programs/superMiner/data/copy.set", dataPath)

            move.mode = 5
            save()
        elseif move.mode == 5 then
            text_mode:setText("Mine")
            dofile(program .. "excavate.lua")
            move.mode = 6
            save()
        elseif move.mode == 6 then
            text_mode:setText("Refuel")
            if turtle.getFuelLimit() > 0 and turtle.getFuelLevel() < 4 then
                turtle.select(1)
                turtle.refuel(1)
            end
            move.mode = 7
            save()
        elseif move.mode == 7 then
            text_mode:setText("Go to position")
            turtle.move.go(vector.up * 2 - move.pos, update, move.facing)
            if fs.exists(movePath) then
                fs.delete(movePath)
            end
            move.pos = vector.zero:copy()
            move.mode = "start"
            save()
            text_mode:setText("Wait for leader")
            while true do
                sleep(100)
            end
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
