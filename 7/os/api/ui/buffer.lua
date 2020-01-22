ui.buffer = {}
---Create a new buffer
---@param x integer
---@param y integer
---@param w integer
---@param h integer
---@param t string|optional
---@param tC string|optional
---@param tBG string|optional
---@return buffer
function ui.buffer.new(x, y, w, h, t, tC, tBG)
    ---Buffers the screen, so it can be drawn
    ---@class buffer
    local this = {text = t or {}, textColor = tC or {}, textBackgroundColor = tBG or {}}

    ---@type rect
    this.rect = ui.rect.new(x, y, w, h)
    ---Draws the buffer to the screen
    ---@param x integer|optional
    ---@param y integer|optional
    ---@param w integer|optional
    ---@param h integer|optional
    ---@return nil
    function this:draw(x, y, w, h)
        local thisX, thisY, thisW, thisH = self.rect:getUnpacked()
        local maskX, maskY, maskW, maskH = thisX, thisY, thisW, thisH
        local possible = true
        if x then
            maskX, maskY, maskW, maskH, possible = self.rect:getOverlaps(x, y, w, h)
        end
        if possible then
            local index = maskX - thisX + (maskY - thisY) * thisW
            for j = 1, maskH do
                for i = 1, maskW do
                    local index = maskX - thisX + i + (maskY - thisY + j - 1) * thisW
                    if term.isColor() then
                        term.setTextColor(self.textColor[index])
                        term.setBackgroundColor(self.textBackgroundColor[index])
                    end
                    term.setCursorPos(maskX + i - 1, maskY + j - 1)
                    term.write(self.text[index])
                end
            end
        end
    end
    ---Combines the given given buffer over this
    ---@param buffer buffer
    ---@param x integer|optional
    ---@param y integer|optional
    ---@param w integer|optional
    ---@param h integer|optional
    ---@return buffer
    function this:contract(buffer, x, y, w, h)
        local thisX, thisY, thisW, thisH = self.rect:getUnpacked()
        local bufferX, bufferY, bufferW, bufferH = buffer.rect:getUnpacked()
        local maskX, maskY, maskW, maskH = thisX, thisY, thisW, thisH
        local possible = true
        if x ~= nil then
            maskX, maskY, maskW, maskH, possible = self.rect:getOverlaps(x, y, w, h)
        end
        if possible == false then
            return
        end
        maskX, maskY, maskW, maskH, possible = buffer.rect:getOverlaps(maskX, maskY, maskW, maskH)
        if possible == false then
            return
        end
        for i = 1, maskH do
            for j = 1, maskW do
                local bufferIndex = maskX - bufferX + j + (maskY - bufferY + i - 1) * bufferW
                local thisIndex = maskX - thisX + j + (maskY - thisY + i - 1) * thisW
                if buffer.text[bufferIndex] then
                    self.text[thisIndex] = buffer.text[bufferIndex]
                end
                if buffer.textColor[bufferIndex] then
                    self.textColor[thisIndex] = buffer.textColor[bufferIndex]
                end
                if buffer.textBackgroundColor[bufferIndex] then
                    self.textBackgroundColor[thisIndex] = buffer.textBackgroundColor[bufferIndex]
                end
            end
        end
    end
    return this
end

