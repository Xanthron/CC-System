ui.textBox = {}
---@param parent element
---@param label string|nil
---@param text string
---@param style style.textBox
---@param x integer
---@param y integer
---@param w integer
---@param h integer
---@param key string|optional
---@return textBox
function ui.textBox.new(parent, label, text, style, x, y, w, h, key)
    ---@class textBox:element
    local this = ui.element.new(parent, "textBox", x, y, w, h, key)

    ---@type padding
    this.stylePadding = ui.padding.new(#style.nTheme.b[4], #style.nTheme.b[2], #style.nTheme.b[6], #style.nTheme.b[8])
    ui.element.new(this, "container", this.stylePadding:getPaddedRect(this.buffer.rect:getUnpacked()))
    ui.text.new(this.element[1], text, style.text, this.element[1]:getGlobalRect())
    local slideWidth = #style.slider.nTheme.handleL
    ui.slider.new(this, 1, 0, this.element[1].element[1]:getHeight(), this.element[1]:getHeight(), style.slider, x + w - math.max(math.ceil((this.stylePadding.right + slideWidth) / 2), slideWidth), y + this.stylePadding.top, slideWidth, h - this.stylePadding.top - this.stylePadding.bottom, "v")
    ---@type string
    this.label = label
    this.richText = richText
    ---@type style.textBox
    this.style = style
    ---@type selectionGroup
    this.selectionGroup = ui.selectionGroup.new(nil, nil)
    this.selectable = false
    this.scrollWithoutSelection = true

    function this:resizeSlider()
        local slider = self.element.v
        slider.value = 0 -- math.max(0, math.min(slider.value, self.element[1]:getHeight()))
        slider.startValue = 0
        slider.endValue = self.element[1].element[1]:getHeight()
        slider:recalculate()
    end
    ---Recalculate the buffer of this element
    ---@return nil
    function this:resetLayout()
        self.stylePadding:set(#self.style.nTheme.b[4], #self.style.nTheme.b[2], #self.style.nTheme.b[6], #self.style.nTheme.b[8])
        local x, y, w, h = self:getGlobalRect()
        local container = self.element[1]
        container:setGlobalRect(self.stylePadding:getPaddedRect(self.buffer.rect:getUnpacked()))
        local label = self.element[1].element[1]
        label.style = self.style.label
        label:setGlobalRect(container:getGlobalRect())
        label:recalculate()
        local slider = self.element.v
        slider.style = self.style.slider
        local slideWidth = #self.style.slider.nTheme.handleL
        local x, y, w, h = self:getGlobalRect()
        slider:setLocalRect(x + w - math.max(math.ceil((self.stylePadding.right + slideWidth) / 2), slideWidth), y + self.stylePadding.top, slideWidth, h - self.stylePadding.top - self.stylePadding.bottom)
        this:resizeSlider()
    end
    ---Edit the text
    ---@param text string
    ---@return nil
    function this:setText(text)
        self.element[1].element[1].text = text
        self.element[1].element[1]:recalculate()
    end
    ---Change the scroll value
    ---@param value integer
    ---@return nil
    function this.onValueChange(value)
        local maxMove = 0
        local label = this.element[1].element[1]
        if value > 0 then
            maxMove = math.max(0, math.min(value, label:getLocalPosY() + label:getHeight() - (this:getHeight() - this.stylePadding.bottom)))
        elseif value < 0 then
            maxMove = math.min(0, math.max(value, label:getLocalPosY() - this.stylePadding.top))
        end
        if maxMove ~= 0 then
            local slider = this.element.v
            label:setLocalRect(nil, -maxMove, nil, nil)
            slider.value = slider.value + maxMove
            slider:recalculate()
            this:repaint("this", this.buffer.rect:getUnpacked())
            return true
        end
        return false
    end
    ---Assigned function for every event except events dedicated to the mouse
    ---@param event event
    ---@return element|nil
    function this:normalEvent(event)
        if (self.scrollWithoutSelection or not self.selectable or self.mode == 3) and event.name == "mouse_scroll" then
            self.onValueChange(event.param1)
            return this
        end
    end
    ---Assigned function for every event dedicated to the mouse
    ---@param event event
    ---@param x integer|optional
    ---@param y integer|optional
    ---@param w integer|optional
    ---@param h integer|optional
    ---@return element|nil
    function this:pointerEvent(event, x, y, w, h)
        if self.selectable and (event.name == "mouse_click" or event.name == "monitor_touch") and self.mode ~= 3 then
            x, y, w, h = ui.rect.overlaps(x, y, w, h, self.buffer.rect:getUnpacked())
            if event.param2 >= x and event.param2 < x + w and event.param3 >= y and event.param3 < y + h then
                self:getDrawer().selectionManager:select(self.selectionGroup, "mouse", 1)
                return self
            end
        end
    end
    ---Recalculate the buffer of this element
    ---@return nil
    function this:recalculate()
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
        ui.buffer.fill(self.buffer, " ", theme.sTC, theme.sTC)
        ui.buffer.borderBox(self.buffer, theme.b, theme.bC, theme.bBG)
        if self.label then
            ui.buffer.labelBox(self.buffer, labelTheme.prefix .. self.label .. labelTheme.suffix, labelTheme.tC, labelTheme.tBG, self.style.label.align, nil, self.stylePadding.left, 0, self.stylePadding.right, self.buffer.rect.h - self.stylePadding.top)
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
                if this.element.v.repeatItem:call() then
                    return not this.onValueChange(-1)
                end
                return false
            elseif key == 208 or key == 31 then
                if this.element.v.repeatItem:call() then
                    return not this.onValueChange(1)
                end
                return false
            end
        elseif eventName == "key_up" then
            this.element.v.repeatItem:reset()
        elseif eventName == "selection_lose_focus" then
            local currentElement, newElement = ...
            if newElement == nil and source == "mouse" then
                return false
            else
                this:changeMode(1)
            end
        elseif this.selectable and eventName == "selection_get_focus" then
            local currentElement, newElement = ...
            this:changeMode(3)
            if newElement == this then
                if source ~= "mouse" then
                    this.selectionGroup.current:changeMode(3)
                end
                return false
            end
        elseif eventName == "selection_change" then
            local currentElement, newElement = ...
            if newElement == this or newElement == this.element.v then
                return false
            end
        end
    end

    ui.buffer.fill(this.element[1].buffer, " ", this.style.nTheme.sTC, this.style.nTheme.sTC)
    this.selectionGroup:addElement(this)
    this.selectionGroup.current = this
    this.selectionGroup:addElement(this.element.v)
    this.element.v.onValueChange = this.onValueChange
    this:recalculate()

    return this
end
