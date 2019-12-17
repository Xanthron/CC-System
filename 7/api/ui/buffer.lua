---
--- Create a new buffer
---@param x integer
---@param y integer
---@param w integer
---@param h integer
---@param text char[]
---@param textColor integer[]
---@param textBackgroundColor integer[]
function new(x, y, w, h, text, textColor, textBackgroundColor)
    ---
    --- Stores text, text color and background color in a unique rect and draw it on the screen at any time
    ---@class buffer
    local this = {text = text or {}, textColor = textColor or {}, textBackgroundColor = textBackgroundColor or {}}

    ---@type rect
    this.rect = ui.rect.new(x, y, w, h)

    ---
    --- Draws all stored data, text, text color and background color, on the screen
    ---@param x integer
    ---@param y integer
    ---@param w integer
    ---@param h integer
    this.draw = function(x, y, w, h)
        local thisX, thisY, thisW, thisH = this.rect.getUnpacked()
        local maskX, maskY, maskW, maskH = thisX, thisY, thisW, thisH
        local possible = true
        if x then
            maskX, maskY, maskW, maskH, possible = this.rect.getOverlaps(x, y, w, h)
        end

        if possible then
            for j = 1, maskH do
                for i = 1, maskW do
                    local index = maskX - thisX + i + (maskY - thisY + j - 1) * thisW
                    if term.isColor() then
                        term.setTextColor(this.textColor[index])
                        term.setBackgroundColor(this.textBackgroundColor[index])
                    end
                    term.setCursorPos(maskX + i - 1, maskY + j - 1)
                    term.write(this.text[index])
                end
            end
        end
    end

    ---
    --- Contracts the given buffer on top respecting a given mask
    ---@param buffer buffer
    ---@param x integer
    ---@param y integer
    ---@param w integer
    ---@param h integer
    this.contract = function(buffer, x, y, w, h)
        local thisX, thisY, thisW, thisH = this.rect.getUnpacked()
        local bufferX, bufferY, bufferW, bufferH = buffer.rect.getUnpacked()
        local maskX, maskY, maskW, maskH = thisX, thisY, thisW, thisH
        local possible = true
        if x ~= nil then
            maskX, maskY, maskW, maskH, possible = this.rect.getOverlaps(x, y, w, h)
        end
        if possible == false then
            return
        end
        maskX, maskY, maskW, maskH, possible = buffer.rect.getOverlaps(maskX, maskY, maskW, maskH)
        if possible == false then
            return
        end

        for i = 1, maskH do
            for j = 1, maskW do
                local bufferIndex = maskX - bufferX + j + (maskY - bufferY + i - 1) * bufferW
                local thisIndex = maskX - thisX + j + (maskY - thisY + i - 1) * thisW
                if buffer.text[bufferIndex] then
                    this.text[thisIndex] = buffer.text[bufferIndex]
                end
                if buffer.textColor[bufferIndex] then
                    this.textColor[thisIndex] = buffer.textColor[bufferIndex]
                end
                if buffer.textBackgroundColor[bufferIndex] then
                    this.textBackgroundColor[thisIndex] = buffer.textBackgroundColor[bufferIndex]
                end
            end
        end
    end

    return this
end

