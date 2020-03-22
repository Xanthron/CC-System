local args = {...}
local term = ui.input.term
local var1 = args[1]
local func

if not sys.waitCaller then
    sys.waitCaller = {}
end

if type(var1) == "string" then
    function func()
        local id = #sys.waitCaller + 1
        table.insert(sys.waitCaller, id)

        local lines = {}
        for line in var1:gmatch("[^\r\n]+") do
            table.insert(lines, line)
        end

        local x, y = term.getSize()

        x = math.floor(x / 2)
        y = math.floor(y / 2) + 2 + math.floor(#lines / 2)

        local pos = {x - 1, y - 1, x, y - 1, x + 1, y - 1, x + 1, y, x + 1, y + 1, x, y + 1, x - 1, y + 1, x - 1, y}
        local char = {"o", "O", "o"}

        local step = 1

        y = y - 4 - #lines

        while true do
            if #sys.waitCaller <= id then
                if term.isColor() then
                    term.setBackgroundColor(colors.white)
                    term.setTextColor(colors.orange)
                end
                term.clear()
                for i, v in ipairs(lines) do
                    local x = x - math.floor(v:len() / 2)
                    local y = y + i
                    term.setCursorPos(x, y)
                    term.write(v)
                end
                for i = 1, #char do
                    local index = ((step + i) % math.floor(#pos / 2) + 1) * 2 - 1
                    term.setCursorPos(pos[index], pos[index + 1])
                    term.write(char[#char - i + 1])
                end
                step = step + 1
            end
            sleep(0.2)
        end

        table.remove(sys.waitCaller, id)
    end
    table.remove(args, 1)
end

local function waitForAll()
    parallel.waitForAll(table.unpack(args))
end

if func then
    parallel.waitForAny(func, waitForAll)
else
    waitForAll()
end

if #sys.waitCaller == 0 then
    sys.waitCaller = nil
end
