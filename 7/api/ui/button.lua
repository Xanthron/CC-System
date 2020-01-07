function new(parent, text, func, style, x, y, w, h)
    local this = ui.element.new(parent, x, y, w, h)
    this.style = style
    this.text = text
    this._inAnimation = false
    this._pressAnimation = function(data)
        local clock = data[1] - os.clock() + 0.15
        if clock > 0 then
            sleep(clock)
        end
        this._inAnimation = false
        this.recalculate()
        this.repaint("this")
        return false
    end
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
            if this.mode == 3 and event.param2 >= x and event.param2 < x + w and event.param3 >= y and event.param3 < y + h then
                this.mode = 4
                if this._inAnimation == false then
                    this.recalculate()
                    this.repaint("this", x, y, w, h)
                end
            elseif this.mode == 4 and (event.param2 < x or event.param2 >= x + w or event.param3 < y or event.param3 >= y + h) then
                this.mode = 3
                if this._inAnimation == false then
                    this.recalculate()
                    this.repaint("this", x, y, w, h)
                end
            end
        elseif event.name == "mouse_up" then
            if this.mode == 4 and event.param2 >= x and event.param2 < x + w and event.param3 >= y and event.param3 < y + h then
                this.mode = 1
                if this._inAnimation == false then
                    this.recalculate()
                    this.repaint("this", x, y, w, h)
                end
                this._onClick(event)
                return this
            elseif this.mode == 3 and (event.param2 < x or event.param2 >= x + w or event.param3 < y or event.param3 >= y + h) then
                this.mode = 1
                if this._inAnimation == false then
                    this.recalculate()
                    this.repaint("this", x, y, w, h)
                end
                return this
            end
        end
    end
    this._doNormalEvent = function(event)
        if event.name == "key" and this.mode == 3 and (event.param1 == 57 or event.param1 == 28 or event.param1 == 29) then
            this.mode = 4
            if this._inAnimation == false then
                this.recalculate()
                this.repaint("this", this.getCompleteMaskRect())
                this._inAnimation = true
                this.getManager().parallelManager.addFunction(this._pressAnimation, {os.clock()})
            end
            return true
        elseif event.name == "key_up" and this.mode == 4 and (event.param1 == 57 or event.param1 == 28 or event.param1 == 29) then
            this.mode = 3
            if this._inAnimation == false then
                this.recalculate()
                this.repaint("this", this.getCompleteMaskRect())
            end
            this._onClick(event)
            return true
        end
    end
    this._onClick = func or function()
        end
    this.recalculate = function()
        local mode = this.mode
        local theme = nil
        if mode == 1 then
            theme = this.style.nTheme
        elseif mode == 2 then
            theme = this.style.dTheme
        elseif mode == 3 then
            theme = this.style.sTheme
        else
            theme = this.style.pTheme
        end
        ui.buffer.borderLabelBox(this.buffer, this.text, theme.tC, theme.tBG, theme.b, theme.bC, theme.bBG, this.style.align)
    end
    this.recalculate()
    return this
end
