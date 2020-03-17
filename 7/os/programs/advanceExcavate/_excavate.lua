local argSize, argEnderChest = ...

local width, height = term.getSize()

path = "programs/advancedExcavate/"
os.loadAPI(path .. "api/move")

local mode = "mine"
local size = 0
local useEnderchest = 0
local backX = 0
local backY = 0
local backZ = 0
local backF = 1

local x = 0
local y = 0
local z = 0
local f = 1

local sortItems = {}
if fs.exists("programs/advancedExcavate/itemList.list") then
    local t = fileN.readLines("programs/advancedExcavate/itemList.list")
    if t[1] == "--itemList" then
        for i = 2, #t do
            table.insert(sortItems, t[i])
        end
    end
end

function info()
    screen.clear(colors.white)
    screen.setTextColor(colors.black)
    screen.clearLine(colors.lime)
    term.write(stringN.setCenter("Advanced Excavate", "", width - 3))
    screen.setBackgroundColor(colors.white)
    term.setCursorPos(1, 2)
    if useEnderchest == 1 then
        term.write("Chest Mode  : Ender Chest")
    else
        term.write("Chest Mode  : Normal Chest")
    end

    term.setCursorPos(1, 3)
    term.write("Mining Mode : " .. string.upper(mode))
    term.setCursorPos(1, 4)
    term.write("Size        : ")
    term.write(size)
    term.setCursorPos(1, 5)
    term.write("Position")
end

function save()
    local file = fs.open(path .. "startInfo", "w")
    file.writeLine(mode)
    file.writeLine(size)
    file.writeLine(useEnderchest)
    file.writeLine(backX)
    file.writeLine(backY)
    file.writeLine(backZ)
    file.writeLine(backF)
    file.close()
    info()
end

function refuel()
    need = (x + z - y) * 2 + size
    if mode == "refuel" then
        need = ((backX + backZ - backY) * 2 + size) * 2
    end
    if turtle.getFuelLevel() < need then
        for i = 1, 16 do
            if turtle.getItemCount(i) > 0 then
                turtle.select(i)
                while turtle.refuel(1) do
                    if turtle.getFuelLevel() >= need then
                        return true
                    end
                end
            end
        end
        return false
    end
    return true
end

function checkFuel()
    if refuel() == false then
        backX = x
        backY = y
        backZ = z
        backF = f
        mode = "refuel"
        save()
        return false
    end
    turtle.select(1)
    return true
end

function checkInventory()
    for i = 1, 16 do
        if turtle.getItemCount(i) == 0 then
            return true
        end
    end
    backX = x
    backY = y
    backZ = z
    backF = f
    mode = "clear"
    save()
    return false
end

function clearInventory(side)
    refuelItem = 0
    for i = 1, 16 do
        if turtle.getItemCount(i) > 0 then
            turtle.select(i)
            if refuelItem == 0 then
                if turtle.refuel(1) then
                    refuelItem = i
                else
                    if side == "up" then
                        local itemData = turtle.getItemDetail()
                        if fileN.contains(itemData.name .. ";" .. itemData.damage, sortItems) then
                            turtle.dropDown()
                        else
                            turtle.dropUp()
                        end
                    elseif side == "front" then
                        local itemData = turtle.getItemDetail()
                        if fileN.contains(itemData.name .. ";" .. itemData.damage, sortItems) then
                            turtle.dropUp()
                        else
                            turtle.drop()
                        end
                    end
                end
            else
                if side == "up" then
                    local itemData = turtle.getItemDetail()
                    if fileN.contains(itemData.name .. ";" .. itemData.damage, sortItems) then
                        turtle.dropDown()
                    else
                        turtle.dropUp()
                    end
                elseif side == "front" then
                    local itemData = turtle.getItemDetail()
                    if fileN.contains(itemData.name .. ";" .. itemData.damage, sortItems) then
                        turtle.dropUp()
                    else
                        turtle.drop()
                    end
                end
            end
        end
    end
    if refuelItem > 0 then
        turtle.select(refuelItem)
        turtle.transferTo(1)
    end
    turtle.select(1)
end

function goUp()
    if y < 0 then
        move.up()
    elseif z > 0 then
        if f == 1 then
            move.turnLeft()
        elseif f == 2 then
            move.turnRight()
        elseif f == 3 then
            move.turnRight()
        else
            move.forward()
        end
    elseif x > 0 then
        if f == 1 then
            move.turnRight()
        elseif f == 2 then
            move.turnRight()
        elseif f == 4 then
            move.turnLeft()
        else
            move.forward()
        end
    else
        if f == 1 then
            move.turnRight()
        elseif f == 2 then
            move.turnRight()
        elseif f == 4 then
            move.turnLeft()
        else
            return true
        end
    end
    return false