---Draws a label in buffer
---@param buffer buffer
---@param t string
---@param tC color
---@param tBG color
---@param align alignment
---@param space char
---@param left integer|optional
---@param top integer|optional
---@param right integer|optional
---@param bottom integer|optional
---@return nil
function ui.buffer.labelBox(buffer, t, tC, tBG, align, space, left, top, right, bottom)
    left, top, right, bottom = left or 0, top or 0, right or 0, bottom or 0
    local totalWidth, totalHeight = buffer.rect.w, buffer.rect.h
    local width, height = totalWidth - left - right, totalHeight - top - bottom
    local textLines = {}
    for line in t:gmatch(".*[^\r\n]") do
        table.insert(textLines, line)
    end
    local topPadding = 0
    if align == 4 or align == 5 or align == 6 then
        topPadding = math.max(0, math.floor((height - #textLines) / 2))
    elseif align == 7 or align == 8 or align == 9 then
        topPadding = math.max(0, height - #textLines)
    end
    local h = 0
    local index = top * totalWidth + left + 1
    for i = 1, topPadding do
        for j = 1, width do
            if space then
                buffer.text[index] = space
                buffer.textColor[index] = tC
                buffer.textBackgroundColor[index] = tBG
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
        if align == 1 or align == 4 or align == 7 then
            paddingRight = width - line:len()
        elseif align == 2 or align == 5 or align == 8 then
            local repeatLengthHalf = (width - line:len()) / 2
            paddingLeft = math.floor(repeatLengthHalf)
            paddingRight = math.ceil(repeatLengthHalf)
        else
            paddingLeft = width - line:len()
        end
        for j = 1, paddingLeft do
            if space then
                buffer.text[index] = space
                buffer.textColor[index] = tC
                buffer.textBackgroundColor[index] = tBG
            end
            index = index + 1
        end
        local w = 0
        for char in line:gmatch(".") do
            if char == " " then
                if space then
                    buffer.text[index] = space
                    buffer.textColor[index] = tC
                    buffer.textBackgroundColor[index] = tBG
                end
            else
                buffer.text[index] = char
                buffer.textColor[index] = tC
                buffer.textBackgroundColor[index] = tBG
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
                buffer.textColor[index] = tC
                buffer.textBackgroundColor[index] = tBG
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
                buffer.textColor[index] = tC
                buffer.textBackgroundColor[index] = tBG
            end
            index = index + 1
        end
        index = index + left + right
    end
end

---Draws a border in buffer
---@param buffer buffer
---@param b border
---@param bC color
---@param bBG color
---@param left integer|optional
---@param top integer|optional
---@param right integer|optional
---@param bottom integer|optional
function ui.buffer.borderBox(buffer, b, bC, bBG, left, top, right, bottom)
    local totalWidth, totalHeight = buffer.rect.w, buffer.rect.h
    left, top, right, bottom = left or 0, top or 0, right or 0, bottom or 0
    local width, height = totalWidth - left - right, totalHeight - top - bottom
    local leftPadding = #b[4]
    local rightPadding = #b[6]
    local topPadding = #b[2]
    local bottomPadding = #b[8]
    local index = left + (top) * totalWidth + 1
    for i = 1, height do
        if i <= topPadding then
            for j = 1, leftPadding do
                buffer.text[index] = b[1][(i - 1) * leftPadding + j]
                buffer.textColor[index] = bC
                buffer.textBackgroundColor[index] = bBG
                index = index + 1
            end
            for j = 1, width - leftPadding - rightPadding do
                buffer.text[index] = b[2][i]
                buffer.textColor[index] = bC
                buffer.textBackgroundColor[index] = bBG
                index = index + 1
            end
            for j = 1, rightPadding do
                buffer.text[index] = b[3][(i - 1) * rightPadding + j]
                buffer.textColor[index] = bC
                buffer.textBackgroundColor[index] = bBG
                index = index + 1
            end
            index = index + right + left
        elseif i > height - bottomPadding then
            for j = 1, leftPadding do
                buffer.text[index] = b[7][(i - height + bottomPadding - 1) * leftPadding + j]
                buffer.textColor[index] = bC
                buffer.textBackgroundColor[index] = bBG
                index = index + 1
            end
            for j = 1, width - leftPadding - rightPadding do
                buffer.text[index] = b[8][i - height + bottomPadding]
                buffer.textColor[index] = bC
                buffer.textBackgroundColor[index] = bBG
                index = index + 1
            end
            for j = 1, rightPadding do
                buffer.text[index] = b[9][(i - height + bottomPadding - 1) * rightPadding + j]
                buffer.textColor[index] = bC
                buffer.textBackgroundColor[index] = bBG
                index = index + 1
            end
            index = index + right + left
        else
            for j = 1, leftPadding do
                buffer.text[index] = b[4][j]
                buffer.textColor[index] = bC
                buffer.textBackgroundColor[index] = bBG
                index = index + 1
            end
            index = index + width - leftPadding - rightPadding
            for j = 1, rightPadding do
                buffer.text[index] = b[6][j]
                buffer.textColor[index] = bC
                buffer.textBackgroundColor[index] = bBG
                index = index + 1
            end
            index = index + right + left
        end
    end
end

---Draws a label with border in buffer
---@param buffer buffer
---@param t string
---@param tC color
---@param tBG color
---@param b border
---@param bC color
---@param bBG color
---@param align alignment
---@param left integer|optional
---@param top integer|optional
---@param right integer|optional
---@param bottom integer|optional
---@return nil
function ui.buffer.borderLabelBox(buffer, t, tC, tBG, b, bC, bBG, align, left, top, right, bottom)
    local totalWidth, totalHeight = buffer.rect.w, buffer.rect.h
    left, top, right, bottom = left or 0, top or 0, right or 0, bottom or 0
    local width, height = totalWidth - left - right, totalHeight - top - bottom
    local leftP = #b[4]
    local rightP = #b[6]
    local topP = #b[2]
    local bottomP = #b[8]
    ui.buffer.labelBox(buffer, t, tC, tBG, align, " ", left + leftP, top + topP, right + rightP, bottom + bottomP)
    ui.buffer.borderBox(buffer, b, bC, bBG, left, top, right, bottom)
end

---Fills the buffer with one char a the text color and a background color
---@param buffer buffer
---@param t char
---@param tC color
---@param tBG color
---@param left integer|optional
---@param top integer|optional
---@param right integer|optional
---@param bottom integer|optional
---@return nil
function ui.buffer.fill(buffer, t, tC, tBG, left, top, right, bottom)
    left, top, right, bottom = left or 0, top or 0, right or 0, bottom or 0
    for j = 1 + top, buffer.rect.h - top - bottom do
        for i = 1 + right, buffer.rect.w - left - right do
            local index = i + (j - 1) * buffer.rect.w
            buffer.text[index] = t
            buffer.textColor[index] = tC
            buffer.textBackgroundColor[index] = tBG
        end
    end
end

---Draws a text in buffer
---@param buffer buffer
---@param t string
---@param tC color
---@param tBG color
---@param align alignment
---@param scaleW boolean
---@param scaleH boolean
---@param richText boolean
---@param left integer|optional
---@param top integer|optional
---@param right integer|optional
---@param bottom integer|optional
---@return nil
function ui.buffer.text(buffer, t, tC, tBG, align, scaleW, scaleH, richText, left, top, right, bottom)
    left, top, right, bottom = left or 0, top or 0, right or 0, bottom or 0
    local totalWidth, totalHeight = buffer.rect.w, buffer.rect.h
    local width, height = totalWidth - left - right, totalHeight - top - bottom
    local words = {}
    for line in t:gmatch(".[^\r\n]*") do
        for word in line:gmatch("[^%s]+") do
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
                currentLength = currentLength + words[i]:len() + 1
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
                end
                if lineCount == 0 and words[i]:len() > width then
                    table.insert(words, i + 1, words[i]:sub(width + 1))
                    words[i] = words[i]:sub(1, width)
                    table.insert(words, i + 1, "\n")
                else
                    if lineCount == 0 then
                        lineCount = words[i]:len()
                    else
                        lineCount = lineCount + words[i]:len() + 1
                        if lineCount > width then
                            lineCount = 0
                            table.insert(words, i, "\n")
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
            buffer.rect:set(nil, nil, lineWidth + left + right, lines + top + bottom)
        else
            buffer.rect:set(nil, nil, nil, lines + top + bottom)
        end
    else
        if scaleW then
            buffer.rect:set(nil, nil, lineWidth + left + right, nil)
        end
    end
    totalWidth, totalHeight = buffer.rect.w, buffer.rect.h
    width, height = totalWidth - left - right, totalHeight - top - bottom
    local topPadding = 0
    local bottomPadding = 0
    if align == 1 or align == 2 or align == 3 then
        bottomPadding = math.min(height, topPadding + lines)
    elseif align == 4 or align == 5 or align == 6 then
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
                buffer.textColor[index] = tC
                buffer.textBackgroundColor[index] = tBG
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
                        buffer.textColor[index] = tC
                        buffer.textBackgroundColor[index] = tBG
                        index = index + 1
                        lineCount = lineCount + 1
                    end
                    for j = 1, word:len() do
                        buffer.text[index] = word:sub(j, j)
                        buffer.textColor[index] = tC
                        buffer.textBackgroundColor[index] = tBG
                        index = index + 1
                        lineCount = lineCount + 1
                    end
                end
            end
            if align == 1 or align == 4 or align == 7 then
                for j = 1, width - lineCount do
                    buffer.text[index + j - 1] = " "
                    buffer.textColor[index + j - 1] = tC
                    buffer.textBackgroundColor[index + j - 1] = tBG
                end
            elseif align == 2 or align == 5 or align == 8 then
                for j = 1, math.ceil((width - lineCount) / 2) do
                    buffer.text[index + j - 1] = " "
                    buffer.textColor[index + j - 1] = tC
                    buffer.textBackgroundColor[index + j - 1] = tBG
                end
                for j = 1, math.floor((width - lineCount) / 2) do
                    table.insert(buffer.text, index - lineCount + j - 1, " ")
                    table.insert(buffer.textColor, index - lineCount + j - 1, tC)
                    table.insert(buffer.textBackgroundColor, index - lineCount + j - 1, tBG)
                    if buffer.text[index - lineCount + width + j] then
                        table.remove(buffer.text, index - lineCount + width + j)
                        table.remove(buffer.textColor, index - lineCount + width + j)
                        table.remove(buffer.textBackgroundColor, index - lineCount + width + j)
                    end
                end
            else
                for j = 1, width - lineCount do
                    table.insert(buffer.text, index - lineCount + j - 1, " ")
                    table.insert(buffer.textColor, index - lineCount + j - 1, tC)
                    table.insert(buffer.textBackgroundColor, index - lineCount + j - 1, tBG)
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
