---@param parent element
---@param label string|nil
---@param mode "1 = vertical, horizontal"|"2 = non"|"3 = vertical"|"4 = horizontal"
---@param style style.scrollView
---@param x integer
---@param y integer
---@param w integer
---@param h integer
function new(parent, label, mode, style, x, y, w, h)
    ---@class scrollView:element
    local this = ui.element.new(parent, x, y, w, h)

    ---@type string
    this.label = label
    ---@type style.scrollView
    this.style = style
    ---@type padding
    this.stylePadding = ui.padding.new(#style.nTheme.b[4], #style.nTheme.b[2], #style.nTheme.b[5], #style.nTheme.b[7])
    this._elements[1] = ui.element.new(this, this.stylePadding:getPaddedRect(this.buffer.rect:getUnpacked()))
    this._elements[1]._elements[1] = ui.element.new(this._elements[1], this.stylePadding:getPaddedRect(this.buffer.rect:getUnpacked()))
    if mode == 1 or mode == 3 then
        local slideWidth = #style.sliderV.nTheme.handleL
        this._elements[2] = ui.slider.new(this, nil, 1, 0, this._elements[1]:getHeight(), this._elements[1]._elements[1]:getHeight(), style.sliderV, x + w - math.max(math.ceil((this.stylePadding.right + slideWidth) / 2), slideWidth), y + this.stylePadding.top, slideWidth, h - this.stylePadding.top - this.stylePadding.bottom)
    end
    if mode == 1 or mode == 4 then
        local slideHeight = #style.sliderV.nTheme.handleL
        this._elements[3] = ui.slider.new(this, nil, 2, 0, this._elements[1]:getWidth(), this._elements[1]._elements[1]:getWidth(), style.sliderH, x + this.stylePadding.left, y + h - math.max(math.ceil((this.stylePadding.bottom + slideHeight) / 2), slideHeight), w - this.stylePadding.left - this.stylePadding.right, slideHeight)
    end
    ---@type selectionGroup
    this.selectionGroup = ui.selectionGroup.new(nil, nil, this._selectionGroupListener)

    ---Get the container
    ---@return nil
    function this:getContainer()
        return self._elements[1]._elements[1]
    end
    ---Resize container based on elements
    ---@return nil
    this.resizeContainer = function()
        local minX, minY, maxX, maxY = 10 ^ 10 ^ 10, 10 ^ 10 ^ 10, 0, 0
        for index, value in ipairs(this._elements[1]._elements[1]._elements) do
            if value.isVisible == true then
                x, y, w, h = value:getGlobalRect()
                minX = math.min(minX or x, x)
                minY = math.min(minY or y, y)
                maxX = math.max(maxX, x + w)
                maxY = math.max(maxY, y + h)
            end
        end
        this._elements[1]._elements[1].buffer.rect:set(minX, minY, maxX - minX, maxY - minY)
    end
    ---Reset controlling elements layout
    ---@return nil
    function this:resetLayout()
        self.stylePadding:set(#self.style.nTheme.b[4], #self.style.nTheme.b[2], #self.style.nTheme.b[5], #self.style.nTheme.b[7])
        local x, y, w, h = self:getGlobalRect()
        local sX, sY, sW, sH = self.stylePadding:getPaddedRect(self.buffer.rect:getUnpacked())
        self._elements[1]:setGlobalRect(sX, sY, sW, sH)
        self:resizeContainer()
        local container = self:getContainer()
        local cX, cY, cW, cH = container:getLocalRect()
        local sliderVertical = self._elements[2]
        if sliderVertical then
            sliderVertical.style = self.style.sliderV
            local slideWidth = #self.style.sliderV.nTheme.handleL
            sliderVertical:setGlobalRect(x + w - math.max(math.ceil((self.stylePadding.right + slideWidth) / 2), slideWidth), sY, slideWidth, sH)
            sliderVertical.startValue = cY
            sliderVertical.endValue = cH
            sliderVertical.size = sH
            sliderVertical:recalculate()
        end
        local sliderHorizontal = self._elements[3]
        if sliderHorizontal then
            sliderHorizontal.style = self.style.sliderH
            local slideHeight = #self.style.sliderH.nTheme.handleL
            sliderHorizontal:setGlobalRect(x + self.stylePadding.left, y + h - math.max(math.ceil((self.stylePadding.bottom + slideHeight) / 2), slideHeight), sW, slideHeight)
            sliderHorizontal.startValue = cX
            sliderHorizontal.endValue = cW
            sliderHorizontal.size = sW
            sliderHorizontal:recalculate()
        end
    end
    ---Change scroll by value
    ---@param valueX integer
    ---@param valueY integer
    ---@return nil
    function this:_onValueChange(valueX, valueY)
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
                local sliderHorizontal = self._elements[3]
                if sliderHorizontal then
                    sliderHorizontal.value = sliderHorizontal.value + maxMoveX
                    sliderHorizontal:recalculate()
                end
            end
            if maxMoveY ~= 0 then
                local sliderVertical = self._elements[2]
                if sliderVertical then
                    sliderVertical.value = sliderVertical.value + maxMoveY
                    sliderVertical:recalculate()
                end
            end
            self:repaint("this", self.buffer.rect:getUnpacked())
        end
    end
    ---Change vertical scroll by value
    ---@param valueY integer
    ---@return nil
    function this:_onValueChangeVertical(valueY)
        self:_onValueChange(nil, valueY)
    end
    ---Change horizontal scroll by value
    ---@param valueX integer
    ---@return nil
    function this:_onValueChangeHorizontal(valueX)
        self:_onValueChange(valueX, nil)
    end
    ---Assigned function for every event except events dedicated to the mouse
    ---@param event event
    ---@return element|nil
    function this:_doNormalEvent(event)
        if self.mode == 3 and event.name == "mouse_scroll" then
            if self._elements[2] then
                self:_onValueChange(nil, event.param1)
            elseif self._elements[3] then
                self:_onValueChange(nil, event.param1)
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
            if newElement == nil and source == "mouse" then
                return false
            else
                this.mode = 1
                this:recalculate()
                this:repaint("this")
            end
        elseif eventName == "selection_get_focus" then
            if self.currentSelectionElement == nil then
                local index = 0
                if this._elements[2] then
                    index = index + 1
                end
                if this._elements[3] then
                    index = index + 1
                end
                if #self.selectionElements > index then
                    local selectionElement = self.selectionElements[index + 1]
                    local element = selectionElement.element
                    self.currentSelectionElement = selectionElement
                    if self:listener("selection_get_focus", "key", nil, element) ~= false then
                        if element and element.mode ~= 3 then
                            element.mode = 3
                            if not element._inAnimation then
                                element:recalculate()
                                element:repaint("this")
                            end
                        end
                        return false
                    end
                end
            end
            local currentElement, newElement = ...
            if newElement and (source == "key" or source == "code") then
                this:focusElement(newElement)
            end
            this.mode = 3
            this:recalculate()
            this:repaint("this")
            if source == "mouse" then
                return false
            end
        elseif eventName == "selection_reselect" then
            if source == "key" then
                local element = ...
                this:focusElement(element)
            end
        elseif eventName == "selection_change" then
            local currentElement, newElement = ...
            if newElement == this or newElement == this._elements[2] or newElement == this._elements[3] then
                if currentElement and currentElement.mode == 3 then
                    currentElement.mode = 1
                    currentElement:recalculate()
                    currentElement:repaint("this")
                end
                return false
            elseif newElement and (source == "key" or source == "code") then
                this:focusElement(newElement)
            end
        end
    end
    ---Set an containing element to focus
    ---@param element element
    ---@return nil
    function this:focusElement(element)
        local x, y, w, h = self._elements[1]:getGlobalRect()
        local eX, eY, eW, eH = element:getGlobalRect()
        local addW = math.floor(math.max(0, w - eW) / 2)
        local addH = math.floor(math.max(0, h - eH) / 2)
        self:_onValueChange(eX - x - addW, eY - y - addH)
    end

    if this._elements[2] then
        this._elements[2]._onValueChange = this._onValueChangeVertical
        this.selectionGroup:addNewSelectionElement(this._elements[2])
    end
    if this._elements[3] then
        this._elements[3]._onValueChange = this._onValueChangeHorizontal
        this.selectionGroup:addNewSelectionElement(this._elements[3])
    end
    this:recalculate()

    return this
end