end

function goDown()
    if x < backX then
        if f == 2 then
            move.turnLeft()
        elseif f == 3 then
            move.turnRight()
        elseif f == 4 then
            move.turnRight()
        else
            move.forward()
        end
    elseif z < backZ then
        if f == 1 then
            move.turnRight()
        elseif f == 3 then
            move.turnLeft()
        elseif f == 4 then
            move.turnRight()
        else
            move.forward()
        end
    elseif y > backY then
        move.down()
    else
        return true
    end
    return false
end

function forward()
    if checkInventory() == false then
        return
    end
    turtle.digUp()
    if checkInventory() == false then
        return
    end
    turtle.digDown()
    if checkFuel() == false then
        return
    end
    if checkInventory() == false then
        return
    end
    if move.forward() == false then
        mode = "end"
        save()
    end
end

function sleep5()
    sleep(5)
end

function pressEnter()
    while true do
        local e, p = os.pullEvent("key_up")
        if p == keys.enter then
            break
        end
    end
end

if fs.exists(path .. "startInfo") and argSize == nil then
    screen.clear(colors.white)
    screen.setTextColor(colors.black)
    screen.clearLine(colors.lime)
    term.write(stringN.setCenter("Advanced Excavate", "", width - 3))
    screen.setBackgroundColor(colors.white)
    term.setCursorPos(1, 2)
    term.write("press Enter to exit...")
    if parallel.waitForAny(pressEnter, sleep5) == 1 then
        if fs.exists(path .. "moveInfo") then
            fs.delete(path .. "moveInfo")
        end
        if fs.exists(path .. "startInfo") then
            fs.delete(path .. "startInfo")
        end
        size = 0
        useEnderchest = 0
        startN.removeStartup()
    else
        local lines = fileN.readLines(path .. "startInfo")
        mode = lines[1]
        size = tonumber(lines[2])
        useEnderchest = tonumber(lines[3])
        backX = tonumber(lines[4])
        backY = tonumber(lines[5])
        backZ = tonumber(lines[6])
        backF = tonumber(lines[7])
        move.start()
        x, y, z, f = move.getPos()
    end
elseif argSize ~= nil then
    if fs.exists(path .. "moveInfo") then
        fs.delete(path .. "moveInfo")
    end
    if fs.exists(path .. "startInfo") then
        fs.delete(path .. "startInfo")
    end
    size = tonumber(argSize)
    if size == nil then
        size = 0
    end
    if argEnderChest == "true" then
        useEnderchest = 1
    else
        useEnderchest = 0
    end
end

local anyButton = false
local isClick = false
local event
local par1
local par2
local par3
local par4
local par5

local intSelected = 2

local text = ""
local intEditPos = 0
local intOffset = 0

function header()
    screen.clear(colors.white)
    screen.setTextColor(colors.black)
    screen.clearLine(colors.lime)
    term.write(stringN.setCenter("Advanced Excavate", "", width - 3))
    screen.setBackgroundColor(colors.white)
    term.setCursorPos(14, 8)
    if useEnderchest == 1 then
        term.write("Ender Chest (slot 16)")
    else
        term.write("Normal Chest")
    end
end

