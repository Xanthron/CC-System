ui.input.term = term

local _x, _y, _w, _h = 1, 1, term.getSize()

local input = ui.input.new()
local drawer = ui.drawer.new(input, _x, _y, _w, _h)
ui.buffer.fill(drawer.buffer, " ", colors.white, colors.white)

local tBox_text = ui.textBox.new(drawer, nil, "1\n2\n3\n4\n5\n6\n7\n8\n9\n10\n11\n12\n13\n14\n15", theme.tBox2, _x, _y, _w, _h)

ui.label.new(tBox_text, "Super Miner", theme.label1, _x, _y, _w - 3, 1)
local button_exit = ui.button.new(tBox_text, "<", theme.button2, _x + _w - 3, _y, 3, 1)

ui.label.new(tBox_text, "", theme.label1, _x, _y + _h - 1, _w, 1)
local button_minion = ui.button.new(tBox_text, "Minion", theme.button1, _x + _w - 16, _y + _h - 1, 8, 1)
local button_leader = ui.button.new(tBox_text, "Leader", theme.button1, _x + _w - 8, _y + _h - 1, 8, 1)

local group_main = tBox_text.selectionGroup
drawer.selectionManager:addGroup(group_main)
local group_top = drawer.selectionManager:addNewGroup(nil, nil, group_main.listener)
local group_bottom = drawer.selectionManager:addNewGroup(nil, nil, group_main.listener)
group_top.next, group_top.previous = group_bottom, group_bottom
group_bottom.next, group_bottom.previous = group_top, group_top

group_top:addElement(button_exit, nil, nil, nil, group_bottom)
group_bottom:addElement(button_minion, nil, group_top, button_leader, nil)
group_bottom:addElement(button_leader, button_minion, group_top, nil, nil)

group_top.current = button_exit
drawer.selectionManager:select(button_minion, "code", term.isColor())

local function clearData()
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
end

function button_exit:onClick(event)
    input:exit()
end

function button_minion:onClick(event)
    input:callFunction(
        function()
            clearData()
            dofile("os/programs/superMiner/minion.lua")
            input:exit()
        end
    )
end
function button_leader:onClick(event)
    input:callFunction(
        function()
            clearData()
            dofile("os/programs/superMiner/leader.lua")
            input:exit()
        end
    )
end

drawer:draw()
input:eventLoop({[term] = drawer.event})
