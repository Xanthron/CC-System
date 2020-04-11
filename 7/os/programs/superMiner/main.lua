ui.input.term = term

local _x, _y, _w, _h = 1, 1, term.getSize()

local input = ui.input.new()
local drawer = ui.drawer.new(input, _x, _y, _w, _h)
ui.buffer.fill(drawer.buffer, " ", colors.white, colors.white)
local text = "[tc=red]Super Miner[tc=clear] is a program wrapped around [tc=red]Advance Excavate[tc=clear] to create a self building quarry working till infinity.\n\n[tc=red]9 Mining Turtles[tc=clear] will excavate a [tc=red]3x3 chunk square[tc=clear] where every [tc=red]Turtle[tc=clear] will excavate one [tc=red]chunk[tc=clear].\n\nThe [tc=red]Leader[tc=clear] is responsible for building up the [tc=red]quarry[tc=clear] by placing the [tc=red]Minions[tc=clear] and the [tc=red]chunk loader[tc=clear]. After every [tc=red]Mining Turtle[tc=clear] is finished the [tc=red]Leader[tc=clear] will collect all placed objects and move to the next position.\n\nTo launch the [tc=red]quarry[tc=clear] correctly every [tc=red]Turtle[tc=clear] must have installed [tc=red]Super Miner[tc=clear] and [tc=red]Advance Excavate[tc=clear]. [tc=red]8 Turtle[tc=clear] have to be set as [tc=red]Minion[tc=clear] through [tc=red]Super Miner[tc=clear] the last [tc=red]Turtle[tc=clear] hast to be also a [tc=red]Chunky Turtle[tc=clear] (Mod: PeripheralPlusOne) and the [tc=red]inventory[tc=clear] filled like, described later. Then it can be set as [tc=red]Leader[tc=clear] and start.\n\nThe [tc=red]inventory[tc=clear] gets filled like the following:\n[tc=red]Slot 1: 64x Coal\nSlot 2: 9x Ender Chest\nSlot 3 - 6: 64x Coal\nSlot 8: 1x Chunk Loader\nSlot 9 - 16: 1x Mining Turtle (Minion)[tc=clear]\n\nTotal item list:\n[tc=red]320x (5 Stacks) Coal\n9x Ender Chest\n1x Chunk Loader\n8x Mining Turtle (Minion)[tc=clear]"
local tBox_text = ui.textBox.new(drawer, nil, text, theme.tBox2, _x, _y, _w, _h)

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
drawer.selectionManager:select(button_minion, "code", not term.isColor())

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
clearData()

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