header()
while size == 0 do
    if event == "key" then
        if intSelected == 0 then
            intSelected = 2
        elseif intSelected == 1 then
            if par1 == keys.tab then
                intSelected = 4
            elseif par1 == keys.down or par1 == keys.s then
                intSelected = 2
            end
        elseif intSelected == 2 then
            if par1 == keys.up or par1 == keys.tab then
                intSelected = 1
            elseif par1 == keys.down then
                intSelected = 3
            end
        elseif intSelected == 3 then
            if par1 == keys.up or par1 == keys.w or par1 == keys.tab then
                intSelected = 2
            elseif par1 == keys.down or par1 == keys.s then
                intSelected = 4
            end
        elseif intSelected == 4 then
            if par1 == keys.up or par1 == keys.w or par1 == keys.tab then
                intSelected = 3
            end
        end
    elseif event == "mouse_click" then
        intSelected = 0
    end

    screen.setBackgroundColor(colors.white)
    screen.setTextColor(colors.black)

    term.setCursorPos(width - 2, 1)
    clicked, anyButtonClicked = button.create(anyButtonClicked, event, par1, par2, par3, 0, (intSelected == 1), {"X", " ", " ", "[", "]"}, {keys.enter, keys.space}, {colors.black, colors.red, colors.white, colors.red})
    if clicked then
        term.setCursorBlink(false)
        screen.clear(colors.black)
        screen.setTextColor(colors.white)
        break
    end

    if event == "mouse_click" then
        if par2 >= 1 and par2 <= width and par3 >= 4 and par3 <= 6 then
            clicked = true
            anyButtonClicked = true
        end
    elseif event == "monitor_touch" then
        if par1 >= 1 and par1 <= width and par2 >= 4 and par2 <= 6 then
            clicked = true
            anyButtonClicked = true
        end
    elseif event == "key_up" and intSelected == 2 then
        if par1 == keys.enter then
            clicked = true
            anyButtonClicked = true
        end
    end
    if clicked then
        if par1 == keys.enter then
            term.setCursorBlink(false)
            if string.len(text) > 0 then
                local ret = tonumber(text)
                if ret ~= nil and ret > 0 then
                    size = ret
                    break
                end
            end
        else
            intSelected = 2
        end
    end

    term.setCursorPos(2, 8)
    clicked, anyButtonClicked = button.create(anyButtonClicked, event, par1, par2, par3, 0, (intSelected == 3), {"Chestmode", " ", " ", "[", "]"}, {keys.enter, keys.space}, {colors.black, colors.gray, colors.orange, colors.gray})
    if clicked then
        if useEnderchest == 1 then
            useEnderchest = 0
        else
            useEnderchest = 1
        end
        header()
    end

    term.setCursorPos(2, 10)
    clicked, anyButtonClicked = button.create(anyButtonClicked, event, par1, par2, par3, 0, (intSelected == 4), {"Start", " ", " ", "[", "]"}, {keys.enter, keys.space}, {colors.black, colors.gray, colors.orange, colors.gray})
    if clicked then
        term.setCursorBlink(false)
        local ret = tonumber(text)
        if ret ~= nil and ret > 0 then
            size = ret
            break
        else
            intSelected = 2
        end
    end

    if intSelected == 2 then
        term.setCursorBlink(true)
        screen.setTextColor(colors.white)
        screen.setBackgroundColor(colors.blue)
        term.setCursorPos(1, 4)
        term.write("+[Size]" .. string.rep("-", width - 8) .. "+")
        term.setCursorPos(1, 5)
        term.write(string.rep("|", width))
        term.setCursorPos(1, 6)
        term.write("+" .. string.rep("-", width - 2) .. "+")
        screen.setBackgroundColor(colors.white)
        screen.setTextColor(colors.black)
        term.setCursorPos(2, 5)
        term.write(string.rep(" ", width - 2))
        term.setCursorPos(2, 5)
        text, intEditPos, intOffset = screen.inputField(event, par1, text, intEditPos, intOffset, width - 2, true)
        text = string.gsub(text, " ", "_")
    else
        term.setCursorBlink(false)
        screen.setTextColor(colors.black)
        screen.setBackgroundColor(colors.blue)
        term.setCursorPos(1, 4)
        term.write("+-Size-" .. string.rep("-", width - 8) .. "+")
        term.setCursorPos(1, 5)
        term.write(string.rep("|", width))
        term.setCursorPos(1, 6)
        term.write("+" .. string.rep("-", width - 2) .. "+")
        screen.setBackgroundColor(colors.white)

        term.setCursorPos(2, 5)
        term.write(stringN.cutRight(text, "..", width - 2))
    end

    term.setCursorPos(intEditPos - intOffset + 2, 5)

    if anyButtonClicked then
        anyButtonClicked = false
        event = nil
        par1 = nil
        par2 = nil
        par3 = nil
        par4 = nil
        par5 = nil
    else
        while true do
            event, par1, par2, par3, par4, par5 = os.pullEvent()
            if event == "mouse_click" or event == "mouse_up" or event == "mouse_scroll" or event == "monitor_touch" or event == "key" or event == "key_up" or event == "char" then
                break
            end
        end
    end
end

