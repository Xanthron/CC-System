if _isInWait == nil then
    _isInWait = false
end
ui.wait = {}
function ui.wait(text, ...)
    local args = {...}
    local isStarter = false
    local func

    if not _isInWait and text then
        _isInWait = true
        isStarter = true
        function func()
            local lines = {}
            for line in text:gmatch("[^\r\n]+") do
                table.insert(lines, line)
            end

            local x, y = term.getSize()

            x = math.floor(x / 2)
            y = math.floor(y / 2) + 2 + math.ceil(#lines / 2)

            local pos = {x - 1, y - 1, x, y - 1, x + 1, y - 1, x + 1, y, x + 1, y + 1, x, y + 1, x - 1, y + 1, x - 1, y}
            local char = {"o", "O", "o"}

            local step = 1

            y = y - 4 - #lines

            while true do
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
                sleep(0.2)
            end

            table.remove(sys.waitCaller, id)
        end
    end
    local function waitForAll()
        parallel.waitForAll(table.unpack(args))
    end
    if func then
        parallel.waitForAny(func, waitForAll)
    else
        waitForAll()
    end

    if isStarter and _isInWait then
        _isInWait = false
    end
end
