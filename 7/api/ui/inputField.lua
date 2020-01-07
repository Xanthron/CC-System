function new(parent, label, text, multiLine, onSubmit, style, x, y, w, h)
    local this = ui.element.new(parent, x, y, w, h)
    this.style = style
    this.text = nil
    this.label = label
    this.multiLine = multiLine
    this._onSubmit = onSubmit
    this.repeatItem = ui.repeatItem.new(0.8, 0, 0)
    this._cursorX = 1
    this._cursorY = 1
    this.autoComplete = {}
    this.autoCompleteIndex = 1
    this.onSuggestCompletion = nil
    this.onAutoCompletion = nil
    this.ignoreKeys = {
        "tab",
        "leftCtrl",
        "grave",
        "leftShift",
        "rightShift",
        "leftAlt",
        "capsLock",
        "f1",
        "f2",
        "f3",
        "f4",
        "f5",
        "f6",
        "f7",
        "f8",
        "f9",
        "f10",
        "numLock",
        "scollLock",
        "f11",
        "f12",
        "f13",
        "f14",
        "f15",
        "kana",
        "convert",
        "noconvert",
        "yen",
        "colon",
        "kanji",
        "stop",
        "ax",
        "rightCtrl",
        "rightAlt",
        "pause",
        "up",
        "pageUp",
        "down",
        "pageDown",
        "insert",
        "delete"
    }
    this.cursorOffset = 0
    this.setText = function(text, index)
        this.text = text
        if index == -1 then
            index = this.cursorOffset
        end
        if index then
            this.cursorOffset = math.max(0, math.min(text:len(), index))
        else
            this.cursorOffset = text:len()
        end
        if this.mode > 2 then
            this.getAutoComplete()
        end
    end
    this.setText(text)
    this.getAutoComplete = function()
        if this.onSuggestCompletion then
            while #this.autoComplete > 0 do
                table.remove(this.autoComplete)
            end
            this.autoComplete = this.onSuggestCompletion(this.text, this.cursorOffset)
        end
        this.autoCompleteIndex = 1
    end
    this.recalculateText = function()
        local theme
        if this.mode == 1 or this.mode == 4 then
            theme = this.style.nTheme
        elseif this.mode == 2 then
            theme = this.style.dTheme
        else
            theme = this.style.sTheme
        end
        local left = #theme.b[4]
        local top = #theme.b[2]
        local right = #theme.b[6]
        local bottom = #theme.b[8]
        local width = this.getWidth()
        local length = this.text:len()
        if this.mode <= 2 then
            local text
            if length > width then
                local align = this.style.align
                if align == 1 or align == 4 or align == 7 then
                    text = this.text:sub(1, width - left - right - 3) .. "..."
                elseif align == 2 or align == 1 or align == 8 then
                    local w = width - left - right - 3
                    text = this.text:sub(1, math.floor(w / 2)) .. "..." .. this.text:sub(length - math.ceil(w / 2))
                else
                    text = "..." .. this.text:sub(length - width + left + right + 3)
                end
            else
                text = this.text
            end
            ui.buffer.labelBox(this.buffer, text, theme.tC, theme.tBG, 1, theme.b[5][1], left, top, right, bottom)
        else
            this.getManager().getCursorPos = this.getCursorPos
            local completeText
            if #this.autoComplete > 0 then
                completeText = this.autoComplete[this.autoCompleteIndex]
            else
                completeText = ""
            end
            local completeLength = completeText:len()
            local offsetT = length - (width - left - right) + 1
            offsetT = math.min(offsetT, this.cursorOffset - width + left + right + 1)
            local offsetC = math.max(0, math.min(width - left - right - 3, completeLength, length + completeLength - width - left - right + 3))
            offsetT = offsetT + offsetC
            offsetT = math.max(0, offsetT)
            this._cursorX = this.buffer.rect.x + left + this.cursorOffset - offsetT
            this._cursorY = this.buffer.rect.y + top
            if completeText == "" then
                local text = this.text:sub(offsetT + 1, math.min(offsetT + width - left - right, length))
                ui.buffer.labelBox(this.buffer, text, theme.tC, theme.tBG, 1, theme.b[5][1], left, top, right, bottom)
            else
                local text = this.text:sub(offsetT + 1, math.min(offsetT + width - left - right - offsetC, length))
                ui.buffer.labelBox(this.buffer, text, theme.tC, theme.tBG, 1, theme.b[5][1], left, top, right, bottom)
                ui.buffer.labelBox(this.buffer, completeText, theme.complC, theme.complBG, 1, theme.b[5][1], left + this.cursorOffset - offsetT, top, right, bottom)
                text = this.text:sub(offsetT + width - left - right - offsetC, math.min(offsetT + width - left - right, length))
                ui.buffer.labelBox(this.buffer, text, theme.tC, theme.tBG, 1, theme.b[5][1], left + length + completeLength - offsetT, top, right, bottom)
            end
        end
    end
    this.recalculate = function()
        local theme
        local labelTheme
        if this.mode == 1 or this.mode == 4 then
            theme = this.style.nTheme
            labelTheme = this.style.label.nTheme
        elseif this.mode == 2 then
            theme = this.style.dTheme
            labelTheme = this.style.label.dTheme
        else
            theme = this.style.sTheme
            labelTheme = this.style.label.sTheme
        end
        ui.buffer.borderBox(this.buffer, theme.b, theme.bC, theme.bBG)
        if this.label then
            local yPos = math.max(0, math.floor((#theme.b[2] - 1) / 2))
            ui.buffer.labelBox(this.buffer, this.label, labelTheme.tC, labelTheme.tBG, this.style.label.align, nil, #theme.b[4], yPos, #theme.b[6], this.buffer.rect.h - yPos)
        end
        this.recalculateText()
    end
    this.recalculate()
    this.getCursorPos = function()
        if this.mode == 3 then
            return true, this._cursorX, this._cursorY, colors.red
        end
    end
    this._doNormalEvent = function(event)
        if this.mode == 3 then
            if event.name == "char" then
                this.text = this.text:sub(1, this.cursorOffset) .. event.param1 .. this.text:sub(this.cursorOffset + 1)
                this.cursorOffset = this.cursorOffset + 1
                this.getAutoComplete()
                this.recalculateText()
                this.repaint("this")
                return this
            elseif event.name == "key" then
                local key = keys.getName(event.param1)
                if key == "backspace" then
                    if this.cursorOffset > 0 and this.repeatItem.call() then
                        this.text = this.text:sub(1, this.cursorOffset - 1) .. this.text:sub(this.cursorOffset + 1)
                        this.cursorOffset = this.cursorOffset - 1
                        this.getAutoComplete()
                        this.recalculateText()
                        this.repaint("this")
                    end
                elseif key == "delete" then
                    if this.cursorOffset < this.text:len() and this.repeatItem.call() then
                        this.text = this.text:sub(1, this.cursorOffset) .. this.text:sub(this.cursorOffset + 2)
                        this.getAutoComplete()
                        this.recalculateText()
                        this.repaint("this")
                    end
                elseif key == "home" then
                    if this.repeatItem.call() and this.cursorOffset > 0 then
                        this.cursorOffset = 0
                        this.getAutoComplete()
                        this.recalculateText()
                        this.repaint("this")
                    end
                elseif key == "end" then
                    if this.repeatItem.call() and this.cursorOffset < this.text:len() then
                        this.cursorOffset = this.text:len()
                        this.getAutoComplete()
                        this.recalculateText()
                        this.repaint("this")
                    end
                elseif key == "left" then
                    if this.repeatItem.call() and this.cursorOffset > 0 then
                        this.cursorOffset = this.cursorOffset - 1
                        this.getAutoComplete()
                        this.recalculateText()
                        this.repaint("this")
                    end
                elseif key == "right" then
                    if this.repeatItem.call() then
                        local success = false
                        if #this.autoComplete > 0 then
                            success, this.text, this.cursorOffset = this.onAutoCompletion(this.text, this.cursorOffset, this.autoComplete[this.autoCompleteIndex])
                        end
                        if not success then
                            this.cursorOffset = math.min(this.text:len(), this.cursorOffset + 1)
                        end
                        this.getAutoComplete()
                        this.recalculateText()
                        this.repaint("this")
                    end
                elseif key == "up" then
                    if #this.autoComplete > 0 then
                        if this.autoCompleteIndex <= 1 then
                            this.autoCompleteIndex = #this.autoComplete
                        else
                            this.autoCompleteIndex = this.autoCompleteIndex - 1
                        end
                        this.recalculateText()
                        this.repaint("this")
                        return this
                    end
                elseif key == "down" then
                    if #this.autoComplete > 0 then
                        if this.autoCompleteIndex >= #this.autoComplete then
                            this.autoCompleteIndex = 1
                        else
                            this.autoCompleteIndex = this.autoCompleteIndex + 1
                        end
                        this.recalculateText()
                        this.repaint("this")
                        return this
                    end
                end
                for index, value in ipairs(this.ignoreKeys) do
                    if key == value then
                        return
                    end
                end
                return this
            elseif event.name == "key_up" then
                local key = keys.getName(event.param1)
                if key == "enter" then
                    if this._onSubmit then
                        this._onSubmit(event, this.text)
                    end
                    return this
                end
                for index, value in ipairs(this.ignoreKeys) do
                    if key == value then
                        return
                    end
                end
                this.repeatItem.reset()
                return this
            end
        end
    end
    this._doPointerEvent = function(event, x, y, w, h)
        x, y, w, h = ui.rect.overlaps(x, y, w, h, this.buffer.rect.getUnpacked())
        if event.name == "mouse_click" then
            if event.param2 >= x and event.param2 < x + w and event.param3 >= y and event.param3 < y + h then
                this.mode = 3
                this.recalculate()
                this.repaint("this", x, y, w, h)
                return this
            end
        elseif event.name == "mouse_drag" then
            if this.mode == 4 and event.param2 >= x and event.param2 < x + w and event.param3 >= y and event.param3 < y + h then
                this.mode = 3
                this.recalculate()
                this.repaint("this", x, y, w, h)
            elseif this.mode == 3 and (event.param2 < x or event.param2 >= x + w or event.param3 < y or event.param3 >= y + h) then
                this.mode = 4
                this.recalculate()
                this.repaint("this", x, y, w, h)
            end
        elseif event.name == "mouse_up" then
            if this.mode == 3 and event.param2 >= x and event.param2 < x + w and event.param3 >= y and event.param3 < y + h then
                return this
            elseif this.mode == 4 and (event.param2 < x or event.param2 >= x + w or event.param3 < y or event.param3 >= y + h) then
                this.mode = 1
                this.recalculate()
                this.repaint("this", x, y, w, h)
                return this
            end
        end
    end
    return this
end
