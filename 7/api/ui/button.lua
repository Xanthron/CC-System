---Create a new button
---@return button
function new(parent, text, func, style, x, y, w, h)
    ---A simple button
    ---@class button:element
    local this = ui.element.new(parent, x, y, w, h)
    this.style = style
    this.text = text
    this._inAnimation = false

    ---Animation when button is pressed, so it is visible at a short click. return false when animation is finished
    ---@param data table
    ---@return boolean
    function this:_pressAnimation(data)
        local clock = data[1] - os.clock() + 0.15
        if clock > 0 then
            sleep(clock)
        end
        self._inAnimation = false
        self:recalculate()
        self:repaint("this")
        return false
    end
    ---Function for handling every event dedicated to the mouse
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
                self.mode = 1
                if self._inAnimation == false then
                    self:recalculate()
                    self:repaint("this", x, y, w, h)
                end
                if self._onClick then
                    self:_onClick(event)
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
    ---Function for handling every event except events dedicated do the mouse
    ---@param event event
    ---@return element|nil
    function this:_doNormalEvent(event)
        if event.name == "key" and self.mode == 3 and (event.param1 == 57 or event.param1 == 28 or event.param1 == 29) then
            self.mode = 4
            if self._inAnimation == false then
                self:recalculate()
                self:repaint("this", self:getCompleteMaskRect())
                self._inAnimation = true
                self:getManager().parallelManager:addFunction(self._pressAnimation, {os.clock()})
            end
            return self
        elseif
            event.name == "key_up" and self.mode == 4 and
                (event.param1 == 57 or event.param1 == 28 or event.param1 == 29)
         then
            self.mode = 3
            if self._inAnimation == false then
                self:recalculate()
                self:repaint("this", self:getCompleteMaskRect())
            end
            if self._onClick then
                self:_onClick(event)
            end
            return self
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
        ui.buffer.borderLabelBox(
            self.buffer,
            self.text,
            theme.tC,
            theme.tBG,
            theme.b,
            theme.bC,
            theme.bBG,
            self.style.align
        )
    end

    this:recalculate()

    return this
end
