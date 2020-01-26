ui.uiManager = {}
---Create a new uiManager
---@param x integer
---@param y integer
---@param w integer
---@param h integer
---@return uiManager
function ui.uiManager.new(x, y, w, h)
    ---Base Manager to handel drawing end events
    ---@class uiManager:element
    local this = ui.element.new(nil, "uiManager", x, y, w, h)
    ---@type parallelManager
    this.parallelManager = ui.parallelManager.new()
    ---@type selectionManager
    this.selectionManager = ui.selectionManager.new()
    ---@type event
    this._event = ui.event.new()
    ---@type function
    this.getCursorPos = nil
    ---@type function
    this._callFunction = nil
    ---@type boolean
    this._exit = false

    ---Draws the containing elements to the screen
    ---@return nil
    function this:draw()
        local x, y, w, h = self:getSimpleMaskRect()
        self:doDraw(self.buffer, x, y, w, h)
        self.buffer:draw(x, y, w, h)
    end
    ---Intern function for execute to pass down the event to all elements
    ---@return nil
    function this._execute()
        while true do
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
            this._event:pull()
            term.setCursorBlink(false)
            local eventName = this._event.name
            if
                eventName == "mouse_click" or eventName == "mouse_up" or eventName == "mouse_drag" or
                    eventName == "monitor_touch"
             then
                local element = this:doPointerEvent(this._event, this:getSimpleMaskRect())
                if #this.selectionManager.groups > 0 then
                    this.selectionManager:mouseEvent(this._event, element)
                end
            else
                if not this:doNormalEvent(this._event) then
                    if eventName == "key" or eventName == "key_up" then
                        if #this.selectionManager.groups > 0 then
                            this.selectionManager:keyEvent(this._event)
                        end
                    end
                end
            end
        end
    end
    ---Stops the loop to execute the function
    ---@param func function
    ---@return nil
    function this:callFunction(func)
        self.parallelManager:stop()
        self._callFunction = func
    end
    ---Exit the uiManager Loop
    ---@return nil
    function this:exit()
        self.parallelManager:stop()
        self._exit = true
    end
    ---Start the uiManager loop
    function this:execute()
        while this._exit == false do
            this.parallelManager:init()
            if this._callFunction then
                this._callFunction()
                this._callFunction = nil
            end
        end
        this.exit = true
    end

    this.parallelManager:addFunction(this._execute)

    return this
end
