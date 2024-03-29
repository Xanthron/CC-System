ui.button = {}
---Create a new button
---@return button
---@param parent element
---@param text string
---@param style style.button
---@param x integer
---@param y integer
---@param w integer
---@param h integer
---@param key string|nil
---@return button
function ui.button.new(parent, text, style, x, y, w, h, key)
    ---A simple button
    ---@class button:element
    local this = ui.element.new(parent, "button", x, y, w, h, key)

    ---@type style.button
    this.style = style
    ---@type string
    this.text = text
    ---@type boolean
    this._inAnimation = false

    ---Animation when button is pressed, so it is visible at a short click. return false when animation is finished
    ---@param data table
    ---@return boolean
    this.animation =
    ui.parallelElement.new(
        function(data)
            local clock = data[1] - os.clock() + 0.15
            if clock > 0 then
                sleep(clock)
            end
            this._inAnimation = false
            this:recalculate()
            this:repaint("this")
            return false
        end
    )
    ---Function for handling every event dedicated to the mouse
    ---@param event event
    ---@param x integer|nil
    ---@param y integer|nil
    ---@param w integer|nil
    ---@param h integer|nil
    ---@return element|nil
    function this:pointerEvent(event, x, y, w, h)
        x, y, w, h = ui.rect.overlaps(x, y, w, h, self.buffer.rect:getUnpacked())
        if event.name == "mouse_click" or event.name == "monitor_touch" then
            if event.param2 >= x and event.param2 < x + w and event.param3 >= y and event.param3 < y + h then
                self.mode = 4
                if self._inAnimation == false then
                    self._inAnimation = true
                    self:recalculate()
                    self:repaint("this", x, y, w, h)
                    self.animation.data[1] = os.clock()
                    self:getDrawer():getParallelManager():addFunction(self.animation)
                end
                if event.name == "monitor_touch" and self.onClick then
                    self.mode = 1
                    self:onClick(event)
                end
                return self
            end
        elseif event.name == "mouse_drag" then
            if self.mode == 3 and event.param2 >= x and event.param2 < x + w and event.param3 >= y and
                event.param3 < y + h then
                self.mode = 4
                if self._inAnimation == false then
                    self:recalculate()
                    self:repaint("this", x, y, w, h)
                end
            elseif self.mode == 4 and
                (event.param2 < x or event.param2 >= x + w or event.param3 < y or event.param3 >= y + h) then
                self.mode = 3
                if self._inAnimation == false then
                    self:recalculate()
                    self:repaint("this", x, y, w, h)
                end
            end
        elseif event.name == "mouse_up" then
            if self.mode == 4 and event.param2 >= x and event.param2 < x + w and event.param3 >= y and
                event.param3 < y + h then
                self.mode = 1
                if self._inAnimation == false then
                    self:recalculate()
                    self:repaint("this", x, y, w, h)
                end
                if self.onClick then
                    self:onClick(event)
                end
                return self
            elseif self.mode == 3 and
                (event.param2 < x or event.param2 >= x + w or event.param3 < y or event.param3 >= y + h) then
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
    function this:normalEvent(event)
        if event.name == "key" and self.mode == 3 and (event.param1 == 57 or event.param1 == 28 or event.param1 == 29) then
            self.mode = 4
            if self._inAnimation == false then
                self:recalculate()
                self:repaint("this", self:getCompleteMaskRect())
                self._inAnimation = true
                self.animation.data[1] = os.clock()
                self:getDrawer():getParallelManager():addFunction(self.animation)
            end
            return self
        elseif event.name == "key_up" and self.mode == 4 and
            (event.param1 == 57 or event.param1 == 28 or event.param1 == 29) then
            self.mode = 3
            if self._inAnimation == false then
                self:recalculate()
                self:repaint("this", self:getCompleteMaskRect())
            end
            if self.onClick then
                self:onClick(event)
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
        ui.buffer.borderLabelBox(self.buffer, self.text, theme.tC, theme.tBG, theme.b, theme.bC, theme.bBG,
            self.style.align)
    end

    this:recalculate()

    return this
end
