textColor = colors.white
backgroundColor = colors.black

show = function(text, x, y)
    local tempCursorPosX, tempCursorPosY = term.getCursorPos()
    local tempTextColor = term.getTextColor()
    local tempBackgroundColor = term.getBackgroundColor()

    term.setCursorPos(x or 1, y or 1)
    term.setTextColor(textColor)
    term.setBackgroundColor(backgroundColor)
    term.write(text)

    term.setCursorPos(tempCursorPosX, tempCursorPosY)
    term.setTextColor(tempTextColor)
    term.setBackgroundColor(tempBackgroundColor)
    if time then
        sleep(time)
    end
end

_log = {}

log = function(text)
    if type(text) == "string" then
        table.insert(_log, text)
    end
end

logShow = function(time, x, y)
    local tempCursorPosX, tempCursorPosY = term.getCursorPos()
    local tempTextColor = term.getTextColor()
    local tempBackgroundColor = term.getBackgroundColor()
    for key, value in pairs(_log) do
        term.setCursorPos(x or 1, y or 1)
        term.setTextColor(textColor)
        term.setBackgroundColor(backgroundColor)
        term.write(value)
        if time then
            sleep(time)
        end
    end
    term.setCursorPos(tempCursorPosX, tempCursorPosY)
    term.setTextColor(tempTextColor)
    term.setBackgroundColor(tempBackgroundColor)
end
logClear = function()
    table.remove(_log)
end