if size > 0 then
    startN.setAsStartup("programs/advancedExcavate/advancedExcavate", {})
    save()

    local size1, size2 = math.modf(size / 2)
    size2 = size2 * 2 * (size - 1)
    while true do
        term.setCursorPos(1, 6)
        term.write("X: ")
        print(x)
        term.write("Y: ")
        print(y)
        term.write("Z: ")
        print(z)
        term.setCursorPos(1, 9)
        term.write("Fuel Level: ")
        print(turtle.getFuelLevel())
        if mode == "mine" then
            local y1, y2 = math.modf((y + 1) / 3)
            local y3, y4 = math.modf(y1 / 2)
            local z1, z2 = math.modf(z / 2)
            if y2 > 0 or (y4 == 0 and x == size2 and z == size - 1) or (y4 < 0 and x == 0 and z == 0) then
                if checkFuel() then
                    turtle.digUp()
                    if move.down() == false then
                        mode = "end"
                        save()
                    else
                        checkInventory()
                    end
                end
            elseif y4 < 0 then
                if z2 + math.abs(y4) == 0.5 then
                    if x == 0 then
                        if f == 1 then
                            move.turnLeft()
                        elseif f == 2 then
                            move.turnRight()
                        elseif f == 3 then
                            move.turnRight()
                        else
                            forward()
                        end
                    else
                        if f == 1 then
                            move.turnLeft()
                        elseif f == 2 then
                            move.turnRight()
                        elseif f == 4 then
                            move.turnLeft()
                        else
                            forward()
                        end
                    end
                else
                    if x == size - 1 then
                        if f == 1 then
                            move.turnLeft()
                        elseif f == 2 then
                            move.turnRight()
                        elseif f == 3 then
                            move.turnRight()
                        else
                            forward()
                        end
                    else
                        if f == 2 then
                            move.turnLeft()
                        elseif f == 3 then
                            move.turnRight()
                        elseif f == 4 then
                            move.turnRight()
                        else
                            forward()
                        end
                    end
                end
            else
                if z2 + math.abs(y4) == 0.5 then
                    if x == 0 then
                        if f == 1 then
                            move.turnRight()
                        elseif f == 3 then
                            move.turnLeft()
                        elseif f == 4 then
                            move.turnRight()
                        else
                            forward()
                        end
                    else
                        if f == 1 then
                            move.turnLeft()
                        elseif f == 2 then
                            move.turnRight()
                        elseif f == 4 then
                            move.turnLeft()
                        else
                            forward()
                        end
                    end
                else
                    if x == size - 1 then
                        if f == 1 then
                            move.turnRight()
                        elseif f == 3 then
                            move.turnLeft()
                        elseif f == 4 then
                            move.turnRight()
                        else
                            forward()
                        end
                    else
                        if f == 2 then
                            move.turnLeft()
                        elseif f == 3 then
                            move.turnRight()
                        elseif f == 4 then
                            move.turnRight()
                        else
                            forward()
                        end
                    end
                end
            end
        elseif mode == "clear" then
            if useEnderchest == 1 then
                turtle.select(16)
                while turtle.placeUp() == false do
                    turtle.digUp()
                    turtle.attackUp()
                end
                clearInventory("up")
                turtle.select(16)
                turtle.digUp()
                turtle.select(1)
                mode = "mine"
                save()
            else
                if goUp() then
                    print("there")
                    clearInventory("front")
                    mode = "back"
                    save()
                end
            end
        elseif mode == "refuel" then
            if goUp() then
                if useEnderchest == 1 then
                    turtle.select(16)
                    while turtle.placeUp() == false do
                        turtle.digUp()
                        turtle.attackUp()
                    end
                    clearInventory("up")
                    turtle.select(16)
                    turtle.digUp()
                    turtle.select(1)
                else
                    clearInventory("front")
                end
                print("waiting for fuel...")
                while refuel() == false do
                    os.pullEvent("turtle_inventory")
                end
                mode = "back"
                save()
            end
        elseif mode == "back" then
            if goDown() then
                mode = "mine"
                save()
            end
        elseif mode == "end" then
            if goUp() then
                if useEnderchest == 1 then
                    turtle.select(16)
                    while turtle.placeUp() == false do
                        turtle.digUp()
                        turtle.attackUp()
                    end
                    for i = 1, 16 do
                        turtle.select(i)
                        local itemData = turtle.getItemDetail()
                        if fileN.contains(itemData.name .. ";" .. itemData.damage, sortItems) then
                            turtle.dropDown()
                        else
                            turtle.dropUp()
                        end
                    end
                    turtle.select(16)
                    turtle.digUp()
                    turtle.select(1)
                else
                    for i = 1, 16 do
                        turtle.select(i)
                        local itemData = turtle.getItemDetail()
                        if fileN.contains(itemData.name .. ";" .. itemData.damage, sortItems) then
                            turtle.dropUp()
                        else
                            turtle.drop()
                        end
                    end
                end
                turtle.select(1)
                print("finish")
                fs.delete(path .. "moveInfo")
                fs.delete(path .. "startInfo")
                return
            end
        end
        x, y, z, f = move.getPos()
    end
end
