function new(parent, label, text, style, x, y, w, h)
    local this = ui.element.new(parent, x, y, w, h)
    this.stylePadding = ui.padding.new(#style.nTheme.b[4], #style.nTheme.b[2], #style.nTheme.b[6], #style.nTheme.b[8])
    this._elements[1] = ui.element.new(this, this.stylePadding.getPaddedRect(this.buffer.rect.getUnpacked()))
    this._elements[1]._elements[1] = ui.label.new(this, text, style.text, this._elements[1].getGlobalRect())
    local slideWidth = #style.slider.nTheme.handleL
    this._elements[2] = ui.slider.new(this, nil, 1, 0, this._elements[1]._elements[1].getHeight(), this._elements[1].getHeight(), style.slider, x + w - math.max(math.ceil((this.stylePadding.right + slideWidth) / 2), slideWidth), y + this.stylePadding.top, slideWidth, h - this.stylePadding.top - this.stylePadding.bottom)
    this.label = label
    this.resetLayout = function()
        this.stylePadding.set(#this.style.nTheme.b[4], #this.style.nTheme.b[2], #this.style.nTheme.b[6], #this.style.nTheme.b[8])
        local x, y, w, h = this.getGlobalRect()
        local container = this._elements[1]
        container.setGlobalRect(this.stylePadding.getPaddedRect(this.buffer.rect.getUnpacked()))
        local label = this._elements[1]._elements[1]
        label.style = this.style.label
        label.setGlobalRect(container.getGlobalRect())
        label.recalculate()
        local slider = this._elements[2]
        slider.style = this.style.slider
        local slideWidth = #this.style.slider.nTheme.handleL
        slider.setLocalRect(x + w - math.max(math.ceil((this.stylePadding.right + slideWidth) / 2), slideWidth), y + this.stylePadding.top, slideWidth, h - this.stylePadding.top - this.stylePadding.bottom)
        slider.startValue = 0
        slider.endValue = h
        slider.size = label.getHeight()
        slider.recalculate()
    end
    this.setText = function(text)
        this._elements[1]._elements[1].text = text
        this._elements[1]._elements[1].recalculate()
    end
    this.style = style
    this._onValueChange = function(change)
        local maxMove = 0
        local label = this._elements[1]._elements[1]
        if change > 0 then
            maxMove = math.max(0, math.min(change, label.getLocalPosY() + label.getHeight() - (this.getHeight() - this.stylePadding.bottom + 1)))
        elseif change < 0 then
            maxMove = math.min(0, math.max(change, label.getLocalPosY() - this.stylePadding.top - 1))
        end
        if maxMove ~= 0 then
            local slider = this._elements[2]
            label.setLocalRect(nil, -maxMove, nil, nil)
            slider.value = slider.value + maxMove
            slider.recalculate()
            this.repaint("this", this.buffer.rect.getUnpacked())
        end
    end
    this._elements[2]._onValueChange = this._onValueChange
    this._doNormalEvent = function(event)
        if this.mode == 3 and event.name == "mouse_scroll" then
            this._onValueChange(event.param1)
        end
    end
    this._doPointerEvent = function(event, x, y, w, h)
        if event.name == "mouse_click" and this.mode ~= 3 then
            x, y, w, h = ui.rect.overlaps(x, y, w, h, this.buffer.rect.getUnpacked())
            if event.param2 >= x and event.param2 < x + w and event.param3 >= y and event.param3 < y + h then
                this.getManager().selectionManager.setCurrentSelectionGroup(this.selectionGroup, "mouse")
                return this
            end
        end
    end
    ui.buffer.fillWithColor(this._elements[1].buffer, " ", this.style.nTheme.sTC, this.style.nTheme.sTC)
    this.recalculate = function()
        local theme
        local labelTheme
        if this.mode == 1 then
            theme = this.style.nTheme
            labelTheme = this.style.label.nTheme
        elseif this.mode == 2 then
            theme = this.style.dTheme
            labelTheme = this.style.label.dTheme
        else
            theme = this.style.sTheme
            labelTheme = this.style.label.sTheme
        end
        ui.buffer.fillWithColor(this.buffer, " ", theme.sTC, theme.sTC)
        ui.buffer.borderBox(this.buffer, theme.b, theme.bC, theme.bBG)
        if this.label then
            ui.buffer.labelBox(this.buffer, labelTheme.prefix .. this.label .. labelTheme.suffix, labelTheme.tC, labelTheme.tBG, this.style.label.align, nil, this.stylePadding.left, 0, this.stylePadding.right, this.buffer.rect.h - this.stylePadding.top)
        end
    end
    this.recalculate()
    this._selectionGroupListener = function(eventName, source, ...)
        if eventName == "key" then
            local key = ...
            if key == 200 or key == 17 then
                if this._elements[2].repeatItem.call() then
                    this._onValueChange(-1)
                end
                return false
            elseif key == 208 or key == 31 then
                if this._elements[2].repeatItem.call() then
                    this._onValueChange(1)
                end
                return false
            end
        elseif eventName == "key_up" then
            this._elements[2].repeatItem.reset()
        elseif eventName == "selection_lose_focus" then
            local currentElement, newElement = ...
            if newElement == nil and source == "mouse" then
                return false
            else
                this.mode = 1
                this.recalculate()
                this.repaint("this", x, y, w, h)
            end
        elseif eventName == "selection_get_focus" then
            this.mode = 3
            this.recalculate()
            this.repaint("this", x, y, w, h)
            if source == "mouse" then
                return false
            end
        elseif eventName == "selection_change" then
            local currentElement, newElement = ...
            if newElement == this or newElement == this._elements[2] then
                return false
            end
        end
    end
    this.selectionGroup = ui.selectionGroup.new(nil, nil, this._selectionGroupListener)
    this.selectionGroup.addNewSelectionElement(this._elements[2])
    return this
end
