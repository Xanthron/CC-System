ui.slider = {}
---@param parent element
---@param orientation "1 = vertical"|"2 = horizontal"
---@param startValue integer
---@param endValue integer
---@param size integer
---@param style style.slider
---@param x integer
---@param y integer
---@param w integer
---@param h integer
---@return slider
function ui.slider.new(parent, orientation, startValue, endValue, size, style, x, y, w, h)
    ---@class slider:element
    local this = ui.element.new(parent, "slider", x, y, w, h)
    ---@type style.slider
    this.style = style
    ---@type integer
    this.orientation = orientation
    ---@private
    ---@type integer
    this._pressedButton = 0
    ---@type repeatItem
    this.repeatItem = ui.repeatItem.new(0.8, 0.05, 0.7)
    ---@type integer
    this.startValue = startValue
    ---@type integer
    this.endValue = endValue
    ---@type integer
    this.size = size
    ---@type integer
    this.value = startValue
    ---@type parallelElement
    this._repeatButtonPressElement =
        ui.parallelElement.new(
        function(data)
            while true do
                if this.mode == 4 and this.repeatItem:call() == true then
                    if this._pressedButton == 1 then
                        if this.onValueChange then
                            this.onValueChange(-1)
                        end
                    else
                        if this.onValueChange then
                            this.onValueChange(1)
                        end
                    end
                end
                sleep(0)
            end
        end
    )

    ---@type function
    ---@param value integer
    ---@return nil
    this.onValueChange = nil

    ---Recalculate the buffer of this element
    ---@return nil
    function this:recalculate()
        local buffer = self.buffer
        local theme = {}
        local mode = self.mode
        if mode == 2 then
            theme = self.style.dTheme
        else
            theme = self.style.nTheme
        end
        local totalSize = self.endValue - self.startValue
        local value = math.max(0, (self.value) / math.max(1, (totalSize + self.startValue - self.size)))
        if self.orientation == 1 then
            local height = self.buffer.rect.h
            local barHeight
            local offset
            if totalSize <= self.size then
                barHeight = height - 2
                offset = 1
            else
                barHeight = math.max(1, math.min(math.floor(size / (totalSize + self.startValue) * (height - 2)), height - math.min(4, totalSize - size + 2)))
                offset = math.max(0, math.floor((height - 3 - barHeight) * value)) + 1
                if value > 0 then
                    offset = offset + 1
                end
            end
            local width = #theme.sliderT
            if self.buffer.rect.w ~= width then
            end
            local index = 1
            if mode == 2 or value == 0 then
                for i = 1, width do
                    buffer.text[index] = theme.buttonP.dTheme.t[i]
                    buffer.textColor[index] = theme.buttonP.dTheme.tC[i]
                    buffer.textBackgroundColor[index] = theme.buttonP.dTheme.tBG[i]
                    index = index + 1
                end
            else
                if self._pressedButton == 1 and self.mode == 4 then
                    for i = 1, width do
                        buffer.text[index] = theme.buttonP.sTheme.t[i]
                        buffer.textColor[index] = theme.buttonP.sTheme.tC[i]
                        buffer.textBackgroundColor[index] = theme.buttonP.sTheme.tBG[i]
                        index = index + 1
                    end
                else
                    for i = 1, width do
                        buffer.text[index] = theme.buttonP.nTheme.t[i]
                        buffer.textColor[index] = theme.buttonP.nTheme.tC[i]
                        buffer.textBackgroundColor[index] = theme.buttonP.nTheme.tBG[i]
                        index = index + 1
                    end
                end
            end
            for i = 2, self.buffer.rect.h - 1 do
                for j = 1, width do
                    if i > offset and i <= offset + barHeight then
                        buffer.text[index] = theme.sliderT[j]
                        buffer.textColor[index] = theme.sliderTC[j]
                        buffer.textBackgroundColor[index] = theme.sliderTBG[j]
                        index = index + 1
                    else
                        buffer.text[index] = theme.handleL[j]
                        buffer.textColor[index] = theme.handleLC[j]
                        buffer.textBackgroundColor[index] = theme.handleLBG[j]
                        index = index + 1
                    end
                end
            end
            if mode == 2 or value == 1 or totalSize - self.size <= 0 then
                for i = 1, width do
                    buffer.text[index] = theme.buttonN.dTheme.t[i]
                    buffer.textColor[index] = theme.buttonN.dTheme.tC[i]
                    buffer.textBackgroundColor[index] = theme.buttonN.dTheme.tBG[i]
                    index = index + 1
                end
            else
                if self._pressedButton == 2 and self.mode == 4 then
                    for i = 1, width do
                        buffer.text[index] = theme.buttonN.sTheme.t[i]
                        buffer.textColor[index] = theme.buttonN.sTheme.tC[i]
                        buffer.textBackgroundColor[index] = theme.buttonN.sTheme.tBG[i]
                        index = index + 1
                    end
                else
                    for i = 1, width do
                        buffer.text[index] = theme.buttonN.nTheme.t[i]
                        buffer.textColor[index] = theme.buttonN.nTheme.tC[i]
                        buffer.textBackgroundColor[index] = theme.buttonN.nTheme.tBG[i]
                        index = index + 1
                    end
                end
            end
        else
            local width = self.buffer.rect.w
            local barWidth
            local offset
            if totalSize <= self.size then
                barWidth = width - 2
                offset = 1
            else
                barWidth = math.max(1, math.min(math.floor(size / (totalSize + self.startValue) * (width - 2)), width - math.min(4, totalSize - size + 2)))
                offset = math.max(0, math.floor((width - 3 - barWidth) * value)) + 1
                if value > 0 then
                    offset = offset + 1
                end
            end
            local height = #theme.sliderT
            if self.buffer.rect.h ~= height then
            end
            local index = 1
            if mode == 2 or value == 0 then
                for i = 1, height do
                    buffer.text[index] = theme.buttonP.dTheme.t[i]
                    buffer.textColor[index] = theme.buttonP.dTheme.tC[i]
                    buffer.textBackgroundColor[index] = theme.buttonP.dTheme.tBG[i]
                    index = index + width
                end
            else
                if self._pressedButton == 1 and self.mode == 4 then
                    for i = 1, height do
                        buffer.text[index] = theme.buttonP.sTheme.t[i]
                        buffer.textColor[index] = theme.buttonP.sTheme.tC[i]
                        buffer.textBackgroundColor[index] = theme.buttonP.sTheme.tBG[i]
                        index = index + width
                    end
                else
                    for i = 1, height do
                        buffer.text[index] = theme.buttonP.nTheme.t[i]
                        buffer.textColor[index] = theme.buttonP.nTheme.tC[i]
                        buffer.textBackgroundColor[index] = theme.buttonP.nTheme.tBG[i]
                        index = index + width
                    end
                end
            end
            index = 2
            for i = 2, width - 1 do
                for j = 1, height do
                    if i > offset and i <= offset + barWidth then
                        buffer.text[index] = theme.sliderT[j]
                        buffer.textColor[index] = theme.sliderTC[j]
                        buffer.textBackgroundColor[index] = theme.sliderTBG[j]
                        index = index + width
                    else
                        buffer.text[index] = theme.handleL[j]
                        buffer.textColor[index] = theme.handleLC[j]
                        buffer.textBackgroundColor[index] = theme.handleLBG[j]
                        index = index + width
                    end
                    index = i + j
                end
            end
            if mode == 2 or value == 1 or totalSize - self.size <= 0 then
                for i = 1, height do
                    buffer.text[index] = theme.buttonN.dTheme.t[i]
                    buffer.textColor[index] = theme.buttonN.dTheme.tC[i]
                    buffer.textBackgroundColor[index] = theme.buttonN.dTheme.tBG[i]
                    index = index + width
                end
            else
                if self._pressedButton == 2 and self.mode == 4 then
                    for i = 1, height do
                        buffer.text[index] = theme.buttonN.sTheme.t[i]
                        buffer.textColor[index] = theme.buttonN.sTheme.tC[i]
                        buffer.textBackgroundColor[index] = theme.buttonN.sTheme.tBG[i]
                        index = index + width
                    end
                else
                    for i = 1, height do
                        buffer.text[index] = theme.buttonN.nTheme.t[i]
                        buffer.textColor[index] = theme.buttonN.nTheme.tC[i]
                        buffer.textBackgroundColor[index] = theme.buttonN.nTheme.tBG[i]
                        index = index + width
                    end
                end
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
        local rectX, rectY, rectW, rectH = self:getGlobalRect()
        x, y, w, h = ui.rect.overlaps(x, y, w, h, rectX, rectY, rectW, rectH)
        if self.orientation == 1 then
            if event.name == "mouse_click" then
                if event.param2 >= x and event.param2 < x + w then
                    if y == rectY and event.param3 == y then
                        self.mode = 4
                        self._pressedButton = 1
                        self:recalculate()
                        self:repaint("this", x, y, w, h)
                        self:getManager().parallelManager:addFunction(self._repeatButtonPressElement)
                        return self
                    elseif y + h == rectY + rectH and event.param3 == y + h - 1 then
                        self.mode = 4
                        self._pressedButton = 2
                        self:recalculate()
                        self:repaint("this", x, y, w, h)
                        self:getManager().parallelManager:addFunction(self._repeatButtonPressElement)
                        return self
                    elseif event.param3 > y and event.param3 < y + h - 1 then
                        self.mode = 4
                        local newPos = event.param3 - rectY - 1
                        local totalSize = self.endValue - self.startValue
                        local newValue = math.floor((newPos / (rectH - 3)) * (totalSize - self.size + self.startValue))
                        self.onValueChange(newValue - self.value)
                        return self
                    end
                end
            elseif event.name == "mouse_drag" then
                if event.param2 >= x and event.param2 < x + w and self.mode == 3 and ((self._pressedButton == 1 and event.param3 == y) or (self._pressedButton == 2 and event.param3 == y + h - 1)) then
                    self.mode = 4
                    self:recalculate()
                    self:repaint("this", x, y, w, h)
                    return self
                elseif self.mode == 4 then
                    if self._pressedButton == 0 then
                        local newPos = math.max(0, math.min(rectH - 2, event.param3 - rectY - 1))
                        local totalSize = self.endValue - self.startValue
                        local newValue = math.floor((newPos / (rectH - 3)) * (totalSize - self.size + self.startValue))
                        self.onValueChange(newValue - self.value)
                        return self
                    else
                        self.mode = 3
                        self:recalculate()
                        self:repaint("this", x, y, w, h)
                        return self
                    end
                end
            elseif event.name == "mouse_up" then
                if self.mode == 3 or self.mode == 4 then
                    self.mode = 1
                    self:recalculate()
                    self:repaint("this", x, y, w, h)
                    self.repeatItem:reset()
                    self:getManager().parallelManager:removeFunction(self._repeatButtonPressElement)
                    self._pressedButton = 0
                    return self
                end
            end
        else
            if event.name == "mouse_click" then
                if event.param3 >= y and event.param3 < y + h then
                    if x == rectX and event.param2 == x then
                        self.mode = 4
                        self._pressedButton = 1
                        self:recalculate()
                        self:repaint("this", x, y, w, h)
                        self:getManager().parallelManager:addFunction(self._repeatButtonPressElement)
                        return self
                    elseif x + w == rectX + rectW and event.param2 == x + w - 1 then
                        self.mode = 4
                        self._pressedButton = 2
                        self:recalculate()
                        self:repaint("this", x, y, w, h)
                        self:getManager().parallelManager:addFunction(self._repeatButtonPressElement)
                        return self
                    elseif event.param2 > x and event.param2 < x + w - 1 then
                        self.mode = 4
                        local newPos = event.param2 - rectX - 1
                        local totalSize = self.endValue - self.startValue
                        local newValue = math.floor((newPos / (rectW - 3)) * (totalSize - self.size + self.startValue))
                        self.onValueChange(newValue - self.value)
                        return self
                    end
                end
            elseif event.name == "mouse_drag" then
                if event.param3 >= y and event.param3 < y + h and self.mode == 3 and ((self._pressedButton == 1 and event.param2 == x) or (self._pressedButton == 2 and event.param2 == x + w - 1)) then
                    self.mode = 4
                    self:recalculate()
                    self:repaint("this", x, y, w, h)
                    return self
                elseif self.mode == 4 then
                    if self._pressedButton == 0 then
                        local newPos = math.max(0, math.min(rectW - 2, event.param2 - rectX - 1))
                        local totalSize = self.endValue - self.startValue
                        local newValue = math.floor((newPos / (rectW - 3)) * (totalSize - self.size + self.startValue))
                        self.onValueChange(newValue - self.value)
                        return self
                    else
                        self.mode = 3
                        self:recalculate()
                        self:repaint("this", x, y, w, h)
                        return self
                    end
                end
            elseif event.name == "mouse_up" then
                if self.mode == 3 or self.mode == 4 then
                    self.mode = 1
                    self:recalculate()
                    self:repaint("this", x, y, w, h)
                    self.repeatItem:reset()
                    self:getManager().parallelManager:removeFunction(self._repeatButtonPressElement)
                    self._pressedButton = 0
                    return self
                end
            end
        end
    end

    this:recalculate()

    return this
end
