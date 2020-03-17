ui.drawer = {}
---Create a new drawer
---@param x integer
---@param y integer
---@param w integer
---@param h integer
---@return drawer
function ui.drawer.new(input, x, y, w, h)
    ---Base drawer to handel drawing end events
    ---@class drawer:element
    local this = ui.element.new(nil, "drawer", x, y, w, h)
    ---@type selectionManager
    this.selectionManager = ui.selectionManager.new()
    ---@type function
    this.getCursorPos = nil

    ---@type term
    this._term = ui.input.term
    this._input = input

    function this:getParallelManager()
        return this._input.parallelManager
    end

    function this:getInput()
        return this._input
    end

    function this:getTerm()
        return self._term
    end

    ---Draws the containing elements to the screen
    ---@return nil
    function this:draw()
        local x, y, w, h = self:getSimpleMaskRect()
        self:doDraw(self.buffer, x, y, w, h)
        self.buffer:draw(self:getTerm(), x, y, w, h)
    end

    function this.event(event)
        --TODO term specific
        term.setCursorBlink(false)
        local eventName = event.name
        if eventName == "mouse_click" or eventName == "mouse_up" or eventName == "mouse_drag" or eventName == "monitor_touch" then
            local element = this:doPointerEvent(event, this:getSimpleMaskRect())
            if #this.selectionManager.groups > 0 then
                this.selectionManager:mouseEvent(event, element)
            end
        else
            if not this:doNormalEvent(event) then
                if eventName == "key" or eventName == "key_up" then
                    if #this.selectionManager.groups > 0 then
                        this.selectionManager:keyEvent(event)
                    end
                end
            end
        end
        --TODO term specific
        if this.getCursorPos then
            local blinking, posX, posY, textColor = this.getCursorPos()
            if blinking == nil then
                this.getCursorPos = nil
            else
                term.setCursorPos(posX, posY)
                term.setCursorBlink(blinking)
                if textColor and term.isColor() then
                    term.setTextColor(textColor)
                end
            end
        end
        --return false
    end

    return this
end
