ui.scrollView = {}
---@param parent element
---@param label string|nil
---@param mode "1 = vertical, horizontal"|"2 = non"|"3 = vertical"|"4 = horizontal"
---@param style style.scrollView
---@param x integer
---@param y integer
---@param w integer
---@param h integer
---@param key string|optional
---@return scrollView
function ui.scrollView.new(parent, label, mode, style, x, y, w, h, key)
    ---@class scrollView:element
    local this = ui.element.new(parent, "scrollView", x, y, w, h, key)

    ---@type string
    this.label = label
    ---@type style.scrollView
    this.style = style
    ---@type padding
    this.stylePadding = ui.padding.new(#style.nTheme.b[4], #style.nTheme.b[2], #style.nTheme.b[5], #style.nTheme.b[7])
    ui.element.new(this, "container", this.stylePadding:getPaddedRect(this.buffer.rect:getUnpacked()))
    ui.element.new(this.element[1], "container", this.stylePadding:getPaddedRect(this.buffer.rect:getUnpacked()))
    if mode == 1 or mode == 3 then
        local slideWidth = #style.sliderV.nTheme.handleL
        ui.slider.new(this, 1, 0, 0, 0, style.sliderV, x + w - math.max(math.ceil((this.stylePadding.right + slideWidth) / 2), slideWidth), y + this.stylePadding.top, slideWidth, h - this.stylePadding.top - this.stylePadding.bottom, "v")
    end
    if mode == 1 or mode == 4 then
        local slideHeight = #style.sliderV.nTheme.handleL
        ui.slider.new(this, 2, 0, 0, 0, x + this.stylePadding.left, y + h - math.max(math.ceil((this.stylePadding.bottom + slideHeight) / 2), slideHeight), w - this.stylePadding.left - this.stylePadding.right, slideHeight, "h")
    end
    ---@type selectionGroup
    this.selectionGroup = ui.selectionGroup.new()
    this.selectable = false
    this.scrollWithoutSelection = true

    ---Get the container
    ---@return nil
    function this:getContainer()
        return self.element[1].element[1]
    end

    function this:resizeSlider()
        local cX, cY, cW, cH = self:getContainer():getLocalRect()

        local sliderV = self.element.v
        if sliderV then
            local h = sliderV:getHeight()
            sliderV.startValue = cY
            sliderV.endValue = cY + cH - 1
            sliderV.size = h
            sliderV.value = math.max(0, math.min(cH - h, sliderV.value))
            sliderV:recalculate()
        end

        local sliderH = self.element.h
        if sliderH then
            local w = sliderH:getWidth()
            sliderH.startValue = cX
            sliderH.endValue = cX + cW - 1
            sliderH.size = w
            sliderH.value = math.max(0, math.min(cW - w, sliderH.value))
            sliderH:recalculate()
        end
    end

    ---Resize container based on elements.
    ---@return nil
    function this:resizeContainer()
        local container = self:getContainer()
        local minX, minY, maxX, maxY = nil, nil, 0, 0
        for _, v in ipairs(container.element) do
            if v.isVisible == true then
                x, y, w, h = v:getGlobalRect()
                minX = math.min(minX or x, x)
                minY = math.min(minY or y, y)
                maxX = math.max(maxX, x + w)
                maxY = math.max(maxY, y + h)
            end
        end
        if minX then
            container.buffer.rect:set(minX, minY, maxX - minX, maxY - minY)
        end

        self:resizeSlider()
    end

    ---Reset controlling elements layout
    ---@return nil
    function this:resetLayout()
        self.stylePadding:set(#self.style.nTheme.b[4], #self.style.nTheme.b[2], #self.style.nTheme.b[5], #self.style.nTheme.b[7])
        local x, y, w, h = self:getGlobalRect()
        local sX, sY, sW, sH = self.stylePadding:getPaddedRect(self.buffer.rect:getUnpacked())
        self.element[1]:setGlobalRect(sX, sY, sW, sH)
        local sliderV = self.element.v
        if sliderV then
            sliderV.style = self.style.sliderV
            local slideWidth = #self.style.sliderV.nTheme.handleL
            sliderV:setGlobalRect(x + w - math.max(math.ceil((self.stylePadding.right + slideWidth) / 2), slideWidth), sY, slideWidth, sH)
        end
        local sliderH = self.element.h
        if sliderH then
            sliderH.style = self.style.sliderH
            local slideHeight = #self.style.sliderH.nTheme.handleL
            sliderH:setGlobalRect(x + self.stylePadding.left, y + h - math.max(math.ceil((self.stylePadding.bottom + slideHeight) / 2), slideHeight), sW, slideHeight)
        end
        self:resizeContainer()
    end
    ---Change scroll by value
    ---@param valueX integer
    ---@param valueY integer
    ---@return nil
    function this:onValueChange(valueX, valueY)
        local container = self:getContainer()
        local maxMoveX = 0
        if valueX then
            if valueX > 0 then
                maxMoveX = math.max(0, math.min(valueX, container:getLocalPosX() + container:getWidth() - (self:getWidth() - self.stylePadding.right + 1)))
            elseif valueX < 0 then
                maxMoveX = math.min(0, math.max(valueX, container:getLocalPosX() + self.stylePadding.left - 1))
            end
        end
        local maxMoveY = 0
        if valueY then
            if valueY > 0 then
                maxMoveY = math.max(0, math.min(valueY, container:getLocalPosY() + container:getHeight() - (self:getHeight() - self.stylePadding.bottom + 1)))
            elseif valueY < 0 then
                maxMoveY = math.min(0, math.max(valueY, container:getLocalPosY() + self.stylePadding.top - 1))
            end
        end
        if maxMoveX ~= 0 or maxMoveY ~= 0 then
            container:setLocalRect(-maxMoveX, -maxMoveY, nil, nil)
            if maxMoveX ~= 0 then
                local sliderH = self.element.h
                if sliderH then
                    sliderH.value = sliderH.value + maxMoveX
                    sliderH:recalculate()
                end
            end
            if maxMoveY ~= 0 then
                local sliderV = self.element.v
                if sliderV then
                    sliderV.value = sliderV.value + maxMoveY
                    sliderV:recalculate()
                end
            end
            self:repaint("this")
        --, self.buffer.rect:getUnpacked())
        --self:resizeSlider()
        end
    end
    ---Change vertical scroll by value
    ---@param valueY integer
    ---@return nil
    function this._onValueChangeVertical(valueY)
        this:onValueChange(nil, valueY)
    end
    ---Change horizontal scroll by value
    ---@param valueX integer
    ---@return nil
    function this._onValueChangeHorizontal(valueX)
        this:onValueChange(valueX, nil)
    end
    ---Assigned function for every event except events dedicated to the mouse
    ---@param event event
    ---@return element|nil
    function this:normalEvent(event)
        if (self.scrollWithoutSelection or not self.selectable or self.mode == 3) and event.name == "mouse_scroll" then
            if self.element.v then
                self:onValueChange(nil, event.param1)
                return this
            elseif self.element.h then
                self:onValueChange(nil, event.param1)
                return this
            end
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
        if (event.name == "mouse_click" or event.name == "monitor_touch") and self.mode ~= 3 then
            x, y, w, h = ui.rect.overlaps(x, y, w, h, self.buffer.rect:getUnpacked())
            if event.param2 >= x and event.param2 < x + w and event.param3 >= y and event.param3 < y + h then
                self:getManager().selectionManager:select(self.selectionGroup, "mouse", 3)
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
        ui.buffer.fill(self.buffer, theme.b[5][1], theme.spaceTextColor, theme.spaceBackgroundColor)
        ui.buffer.borderBox(self.buffer, theme.b, theme.bC, theme.bBG)
        if self.label then
            ui.buffer.labelBox(self.buffer, labelTheme.suffix .. self.label .. labelTheme.suffix, labelTheme.tC, labelTheme.tBG, self.style.label.align, nil, self.stylePadding.left, 0, self.stylePadding.right, self.buffer.rect.h - self.stylePadding.top)
        end
    end
    ---Listener function of the selectionGroup
    ---@param eventName string
    ---@param source string
    ---@param ... any
    ---@return boolean
    function this.selectionGroup:listener(eventName, source, ...)
        if eventName == "selection_lose_focus" then
            local currentElement, newElement = ...
            this:changeMode(1)
        elseif this.selectable and eventName == "selection_get_focus" then
            local currentElement, newElement = ...
            if newElement == this or newElement == this.element.v or newElement == this.element.h then
                newElement = self.current or this:getContainer().element[1]
                local mode = 3
                if source == "mouse" then
                    mode = 1
                end
                if newElement then
                    --this:getManager().selectionManager:select(newElement, source, mode)
                elseif currentElement then
                    currentElement:changeMode(1)
                end
                return false
            end
            this:changeMode(3)
            if newElement and source ~= "mouse" then
                this:focusElement(newElement)
            end
        elseif eventName == "selection_reselect" then
            if source == "key" then
                local element = ...
                this:focusElement(element)
            end
        elseif eventName == "selection_change" then
            ---@type element
            local currentElement, newElement = ...
            if newElement == this or newElement == this.element.v or newElement == this.element.h then
                currentElement:changeMode(1)
                return false
            elseif newElement and source ~= "mouse" then
                this:focusElement(newElement)
            end
        end
    end

    ---Clears all elements in container and in selection
    ---@return nil
    function this:clear()
        local container = self:getContainer()
        for i = 1, #container.element do
            container.element[1]:setParent(nil)
        end
        local index = 2
        for i = 2, 3 do
            if self.element[i] then
                index = index + 1
            end
        end
        for i = index, #self.selectionGroup.elements do
            self.selectionGroup.elements[i] = nil
        end
    end
    ---Set an containing element to focus
    ---@param element element
    ---@return nil
    function this:focusElement(element)
        local x, y, w, h = self.element[1]:getGlobalRect()
        local eX, eY, eW, eH = element:getGlobalRect()
        local addW = math.floor(math.max(0, w - eW) / 2)
        local addH = math.floor(math.max(0, h - eH) / 2)
        self:onValueChange(eX - x - addW, eY - y - addH)
    end

    this.selectionGroup:addElement(this)
    if this.element.v then
        this.element.v.onValueChange = this._onValueChangeVertical
        this.selectionGroup:addElement(this.element.v)
    end
    if this.element.h then
        this.element.h.onValueChange = this._onValueChangeHorizontal
        this.selectionGroup:addElement(this.element.h)
    end
    this:recalculate()

    return this
end
