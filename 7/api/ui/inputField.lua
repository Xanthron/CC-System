---@param parent element
---@param label string
---@param text string
---@param multiLine boolean
---@param onSubmit function
---@param style style.inputField
function new(parent, label, text, multiLine, onSubmit, style, x, y, w, h)
    ---@class inputField:element
    local this = ui.element.new(parent, x, y, w, h)

    this.style = style
    this.text = nil
    this.label = label
    this.multiLine = multiLine

    ---@type repeatItem
    this.repeatItem = ui.repeatItem.new(0.8, 0, 0)

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
    end
    this.setText(text)

    this._cursorX = 1
    this._cursorY = 1

    this.recalculateText = function()
        local theme

        if this.mode == 1 or this.mode == 4 then
            theme = this.style.normalTheme
        elseif this.mode == 2 then
            theme = this.style.disabledTheme
        else
            theme = this.style.selectedTheme
        end

        local left = #theme.border[4]
        local top = #theme.border[2]
        local right = #theme.border[6]
        local bottom = #theme.border[8]
        local width = this.getWidth()
        local length = this.text:len()

        local text
        if this.mode <= 2 then
            if length > width then
                text = this.text:sub(1, width - left - right - 3) .. "..."
            else
                text = this.text
            end
        else
            this.getManager().getCursorPos = this.getCursorPos

            local offset = length - (width - left - right) + 1
            local offset = math.max(0, math.min(offset, this.cursorOffset - width + left + right + 1))

            this._cursorX = this.buffer.rect.x + left + this.cursorOffset - offset
            this._cursorY = this.buffer.rect.y + top

            text = this.text:sub(offset + 1, math.min(offset + width - left - right, length))
        end

        ui.buffer.labelBox(this.buffer, text, theme.textColor, theme.textBackgroundColor, 1, theme.border[5][1], left, top, right, bottom)
    end
    this.recalculate = function()
        ---@type style.inputField.theme
        local theme
        ---@type style.label.theme
        local labelTheme

        if this.mode == 1 or this.mode == 4 then
            theme = this.style.normalTheme
            labelTheme = this.style.label.normalTheme
        elseif this.mode == 2 then
            theme = this.style.disabledTheme
            labelTheme = this.style.label.disabledTheme
        else
            theme = this.style.selectedTheme
            labelTheme = this.style.label.selectedTheme
        end

        ui.buffer.borderBox(this.buffer, theme.border, theme.borderColor, theme.borderBackgroundColor)
        if this.label then
            local yPos = math.max(0, math.floor((#theme.border[2] - 1) / 2))
            ui.buffer.labelBox(this.buffer, this.label, labelTheme.textColor, labelTheme.backgroundColor, this.style.label.alignment, nil, #theme.border[4], yPos, #theme.border[6], this.buffer.rect.h - yPos)
        end
        this.recalculateText()
    end
    this.recalculate()

    this.getCursorPos = function()
        if this.mode == 3 then
            return true, this._cursorX, this._cursorY, colors.red
        end
    end

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

    ---@param event event
    this._doNormalEvent = function(event)
        if this.mode == 3 then
            if event.name == "char" then
                --return this
                this.text = this.text:sub(1, this.cursorOffset) .. event.param1 .. this.text:sub(this.cursorOffset + 1)
                this.cursorOffset = this.cursorOffset + 1
                this.recalculateText()
                this.repaint("this")
                return this
            elseif event.name == "key" then
                local key = keys.getName(event.param1)
                if key == "backspace" then
                    if this.cursorOffset > 0 and this.repeatItem.call() then
                        this.text = this.text:sub(1, this.cursorOffset - 1) .. this.text:sub(this.cursorOffset + 1)
                        this.cursorOffset = this.cursorOffset - 1
                        this.recalculateText()
                        this.repaint("this")
                    end
                elseif key == "delete" then
                    if this.cursorOffset < this.text:len() and this.repeatItem.call() then
                        this.text = this.text:sub(1, this.cursorOffset) .. this.text:sub(this.cursorOffset + 2)
                        this.recalculateText()
                        this.repaint("this")
                    end
                elseif key == "home" then
                    if this.repeatItem.call() then
                        this.cursorOffset = 0
                        this.recalculateText()
                        this.repaint("this")
                    end
                elseif key == "end" then
                    if this.repeatItem.call() then
                        this.cursorOffset = this.text:len()
                        this.recalculateText()
                        this.repaint("this")
                    end
                elseif key == "left" then
                    if this.repeatItem.call() then
                        this.cursorOffset = math.max(0, this.cursorOffset - 1)
                        this.recalculateText()
                        this.repaint("this")
                    end
                elseif key == "right" then
                    if this.repeatItem.call() then
                        this.cursorOffset = math.min(this.text:len(), this.cursorOffset + 1)
                        this.recalculateText()
                        this.repaint("this")
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
                    --TODO submit
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
