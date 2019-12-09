--TODO Should work as single group
---@param parent element
---@param label string
---@param text string
---@param style style.textBox
---@param x integer
---@param y integer
---@param w integer
---@param h integer
function new(parent, label, text, style, x, y, w, h)
    ---@class textBox:element
    local this = ui.element.new(parent, x, y, w, h)

    this.stylePadding =
        ui.padding.new(
        #style.normalTheme.border[4],
        #style.normalTheme.border[2],
        #style.normalTheme.border[5],
        #style.normalTheme.border[7]
    )
    this._elements[1] = ui.element.new(this, this.stylePadding.getPaddedRect(this.buffer.rect.getUnpacked()))
    this._elements[1]._elements[1] = ui.label.new(this, text, style.label, this._elements[1].getGlobalRect())
    local slideWidth = #style.slider.normal.handle
    this._elements[2] =
        ui.slider.new(
        this,
        nil,
        1,
        0,
        this._elements[1]._elements[1].getHeight(),
        this._elements[1].getHeight(),
        style.slider,
        x + w - math.max(math.ceil((this.stylePadding.right + slideWidth) / 2), slideWidth),
        y + this.stylePadding.top,
        slideWidth,
        h - this.stylePadding.top - this.stylePadding.bottom
    )
    this.label = label
    this.resetLayout = function()
        this.stylePadding.set(
            #this.style.normalTheme.border[4],
            #this.style.normalTheme.border[2],
            #this.style.normalTheme.border[5],
            #this.style.normalTheme.border[7]
        )
        local x, y, w, h = this.getGlobalRect()
        local container = this._elements[1]
        container.setGlobalRect(this.stylePadding.getPaddedRect(this.buffer.rect.getUnpacked()))
        ---@type label
        local label = this._elements[1]._elements[1]
        label.style = this.style.label
        label.setGlobalRect(container.getGlobalRect())
        label.recalculate()
        ---@type slider
        local slider = this._elements[2]
        slider.style = this.style.slider
        local slideWidth = #this.style.slider.normal.handle
        slider.setLocalRect(
            x + w - math.max(math.ceil((this.stylePadding.right + slideWidth) / 2), slideWidth),
            y + this.stylePadding.top,
            slideWidth,
            h - this.stylePadding.top - this.stylePadding.bottom
        )
        slider.startValue = 0
        slider.endValue = h
        slider.size = label.getHeight()
        slider.recalculate()
    end

    ---@type style.textBox
    this.style = style

    this._onValueChange = function(change)
        local maxMove = 0
        local label = this._elements[1]._elements[1]
        if change > 0 then -- Down
            maxMove =
                math.max(
                0,
                math.min(
                    change,
                    label.getLocalPosY() + label.getHeight() - (this.getHeight() - this.stylePadding.bottom + 1)
                )
            )
        elseif change < 0 then -- Up
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

    ---@param event event
    this._doNormalEvent = function(event)
        if this.mode == 3 and event.name == "mouse_scroll" then
            this._onValueChange(event.param1)
        end
    end

    this._doPointerEvent = function(event, x, y, w, h)
        if event.name == "mouse_click" and this.mode ~= 3 then
            x, y, w, h = ui.rect.overlaps(x, y, w, h, this.buffer.rect.getUnpacked())
            if event.param2 >= x and event.param2 < x + w and event.param3 >= y and event.param3 < y + h then
                this.getManager().selectionManager.setCurrentSelectionGroup(this.selectionGroup)
                return this
            end
        end
    end

    this.recalculate = function()
        ---@type style.textBox.theme
        local theme = nil
        if this.mode == 1 then
            theme = this.style.normalTheme
        elseif this.mode == 2 then
            theme = this.style.disabledTheme
        else
            theme = this.style.selectedTheme
        end

        ui.buffer.fillWithColor(this.buffer, " ", theme.spaceColor, theme.spaceColor)
        ui.buffer.borderBox(this.buffer, theme.border, theme.borderColor, theme.borderBackgroundColor)
        if this.label then
            local labelText = this.label
            local labelTheme
            if this.mode == 1 then
                labelTheme = this.style.label.normalTheme
            elseif this.mode == 2 then
                labelTheme = this.style.label.disabledTheme
            else
                labelText = ">" .. labelText .. "<"
                labelTheme = this.style.label.normalTheme
            end
            ui.buffer.labelBox(
                this.buffer,
                labelText,
                theme.textColor,
                theme.textBackgroundColor,
                5,
                nil,
                this.stylePadding.left,
                0,
                this.stylePadding.right,
                this.buffer.rect.h - this.stylePadding.top
            )
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

    ---@type selectionGroup
    this.selectionGroup = ui.selectionGroup.new(nil, nil, this._selectionGroupListener)
    this.selectionGroup.addNewSelectionElement(this._elements[2])

    return this
end
