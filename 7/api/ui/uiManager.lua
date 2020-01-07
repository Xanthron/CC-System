function new(x, y, w, h)
    local this = ui.element.new(nil, x, y, w, h)
    this.getCursorPos = nil
    this.parallelManager = ui.parallelManager.new()
    this.selectionManager = ui.selectionManager.new()
    this._needsRedraw = false
    this.draw = function()
        local x, y, w, h = this.getSimpleMaskRect()
        this.doDraw(this.buffer, x, y, w, h)
        this.buffer.draw(x, y, w, h)
    end
    this._event = ui.event.new()
    this._execute = function()
        while true do
            this._event.pull()
            term.setCursorBlink(false)
            local eventName = this._event.name
            if eventName == "mouse_click" or eventName == "mouse_up" or eventName == "mouse_drag" or eventName == "monitor_touch" then
                local element = this.doPointerEvent(this._event, this.getSimpleMaskRect())
                if #this.selectionManager.selectionGroups > 0 then
                    this.selectionManager.mouseEvent(this._event, element)
                end
            else
                if not this.doNormalEvent(this._event) then
                    if eventName == "key" or eventName == "key_up" then
                        if #this.selectionManager.selectionGroups > 0 then
                            this.selectionManager.keyEvent(this._event)
                        end
                    end
                end
            end
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
        end
    end
    this.parallelManager.addFunction(this._execute)
    this.callFunction = function(func)
        this.parallelManager.stop()
        this._callFunction = func
    end
    this._callFunction = nil
    this.exit = function()
        this.parallelManager.stop()
        this._exit = true
    end
    this._exit = false
    this.execute = function()
        while this._exit == false do
            this.parallelManager.init()
            if this._callFunction then
                this._callFunction()
                this._callFunction = nil
            end
        end
        this.exit = false
    end
    return this
end
