--FIXME Wenn die Borderseiten nicht deffiniert sind, dann ist das Scrollen verschoben

---@param parent element
---@param label string
---@param mode "1: vertical and horizontal"|"2: none"|"3: vertical"|"4: horizontal"
---@param style style.scrollView
function new(parent, label, mode, style, x, y, w, h)
    ---@class scrollView:element
    local this = ui.element.new(parent, x, y, w, h)

    this.label = label

    this.stylePadding = ui.padding.new(#style.normalTheme.border[4], #style.normalTheme.border[2], #style.normalTheme.border[5], #style.normalTheme.border[7])
    this._elements[1] = ui.element.new(this, this.stylePadding.getPaddedRect(this.buffer.rect.getUnpacked()))
    this._elements[1]._elements[1] = ui.element.new(this._elements[1], this.stylePadding.getPaddedRect(this.buffer.rect.getUnpacked()))

    ---@return element
    this.getContainer = function()
        return this._elements[1]._elements[1]
    end

    if mode == 1 or mode == 3 then
        local slideWidth = #style.sliderVertical.normal.handle
        this._elements[2] = ui.slider.new(this, nil, 1, 0, this._elements[1].getHeight(), this.getContainer().getHeight(), style.sliderVertical, x + w - math.max(math.ceil((this.stylePadding.right + slideWidth) / 2), slideWidth), y + this.stylePadding.top, slideWidth, h - this.stylePadding.top - this.stylePadding.bottom)
    end
    if mode == 1 or mode == 4 then
        local slideHeight = #style.sliderVertical.normal.handle
        this._elements[3] = ui.slider.new(this, nil, 2, 0, this._elements[1].getWidth(), this.getContainer().getWidth(), style.sliderHorizontal, x + this.stylePadding.left, y + h - math.max(math.ceil((this.stylePadding.bottom + slideHeight) / 2), slideHeight), w - this.stylePadding.left - this.stylePadding.right, slideHeight)
    end
    this.resizeContainer = function()
        local minX, minY, maxX, maxY = math.maxinteger, math.maxinteger, 0, 0
        for index, value in ipairs(this.getContainer()._elements) do
            if value.isVisible == true then
                x, y, w, h = value.getGlobalRect()
                minX = math.min(minX or x, x)
                minY = math.min(minY or y, y)
                maxX = math.max(maxX, x + w)
                maxY = math.max(maxY, y + h)
            end
        end
        this.getContainer().buffer.rect.set(minX, minY, maxX - minX, maxY - minY)
        --TODO Slider value update
    end

    this.resetLayout = function()
        this.stylePadding.set(#this.style.normalTheme.border[4], #this.style.normalTheme.border[2], #this.style.normalTheme.border[5], #this.style.normalTheme.border[7])
        local x, y, w, h = this.getGlobalRect()
        local sX, sY, sW, sH = this.stylePadding.getPaddedRect(this.buffer.rect.getUnpacked())
        this._elements[1].setGlobalRect(sX, sY, sW, sH)

        this.resizeContainer()
        local container = this.getContainer()
        local cX, cY, cW, cH = container.getLocalRect()

        ---@type slider
        local sliderVertical = this._elements[2]
        if sliderVertical then
            sliderVertical.style = this.style.sliderVertical
            local slideWidth = #this.style.sliderVertical.normal.handle
            sliderVertical.setGlobalRect(x + w - math.max(math.ceil((this.stylePadding.right + slideWidth) / 2), slideWidth), sY, slideWidth, sH)
            sliderVertical.startValue = cY
            sliderVertical.endValue = cH
            sliderVertical.size = sH
            sliderVertical.recalculate()
        end
        ---@type slider
        local sliderHorizontal = this._elements[3]
        if sliderHorizontal then
            sliderHorizontal.style = this.style.sliderHorizontal
            local slideHeight = #this.style.sliderHorizontal.normal.handle
            sliderHorizontal.setGlobalRect(x + this.stylePadding.left, y + h - math.max(math.ceil((this.stylePadding.bottom + slideHeight) / 2), slideHeight), sW, slideHeight)
            sliderHorizontal.startValue = cX
            sliderHorizontal.endValue = cW
            sliderHorizontal.size = sW
            sliderHorizontal.recalculate()
        end
    end

    ---@type style.scrollView
    this.style = style

    this._onValueChange = function(valueX, valueY)
        local container = this.getContainer()

        local maxMoveX = 0
        if valueX then
            if valueX > 0 then -- Down
                maxMoveX = math.max(0, math.min(valueX, container.getLocalPosX() + container.getWidth() - (this.getWidth() - this.stylePadding.right + 1)))
            elseif valueX < 0 then -- Up
                maxMoveX = math.min(0, math.max(valueX, container.getLocalPosX() + this.stylePadding.left - 1))
            end
        end

        local maxMoveY = 0
        if valueY then
            if valueY > 0 then -- Down
                maxMoveY = math.max(0, math.min(valueY, container.getLocalPosY() + container.getHeight() - (this.getHeight() - this.stylePadding.bottom + 1)))
            elseif valueY < 0 then -- Up
                maxMoveY = math.min(0, math.max(valueY, container.getLocalPosY() + this.stylePadding.top - 1))
            end
        end

        if maxMoveX ~= 0 or maxMoveY ~= 0 then
            container.setLocalRect(-maxMoveX, -maxMoveY, nil, nil)
            if maxMoveX ~= 0 then
                local sliderHorizontal = this._elements[3]
                if sliderHorizontal then
                    sliderHorizontal.value = sliderHorizontal.value + maxMoveX
                    sliderHorizontal.recalculate()
                end
            end
            if maxMoveY ~= 0 then
                local sliderVertical = this._elements[2]
                if sliderVertical then
                    sliderVertical.value = sliderVertical.value + maxMoveY
                    sliderVertical.recalculate()
                end
            end
            this.repaint("this", this.buffer.rect.getUnpacked())
        end
    end

    this._onValueChangeVertical = function(valueY)
        this._onValueChange(nil, valueY)
    end

    this._onValueChangeHorizontal = function(valueX)
        this._onValueChange(valueX, nil)
    end

    ---@param event event
    this._doNormalEvent = function(event)
        if this.mode == 3 and event.name == "mouse_scroll" then
            if this._elements[2] then
                this._onValueChange(nil, event.param1)
            elseif this._elements[3] then
                this._onValueChange(nil, event.param1)
            end
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
        local theme
        ---@type style.label.theme
        local labelTheme
        if this.mode == 1 then
            theme = this.style.normalTheme
            labelTheme = this.style.label.normalTheme
        elseif this.mode == 2 then
            theme = this.style.disabledTheme
            labelTheme = this.style.label.disabledTheme
        else
            theme = this.style.selectedTheme
            labelTheme = this.style.label.selectedTheme
        end

        ui.buffer.fillWithColor(this.buffer, theme.border[5][1], theme.spaceTextColor, theme.spaceBackgroundColor)
        ui.buffer.borderBox(this.buffer, theme.border, theme.borderColor, theme.borderBackgroundColor)
        if this.label then
            ui.buffer.labelBox(this.buffer, labelTheme.suffix .. this.label .. labelTheme.suffix, labelTheme.textColor, labelTheme.backgroundColor, this.style.label.alignment, nil, this.stylePadding.left, 0, this.stylePadding.right, this.buffer.rect.h - this.stylePadding.top)
        end
    end
    this.recalculate()

    this._selectionGroupListener = function(eventName, source, ...)
        if eventName == "selection_lose_focus" then
            local currentElement, newElement = ...
            if newElement == nil and source == "mouse" then
                return false
            else
                this.mode = 1
                this.recalculate()
                this.repaint("this")
            end
        elseif eventName == "selection_get_focus" then
            if this.selectionGroup.currentSelectionElement == nil then
                local index = 0
                if this._elements[2] then
                    index = index + 1
                end
                if this._elements[3] then
                    index = index + 1
                end
                if #this.selectionGroup.selectionElements > index then
                    local selectionElement = this.selectionGroup.selectionElements[index + 1]
                    local element = selectionElement.element
                    this.selectionGroup.currentSelectionElement = selectionElement
                    if this.selectionGroup.listener("selection_get_focus", "key", nil, element) ~= false then
                        if element and element.mode ~= 3 then
                            element.mode = 3
                            if not element._inAnimation then
                                element.recalculate()
                                element.repaint("this")
                            end
                        end
                        return false
                    end
                end
            end

            local currentElement, newElement = ...
            if newElement and (source == "key" or source == "code") then
                this.focusElement(newElement)
            end
            this.mode = 3
            this.recalculate()
            this.repaint("this")
            if source == "mouse" then
                return false
            end
        elseif eventName == "selection_reselect" then
            if source == "key" then
                local element = ...
                this.focusElement(element)
            end
        elseif eventName == "selection_change" then
            ---@type element
            local currentElement, newElement = ...
            if newElement == this or newElement == this._elements[2] or newElement == this._elements[3] then
                if currentElement and currentElement.mode == 3 then
                    currentElement.mode = 1
                    currentElement.recalculate()
                    currentElement.repaint("this")
                end
                return false
            elseif newElement and (source == "key" or source == "code") then
                this.focusElement(newElement)
            end
        end
    end

    ---@param element element
    this.focusElement = function(element)
        local x, y, w, h = this._elements[1].getGlobalRect()
        local eX, eY, eW, eH = element.getGlobalRect()
        local addW = math.floor(math.max(0, w - eW) / 2)
        local addH = math.floor(math.max(0, h - eH) / 2)
        this._onValueChange(eX - x - addW, eY - y - addH)
    end

    ---@type selectionGroup
    this.selectionGroup = ui.selectionGroup.new(nil, nil, this._selectionGroupListener)
    if this._elements[2] then
        this._elements[2]._onValueChange = this._onValueChangeVertical
        this.selectionGroup.addNewSelectionElement(this._elements[2])
    end
    if this._elements[3] then
        this._elements[3]._onValueChange = this._onValueChangeHorizontal
        this.selectionGroup.addNewSelectionElement(this._elements[3])
    end

    return this
end
