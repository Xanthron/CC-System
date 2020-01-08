function new(parent, text, checked, func, style, x, y, w, h)
    ---@class toggle
    local this = ui.element.new(parent, x, y, w, h)
    this.style = style
    this.text = text
    this._checked = checked
    this._inAnimation = false
    this._onToggle = func
    this._pressAnimation = function(data)
        local clock = data[1] - os.clock() + 0.15
        if clock > 0 then
            sleep(clock)
        end
        this._inAnimation = false
        this:recalculate()
        local x, y, w, h, possible = this:getCompleteMaskRect()
        if possible then
            this:repaint("this", x, y, w, h)
        end
        return false
    end
    ---Assigned function for every event dedicated to the mouse
    ---@param event event
    ---@param x integer|optional
    ---@param y integer|optional
    ---@param w integer|optional
    ---@param h integer|optional
    ---@return element|nil
    function this:_doPointerEvent(event, x, y, w, h)
        x, y, w, h = ui.rect.overlaps(x, y, w, h, self.buffer.rect:getUnpacked())
        if event.name == "mouse_click" then
            if event.param2 >= x and event.param2 < x + w and event.param3 >= y and event.param3 < y + h then
                self.mode = 4
                if self._inAnimation == false then
                    self._inAnimation = true
                    self:recalculate()
                    self:repaint("this", x, y, w, h)
                    self:getManager().parallelManager:addFunction(self._pressAnimation, {os.clock()})
                end
                return self
            end
        elseif event.name == "mouse_drag" then
            if
                self.mode == 3 and event.param2 >= x and event.param2 < x + w and event.param3 >= y and
                    event.param3 < y + h
             then
                self.mode = 4
                if self._inAnimation == false then
                    self:recalculate()
                    self:repaint("this", x, y, w, h)
                end
            elseif
                self.mode == 4 and
                    (event.param2 < x or event.param2 >= x + w or event.param3 < y or event.param3 >= y + h)
             then
                self.mode = 3
                if self._inAnimation == false then
                    self:recalculate()
                    self:repaint("this", x, y, w, h)
                end
            end
        elseif event.name == "mouse_up" then
            if
                self.mode == 4 and event.param2 >= x and event.param2 < x + w and event.param3 >= y and
                    event.param3 < y + h
             then
                self._checked = self._checked == false
                self.mode = 1
                if self._inAnimation == false then
                    self:recalculate()
                    self:repaint("this", x, y, w, h)
                end
                if self._onToggle then
                    self:_onToggle(event, self._checked)
                end
                return self
            elseif
                self.mode == 3 and
                    (event.param2 < x or event.param2 >= x + w or event.param3 < y or event.param3 >= y + h)
             then
                self.mode = 1
                if self._inAnimation == false then
                    self:recalculate()
                    self:repaint("this", x, y, w, h)
                end
                return self
            end
        end
    end
    ---Intern function for every event except events dedicated to the mouse
    ---@param event event
    ---@return element|nil
    function this:_doNormalEvent(event)
        if event.name == "key" and self.mode == 3 and (event.param1 == 57 or event.param1 == 28) then
            self.mode = 4
            if self._inAnimation == false then
                self._inAnimation = true
                self:recalculate()
                self:repaint("this", self:getCompleteMaskRect())
                self:getManager().parallelManager:addFunction(self._pressAnimation, {os.clock()})
            end
            return true
        elseif event.name == "key_up" and self.mode == 4 and (event.param1 == 57 or event.param1 == 28) then
            self._checked = self._checked == false
            self.mode = 3
            if self._inAnimation == false then
                self:recalculate()
                self:repaint("this", self:getCompleteMaskRect())
            end
            if self._onToggle then
                self:_onToggle(event, self._checked)
            end
            return true
        end
    end
    ---Recalculate the buffer of this element
    ---@return nil
    function this:recalculate()
        local mode = self.mode
        local theme = nil
        if mode == 1 then
            theme = self.style.nTheme
        elseif mode == 2 then
            theme = self.style.dTheme
        elseif mode == 3 then
            theme = self.style.sTheme
        else
            theme = self.style.pTheme
        end
        local checkbox, checkboxTextColor, checkboxBackGroundColor = nil, nil, nil
        if self._checked == true then
            checkbox = theme.checkedL
            checkboxTextColor = theme.checkedLC
            checkboxBackGroundColor = theme.checkedLBG
        else
            checkbox = theme.uncheckedL
            checkboxTextColor = theme.uncheckedLC
            checkboxBackGroundColor = theme.uncheckedLBG
        end
        local buffer = self.buffer
        local align = self.style.align
        ui.buffer.labelBox(buffer, self.text, theme.tC, theme.tBG, align, " ", #checkbox, 0, 0, 0)
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

    this:recalculate()

    return this
end
