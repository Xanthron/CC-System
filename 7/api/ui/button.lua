---
--- Creates a new button
---@param parent element
---@param x integer
---@param y integer
---@param w integer
---@param h integer
---@param text string
---@param func function
---@param style buttonStyle
---@return button
function new(parent, text, func, style, x, y, w, h)
    ---
    --- An button ui element that handels the draw and event of an button
    ---@class button:element
    local this = ui.element.new(parent, x, y, w, h)

    ---@type style.button
    this.style = style
    ---@type string
    this.text = text

    this._inAnimation = false

    this._pressAnimation = function(data)
        local clock = data[1] - os.clock() + 0.15
        if clock > 0 then
            sleep(clock)
        end
        this._inAnimation = false
        this.recalculate()
        local x, y, w, h, possible = this.getCompleteMaskRect()
        if possible == true then
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
                    --this._inAnimation = true
                    this.recalculate()
                    this.repaint("this", x, y, w, h)
                --this.getManager().parallelManager.addFunction(this._pressAnimation, {os.clock()})
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
                this.mode = 1
                if this._inAnimation == false then
                    this.recalculate()
                    this.repaint("this", x, y, w, h)
                end
                this._onClick()
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
                this.recalculate()
                this.repaint("this", this.getCompleteMaskRect())
                this._inAnimation = true
                this.getManager().parallelManager.addFunction(this._pressAnimation, {os.clock()})
            end
            return true
        elseif event.name == "key_up" and this.mode == 4 and (event.param1 == 57 or event.param1 == 28) then
            this.mode = 3
            if this._inAnimation == false then
                this.recalculate()
                this.repaint("this", this.getCompleteMaskRect())
            end
            this._onClick()
            return true
        end
    end

    this._onClick = func or function()
        end

    this.recalculate = function()
        local mode = this.mode
        ---@type style.button.theme
        local theme = nil
        if mode == 1 then
            theme = this.style.normalTheme
        elseif mode == 2 then
            theme = this.style.disabledTheme
        elseif mode == 3 then
            theme = this.style.selectedTheme
        elseif mode == 4 then
            theme = this.style.pressedTheme
        end
        ui.buffer.borderLabelBox(
            this.buffer,
            this.text,
            theme.textColor,
            theme.textBackgroundColor,
            theme.border,
            theme.borderColor,
            theme.borderBackgroundColor,
            this.style.alignment
        )
    end
    this.recalculate()

    return this
end
