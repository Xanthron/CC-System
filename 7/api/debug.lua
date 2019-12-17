textColor = colors.white
backgroundColor = colors.black

show = function(text, x, y, time)
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
