function new(parent, label, text, style, x, y, w, h)
    ---@class textBox:element
    local this = ui.element.new(parent, x, y, w, h)
    this.stylePadding = ui.padding.new(#style.nTheme.b[4], #style.nTheme.b[2], #style.nTheme.b[6], #style.nTheme.b[8])
    this._elements[1] = ui.element.new(this, this.stylePadding:getPaddedRect(this.buffer.rect:getUnpacked()))
    this._elements[1]._elements[1] = ui.label.new(this, text, style.text, this._elements[1]:getGlobalRect())
    local slideWidth = #style.slider.nTheme.handleL
    this._elements[2] =
        ui.slider.new(
        this,
        nil,
        1,
        0,
        this._elements[1]._elements[1]:getHeight(),
        this._elements[1]:getHeight(),
        style.slider,
        x + w - math.max(math.ceil((this.stylePadding.right + slideWidth) / 2), slideWidth),
        y + this.stylePadding.top,
        slideWidth,
        h - this.stylePadding.top - this.stylePadding.bottom
    )
    this.label = label
    this.style = style
    this.selectionGroup = ui.selectionGroup.new(nil, nil, this._selectionGroupListener)
    ---Recalculate the buffer of this element
    ---@return nil
    function this:resetLayout()
        self.stylePadding:set(
            #self.style.nTheme.b[4],
            #self.style.nTheme.b[2],
            #self.style.nTheme.b[6],
            #self.style.nTheme.b[8]
        )
        local x, y, w, h = self:getGlobalRect()
        local container = self._elements[1]
        container:setGlobalRect(self.stylePadding:getPaddedRect(self.buffer.rect:getUnpacked()))
        local label = self._elements[1]._elements[1]
        label.style = self.style.label
        label:setGlobalRect(container:getGlobalRect())
        label:recalculate()
        local slider = self._elements[2]
        slider.style = self.style.slider
        local slideWidth = #self.style.slider.nTheme.handleL
        slider:setLocalRect(
            x + w - math.max(math.ceil((self.stylePadding.right + slideWidth) / 2), slideWidth),
            y + self.stylePadding.top,
            slideWidth,
            h - self.stylePadding.top - self.stylePadding.bottom
        )
        slider.startValue = 0
        slider.endValue = h
        slider.size = label:getHeight()
        slider:recalculate()
    end
    ---Edit the text
    ---@param text string
    ---@return nil
    function this:setText(text)
        self._elements[1]._elements[1].text = text
        self._elements[1]._elements[1]:recalculate()
    end
    ---Change the scroll value
    ---@param value integer
    ---@return nil
    function this._onValueChange(value)
        local maxMove = 0
        local label = self._elements[1]._elements[1]
        if value > 0 then
            maxMove =
                math.max(
                0,
                math.min(
                    value,
                    label:getLocalPosY() + label:getHeight() - (this.getHeight() - this.stylePadding.bottom + 1)
                )
            )
        elseif value < 0 then
            maxMove = math.min(0, math.max(value, label:getLocalPosY() - self.stylePadding.top - 1))
        end
        if maxMove ~= 0 then
            local slider = self._elements[2]
            label:setLocalRect(nil, -maxMove, nil, nil)
            slider.value = slider.value + maxMove
            slider:recalculate()
            self:repaint("this", self.buffer.rect:getUnpacked())
        end
    end
    ---Assigned function for every event except events dedicated to the mouse
    ---@param event event
    ---@return element|nil
    function this:_doNormalEvent(event)
        if self.mode == 3 and event.name == "mouse_scroll" then
            self:_onValueChange(event.param1)
        end
    end
    ---Assigned function for every event dedicated to the mouse
    ---@param event event
    ---@param x integer|optional
    ---@param y integer|optional
    ---@param w integer|optional
    ---@param h integer|optional
    ---@return element|nil
    function this:_doPointerEvent(event, x, y, w, h)
        if event.name == "mouse_click" and self.mode ~= 3 then
            x, y, w, h = ui.rect.overlaps(x, y, w, h, self.buffer.rect:getUnpacked())
            if event.param2 >= x and event.param2 < x + w and event.param3 >= y and event.param3 < y + h then
                self:getManager().selectionManager:setCurrentSelectionGroup(self.selectionGroup, "mouse")
                return self
            end
        end
    end
    ---Recalculate the buffer of this element
    ---@return nil
    this.recalculate = function()
        local theme
        local labelTheme
        if self.mode == 1 then
            theme = self.style.nTheme
            labelTheme = self.style.label.nTheme
        elseif self.mode == 2 then
            theme = self.style.dTheme
            labelTheme = self.style.label.dTheme
        else
            theme = self.style.sTheme
            labelTheme = self.style.label.sTheme
        end
        ui.buffer.fillWithColor(self.buffer, " ", theme.sTC, theme.sTC)
        ui.buffer.borderBox(self.buffer, theme.b, theme.bC, theme.bBG)
        if self.label then
            ui.buffer.labelBox(
                self.buffer,
                labelTheme.prefix .. self.label .. labelTheme.suffix,
                labelTheme.tC,
                labelTheme.tBG,
                self.style.label.align,
                nil,
                self.stylePadding.left,
                0,
                self.stylePadding.right,
                self.buffer.rect.h - self.stylePadding.top
            )
        end
    end
    ---Listener function of the selectionGroup
    ---@param eventName string
    ---@param source string
    ---@param ... any
    ---@return boolean
    function this.selectionGroup:listener(eventName, source, ...)
        if eventName == "key" then
            local key = ...
            if key == 200 or key == 17 then
                if this._elements[2].repeatItem:call() then
                    this:_onValueChange(-1)
                end
                return false
            elseif key == 208 or key == 31 then
                if this._elements[2].repeatItem:call() then
                    this:_onValueChange(1)
                end
                return false
            end
        elseif eventName == "key_up" then
            this._elements[2].repeatItem:reset()
        elseif eventName == "selection_lose_focus" then
            local currentElement, newElement = ...
            if newElement == nil and source == "mouse" then
                return false
            else
                this.mode = 1
                this:recalculate()
                this:repaint("this", x, y, w, h)
            end
        elseif eventName == "selection_get_focus" then
            this.mode = 3
            this:recalculate()
            this:repaint("this", x, y, w, h)
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

    ui.buffer.fillWithColor(this._elements[1].buffer, " ", this.style.nTheme.sTC, this.style.nTheme.sTC)
    this.selectionGroup:addNewSelectionElement(this._elements[2])
    this._elements[2]._onValueChange = this._onValueChange
    this:recalculate()

    return this
end
