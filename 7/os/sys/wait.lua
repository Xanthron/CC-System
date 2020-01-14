local args = {...}
local var1 = args[1]
if type(var1) == "string" then
    local function func()
        local x, y = term.getSize()

        x = math.floor(x / 2)
        y = math.floor(y / 2) + 2

        local pos = {x - 1, y - 1, x, y - 1, x + 1, y - 1, x + 1, y, x + 1, y + 1, x, y + 1, x - 1, y + 1, x - 1, y}
        local char = {"o", "O", "o"}

        local step = 1

        x = x - math.floor(var1:len() / 2)
        y = y - 4

        while true do
            if term.isColor() then
                term.setBackgroundColor(colors.white)
                term.setTextColor(colors.orange)
            end
            term.clear()
            term.setCursorPos(x, y)
            term.write(var1)
            for i = 1, #char do
                local index = ((step + i) % math.floor(#pos / 2) + 1) * 2 - 1
                term.setCursorPos(pos[index], pos[index + 1])
                term.write(char[#char - i + 1])
            end

            step = step + 1
            sleep(0.2)
        end
    end
    args[1] = func
end
return parallel.waitForAny(table.unpack(args))
