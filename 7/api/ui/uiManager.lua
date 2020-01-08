---Create a new uiManager
function new(x, y, w, h)
    ---Base Manager to handel drawing end events
    ---@class uiManager:element
    local this = ui.element.new(nil, x, y, w, h)
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
    function this:_execute()
        while true do
            self._event:pull()
            term.setCursorBlink(false)
            local eventName = self._event.name
            if
                eventName == "mouse_click" or eventName == "mouse_up" or eventName == "mouse_drag" or
                    eventName == "monitor_touch"
             then
                local element = self:doPointerEvent(self._event, self:getSimpleMaskRect())
                if #self.selectionManager.selectionGroups > 0 then
                    self.selectionManager:mouseEvent(self._event, element)
                end
            else
                if not self:doNormalEvent(self._event) then
                    if eventName == "key" or eventName == "key_up" then
                        if #self.selectionManager.selectionGroups > 0 then
                            self.selectionManager:keyEvent(self._event)
                        end
                    end
                end
            end
            if self.getCursorPos then
                local blinking, posX, posY, textColor = self.getCursorPos()
                if blinking == nil then
                    self.getCursorPos = nil
                else
                    term.setCursorPos(posX, posY)
                    term.setCursorBlink(blinking)
                    if textColor and term.isColor() then
                        term.setTextColor(textColor)
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
    function this:execute(self)
        while self._exit == false do
            self.parallelManager:init()
            if self._callFunction then
                self._callFunction()
                self._callFunction = nil
            end
        end
        self.exit = false
    end

    this.parallelManager:addFunction(this._execute)

    return this
end
