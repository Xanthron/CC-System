---@param parent element
---@param x integer
---@param y integer
---@param w integer
---@param h integer
---@param text string
---@param func function
---@param style toggleButton
---@return button
function new(parent, text, checked, func, style, x, y, w, h)
    ---@class toggle:element
    local this = ui.element.new(parent, x, y, w, h)

    ---@type style.toggleButton
    this.style = style
    ---@type string
    this.text = text
    ---@type boolean
    this._checked = checked

    this._inAnimation = false

    this._pressAnimation = function(data)
        local clock = data[1] - os.clock() + 0.15
        if clock > 0 then
            sleep(clock)
        end
        this._inAnimation = false
        this.recalculate()
        local x, y, w, h, possible = this.getCompleteMaskRect()
        if possible then
            this.repaint("this", x, y, w, h)
        end
        return false
    end
    ---@param event event
    ---@param x integer
    ---@param y integer
    ---@param w integer
    ---@param h integer
    ---@return boolean
    this._doPointerEvent = function(event, x, y, w, h)
        x, y, w, h = ui.rect.overlaps(x, y, w, h, this.buffer.rect.getUnpacked())
        if event.name == "mouse_click" then
            if event.param2 >= x and event.param2 < x + w and event.param3 >= y and event.param3 < y + h then
                this.mode = 4
                if this._inAnimation == false then
                    this._inAnimation = true
                    this.recalculate()
                    this.repaint("this", x, y, w, h)
                    this.getManager().parallelManager.addFunction(this._pressAnimation, {os.clock()})
                end
                return this
            end
        elseif event.name == "mouse_drag" then
            if
                this.mode == 3 and event.param2 >= x and event.param2 < x + w and event.param3 >= y and
                    event.param3 < y + h
             then
                this.mode = 4
                if this._inAnimation == false then
                    this.recalculate()
                    this.repaint("this", x, y, w, h)
                end
            elseif
                this.mode == 4 and
                    (event.param2 < x or event.param2 >= x + w or event.param3 < y or event.param3 >= y + h)
             then
                this.mode = 3
                if this._inAnimation == false then
                    this.recalculate()
                    this.repaint("this", x, y, w, h)
                end
            end
        elseif event.name == "mouse_up" then
            if
                this.mode == 4 and event.param2 >= x and event.param2 < x + w and event.param3 >= y and
                    event.param3 < y + h
             then
                this._checked = this._checked == false
                this.mode = 1
                if this._inAnimation == false then
                    this.recalculate()
                    this.repaint("this", x, y, w, h)
                end
                this._onToggle(this._checked)
                return this
            elseif
                this.mode == 3 and
                    (event.param2 < x or event.param2 >= x + w or event.param3 < y or event.param3 >= y + h)
             then
                this.mode = 1
                if this._inAnimation == false then
                    this.recalculate()
                    this.repaint("this", x, y, w, h)
                end
                return this
            end
        end
    end

    ---@param event event
    this._doNormalEvent = function(event)
        if event.name == "key" and this.mode == 3 and (event.param1 == 57 or event.param1 == 28) then
            this.mode = 4
            if this._inAnimation == false then
                this._inAnimation = true
                this.recalculate()
                this.repaint("this", this.getCompleteMaskRect())
                this.getManager().parallelManager.addFunction(this._pressAnimation, {os.clock()})
            end
            return true
        elseif event.name == "key_up" and this.mode == 4 and (event.param1 == 57 or event.param1 == 28) then
            this._checked = this._checked == false
            this.mode = 3
            if this._inAnimation == false then
                this.recalculate()
                this.repaint("this", this.getCompleteMaskRect())
            end
            this._onToggle(this._checked)
            return true
        end
    end

    this._onToggle = func or function()
        end

    this.recalculate = function()
        local mode = this.mode
        ---@type style.toggleButton.theme
        local theme = nil
        if mode == 1 then
            theme = this.style.normalTheme
        elseif mode == 2 then
            theme = this.style.disabledTheme
        elseif mode == 3 then
            theme = this.style.selectedTheme
        else
            theme = this.style.pressedTheme
        end

        local checkbox, checkboxTextColor, checkboxBackGroundColor = nil, nil, nil
        if this._checked == true then
            checkbox = theme.checkedCheckbox
            checkboxTextColor = theme.checkedCheckboxTextColor
            checkboxBackGroundColor = theme.checkedCheckboxBackgroundColor
        else
            checkbox = theme.uncheckedCheckbox
            checkboxTextColor = theme.uncheckedCheckboxTextColor
            checkboxBackGroundColor = theme.uncheckedCheckboxBackgroundColor
        end

        local buffer = this.buffer
        local alignment = this.style.alignment

        ui.buffer.labelBox(
            buffer,
            this.text,
            theme.textColor,
            theme.backgroundColor,
            alignment,
            " ",
            #checkbox,
            0,
            0,
            0
        )

        local topPadding = 0

        if alignment == 1 or alignment == 2 or alignment == 3 then
            topPadding = 1
        elseif alignment == 4 or alignment == 5 or alignment == 6 then
            topPadding = math.ceil(buffer.rect.h / 2)
        else
            topPadding = buffer.rect.h
        end

        local index = 1
        for j = 1, buffer.rect.h do
            if j == topPadding then
                for i = 1, #checkbox do
                    buffer.text[index] = checkbox[i]
                    buffer.textColor[index] = checkboxTextColor[i]
                    buffer.textBackgroundColor[index] = checkboxBackGroundColor[i]
                    index = index + 1
                end
                index = index + buffer.rect.h - #checkbox
            else
                for i = 1, #checkbox do
                    buffer.text[index] = " "
                    buffer.textColor[index] = theme.textColor
                    buffer.textBackgroundColor[index] = theme.backgroundColor
                    index = index + 1
                end
                index = index + buffer.rect.h - #checkbox
            end
        end
    end
    this.recalculate()

    return this
end