---
--- Draws an label in buffer taking the buffer rect as container and padding it.
---@param buffer buffer
---@param text string
---@param textColor integer
---@param backgroundColor integer
---@param alignment "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9"
---@param space boolean
---@param left integer
---@param top integer
---@param right integer
---@param bottom integer
function labelBox(buffer, text, textColor, backgroundColor, alignment, space, left, top, right, bottom)
    left, top, right, bottom = left or 0, top or 0, right or 0, bottom or 0
    local totalWidth, totalHeight = buffer.rect.w, buffer.rect.h
    local width, height = totalWidth - left - right, totalHeight - top - bottom
    local textLines = {}
    for line in string.gmatch(text, ".*[^\r\n]") do
        table.insert(textLines, line)
    end

    local topPadding = 0

    if alignment == 4 or alignment == 5 or alignment == 6 then
        topPadding = math.max(0, math.floor((height - #textLines) / 2))
    elseif alignment == 7 or alignment == 8 or alignment == 9 then
        topPadding = math.max(0, height - #textLines)
    end

    local h = 0
    local index = top * totalWidth + left + 1

    for i = 1, topPadding do
        for j = 1, width do
            if space then
                buffer.text[index] = space
                buffer.textColor[index] = textColor
                buffer.textBackgroundColor[index] = backgroundColor
            end
            index = index + 1
        end

        h = h + 1
        index = index + left + right
    end

    for i = 1, #textLines do
        local line = textLines[i]

        local paddingLeft = 0
        local paddingRight = 0
        if alignment == 1 or alignment == 4 or alignment == 7 then
            paddingRight = width - string.len(line)
        elseif alignment == 2 or alignment == 5 or alignment == 8 then
            local repeatLengthHalf = (width - string.len(line)) / 2
            paddingLeft = math.floor(repeatLengthHalf)
            paddingRight = math.ceil(repeatLengthHalf)
        else
            paddingLeft = width - string.len(line)
        end

        for j = 1, paddingLeft do
            if space then
                buffer.text[index] = space
                buffer.textColor[index] = textColor
                buffer.textBackgroundColor[index] = backgroundColor
            end
            index = index + 1
        end

        local w = 0
        for char in line:gmatch(".") do
            if char == " " then
                if space then
                    buffer.text[index] = space
                    buffer.textColor[index] = textColor
                    buffer.textBackgroundColor[index] = backgroundColor
                end
            else
                buffer.text[index] = char
                buffer.textColor[index] = textColor
                buffer.textBackgroundColor[index] = backgroundColor
            end

            index = index + 1
            w = w + 1
            if w == width then
                break
            end
        end

        for j = 1, paddingRight do
            if space then
                buffer.text[index] = space
                buffer.textColor[index] = textColor
                buffer.textBackgroundColor[index] = backgroundColor
            end
            index = index + 1
        end

        index = index + left + right
        h = h + 1
        if h == height then
            break
        end
    end

    for i = h + 1, height do
        for j = 1, width do
            if space then
                buffer.text[index] = space
                buffer.textColor[index] = textColor
                buffer.textBackgroundColor[index] = backgroundColor
            end
            index = index + 1
        end

        index = index + left + right
    end
end

---
--- Draws box in buffer taking the buffer rect as container and padding it.
---@param buffer buffer
---@param border border
---@param borderColor integer
---@param borderBackgroundColor integer
---@param left integer
---@param top integer
---@param right integer
---@param bottom integer
function borderBox(buffer, border, borderColor, borderBackgroundColor, left, top, right, bottom)
    local totalWidth, totalHeight = buffer.rect.w, buffer.rect.h
    left, top, right, bottom = left or 0, top or 0, right or 0, bottom or 0
    local width, height = totalWidth - left - right, totalHeight - top - bottom
    local leftPadding = #border[4]
    local rightPadding = #border[6]
    local topPadding = #border[2]
    local bottomPadding = #border[8]

    local index = left + (top) * totalWidth + 1
    for i = 1, height do
        if i <= topPadding then
            for j = 1, leftPadding do
                buffer.text[index] = border[1][(i - 1) * leftPadding + j]
                buffer.textColor[index] = borderColor
                buffer.textBackgroundColor[index] = borderBackgroundColor
                index = index + 1
            end
            for j = 1, width - leftPadding - rightPadding do
                buffer.text[index] = border[2][i]
                buffer.textColor[index] = borderColor
                buffer.textBackgroundColor[index] = borderBackgroundColor
                index = index + 1
            end
            for j = 1, rightPadding do
                buffer.text[index] = border[3][(i - 1) * rightPadding + j]
                buffer.textColor[index] = borderColor
                buffer.textBackgroundColor[index] = borderBackgroundColor
                index = index + 1
            end
            index = index + right + left
        elseif i > height - bottomPadding then
            for j = 1, leftPadding do
                buffer.text[index] = border[7][(i - height + bottomPadding - 1) * leftPadding + j]
                buffer.textColor[index] = borderColor
                buffer.textBackgroundColor[index] = borderBackgroundColor
                index = index + 1
            end
            for j = 1, width - leftPadding - rightPadding do
                buffer.text[index] = border[8][i - height + bottomPadding]
                buffer.textColor[index] = borderColor
                buffer.textBackgroundColor[index] = borderBackgroundColor
                index = index + 1
            end
            for j = 1, rightPadding do
                buffer.text[index] = border[9][(i - height + bottomPadding - 1) * rightPadding + j]
                buffer.textColor[index] = borderColor
                buffer.textBackgroundColor[index] = borderBackgroundColor
                index = index + 1
            end
            index = index + right + left
        else
            for j = 1, leftPadding do
                buffer.text[index] = border[4][j]
                buffer.textColor[index] = borderColor
                buffer.textBackgroundColor[index] = borderBackgroundColor
                index = index + 1
            end
            index = index + width - leftPadding - rightPadding
            for j = 1, rightPadding do
                buffer.text[index] = border[6][j]
                buffer.textColor[index] = borderColor
                buffer.textBackgroundColor[index] = borderBackgroundColor
                index = index + 1
            end
            index = index + right + left
        end
    end
end

---
--- Draws an label in a box in buffer taking the buffer rect as container and padding it.
---@param buffer buffer
---@param text string
---@param textColor integer
---@param backgroundColor integer
---@param border border
---@param borderColor integer
---@param borderBackgroundColor integer
---@param alignment "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9"
---@param left integer
---@param top integer
---@param right integer
---@param bottom integer
function borderLabelBox(
    buffer,
    text,
    textColor,
    backgroundColor,
    border,
    borderColor,
    borderBackgroundColor,
    alignment,
    left,
    top,
    right,
    bottom)
    local totalWidth, totalHeight = buffer.rect.w, buffer.rect.h
    left, top, right, bottom = left or 0, top or 0, right or 0, bottom or 0
    local width, height = totalWidth - left - right, totalHeight - top - bottom
    local leftPadding = #border[4]
    local rightPadding = #border[6]
    local topPadding = #border[2]
    local bottomPadding = #border[8]

    labelBox(
        buffer,
        text,
        textColor,
        backgroundColor,
        alignment,
        " ",
        left + leftPadding,
        top + topPadding,
        right + rightPadding,
        bottom + bottomPadding
    )

    borderBox(buffer, border, borderColor, borderBackgroundColor, left, top, right, bottom)
end

---
--- Fills the buffer with one char, the color of it and the background color. The fill can be padded.
---@param buffer buffer
---@param char char
---@param textColor integer
---@param backgroundColor integer
---@param left integer
---@param top integer
---@param right integer
---@param bottom integer
function fillWithColor(buffer, char, textColor, backgroundColor, left, top, right, bottom)
    left, top, right, bottom = left or 0, top or 0, right or 0, bottom or 0
    for j = 1 + top, buffer.rect.h - top - bottom do
        for i = 1 + right, buffer.rect.w - left - right do
            local index = i + (j - 1) * buffer.rect.w
            buffer.text[index] = char
            buffer.textColor[index] = textColor
            buffer.textBackgroundColor[index] = backgroundColor
        end
    end
end

---
--- Draws Text in buffer taking the buffer rect as container and padding it. If necessary a line break is added. Depending on the inputs the buffer rect fits the size of its content and padding.
---@param buffer buffer
---@param text string
---@param textColor color
---@param backgroundColor color
---@param alignment "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9"
---@param scaleW boolean
---@param scaleH boolean
---@param richText boolean
---@param left integer
---@param top integer
---@param right integer
---@param bottom integer
function text(buffer, text, textColor, backgroundColor, alignment, scaleW, scaleH, richText, left, top, right, bottom)
    left, top, right, bottom = left or 0, top or 0, right or 0, bottom or 0
    local totalWidth, totalHeight = buffer.rect.w, buffer.rect.h
    local width, height = totalWidth - left - right, totalHeight - top - bottom

    local words = {}
    for line in string.gmatch(text, "[^\r\n]+") do
        for word in string.gmatch(line, "[^\t ]+") do
            table.insert(words, word)
        end
        table.insert(words, "\n")
    end

    local lineWidth = nil
    if scaleW then
        lineWidth = 0
        local currentLength = -1
        for i = 1, #words do
            if words[i] == "\n" then
                currentLength = -1
            else
                currentLength = currentLength + string.len(words[i]) + 1
                lineWidth = math.max(lineWidth, currentLength)
            end
        end
    else
        local lineCount = 0
        local i = 1
        while i <= #words do
            if words[i] == "\n" then
                lineCount = 0
            else
                if richText then
                --search for <*>
                end
                if lineCount == 0 and string.len(words[i]) > width then
                    --i = i + 1
                    table.insert(words, i + 1, string.sub(words[i], width + 1))
                    words[i] = string.sub(words[i], 1, width)
                    table.insert(words, i + 1, "\n")
                else
                    if lineCount == 0 then
                        lineCount = string.len(words[i])
                    else
                        lineCount = lineCount + string.len(words[i]) + 1
                        if lineCount > width then
                            lineCount = 0
                            table.insert(words, i, "\n")
                        --i = i + 1
                        end
                    end
                end
            end
            i = i + 1
        end
    end

    while words[#words] == "\n" do
        table.remove(words, #words)
    end

    local lines = 1
    for i = 1, #words do
        if words[i] == "\n" then
            lines = lines + 1
        end
    end
    if scaleH then
        if scaleW then
            buffer.rect.set(nil, nil, lineWidth + left + right, lines + top + bottom)
        else
            buffer.rect.set(nil, nil, nil, lines + top + bottom)
        end
    else
        if scaleW then
            buffer.rect.set(nil, nil, lineWidth + left + right, nil)
        end
    end
    totalWidth, totalHeight = buffer.rect.w, buffer.rect.h
    width, height = totalWidth - left - right, totalHeight - top - bottom

    local topPadding = 0
    local bottomPadding = 0

    if alignment == 1 or alignment == 2 or alignment == 3 then
        bottomPadding = math.min(height, topPadding + lines)
    elseif alignment == 4 or alignment == 5 or alignment == 6 then
        topPadding = math.max(0, math.floor((height - lines) / 2))
        bottomPadding = math.min(height, topPadding + lines)
    else
        topPadding = math.max(0, height - lines)
        bottomPadding = height
    end

    local wordIndex = 1
    local index = top * totalWidth + left + 1
    for i = 1, height do
        if i <= topPadding or i > bottomPadding then
            for j = 1, width do
                buffer.text[index] = " "
                buffer.textColor[index] = textColor
                buffer.textBackgroundColor[index] = backgroundColor
                index = index + 1
            end
        else
            local lineCount = 0
            while wordIndex <= #words do
                local word = words[wordIndex]
                wordIndex = wordIndex + 1
                if word == "\n" then
                    break
                else
                    if lineCount > 0 then
                        buffer.text[index] = " "
                        buffer.textColor[index] = textColor
                        buffer.textBackgroundColor[index] = backgroundColor
                        index = index + 1
                        lineCount = lineCount + 1
                    end
                    for j = 1, string.len(word) do
                        buffer.text[index] = string.sub(word, j, j)
                        buffer.textColor[index] = textColor
                        buffer.textBackgroundColor[index] = backgroundColor

                        index = index + 1
                        lineCount = lineCount + 1
                    end
                end
            end

            if alignment == 1 or alignment == 4 or alignment == 7 then
                for j = 1, width - lineCount do
                    buffer.text[index + j - 1] = " "
                    buffer.textColor[index + j - 1] = textColor
                    buffer.textBackgroundColor[index + j - 1] = backgroundColor
                end
            elseif alignment == 2 or alignment == 5 or alignment == 8 then
                for j = 1, math.ceil((width - lineCount) / 2) do
                    buffer.text[index + j - 1] = " "
                    buffer.textColor[index + j - 1] = textColor
                    buffer.textBackgroundColor[index + j - 1] = backgroundColor
                end
                for j = 1, math.floor((width - lineCount) / 2) do
                    table.insert(buffer.text, index - lineCount + j - 1, " ")
                    table.insert(buffer.textColor, index - lineCount + j - 1, textColor)
                    table.insert(buffer.textBackgroundColor, index - lineCount + j - 1, backgroundColor)
                    if buffer.text[index - lineCount + width + j] then
                        table.remove(buffer.text, index - lineCount + width + j)
                        table.remove(buffer.textColor, index - lineCount + width + j)
                        table.remove(buffer.textBackgroundColor, index - lineCount + width + j)
                    end
                end
            else
                for j = 1, width - lineCount do
                    table.insert(buffer.text, index - lineCount + j - 1, " ")
                    table.insert(buffer.textColor, index - lineCount + j - 1, textColor)
                    table.insert(buffer.textBackgroundColor, index - lineCount + j - 1, backgroundColor)
                    if buffer.text[index - lineCount + width + j] then
                        table.remove(buffer.text, index - lineCount + width + j)
                        table.remove(buffer.textColor, index - lineCount + width + j)
                        table.remove(buffer.textBackgroundColor, index - lineCount + width + j)
                    end
                end
            end
            index = index + width - lineCount
        end
        index = index + left + right
    end
end
