function new(parent, text, checked, func, style, x, y, w, h)
    local this = ui.element.new(parent, x, y, w, h)
    this.style = style
    this.text = text
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
                this._checked = this._checked == false
                this.mode = 1
                if this._inAnimation == false then
                    this.recalculate()
                    this.repaint("this", x, y, w, h)
                end
                this._onToggle(event, this._checked)
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
            this._onToggle(event, this._checked)
            return true
        end
    end
    this._onToggle = func or function()
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
        local checkbox, checkboxTextColor, checkboxBackGroundColor = nil, nil, nil
        if this._checked == true then
            checkbox = theme.checkedL
            checkboxTextColor = theme.checkedLC
            checkboxBackGroundColor = theme.checkedLBG
        else
            checkbox = theme.uncheckedL
            checkboxTextColor = theme.uncheckedLC
            checkboxBackGroundColor = theme.uncheckedLBG
        end
        local buffer = this.buffer
        local align = this.style.align
        ui.buffer.labelBox(buffer, this.text, theme.tC, theme.tBG, align, " ", #checkbox, 0, 0, 0)
        local topPadding = 0
        if align == 1 or align == 2 or align == 3 then
            topPadding = 1
        elseif align == 4 or align == 5 or align == 6 then
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
                    buffer.textColor[index] = theme.tC
                    buffer.textBackgroundColor[index] = theme.tBG
                    index = index + 1
                end
                index = index + buffer.rect.h - #checkbox
            end
        end
    end
    this.recalculate()
    return this
end
