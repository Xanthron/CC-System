---@return uiManager
function new(x, y, w, h)
    ---@class uiManager:element
    local this = ui.element.new(nil, x, y, w, h)

    ---Puts the Cursor at the dedicated position, after every execution the ui. Blinking can be turned on.
    ---@type function
    ---@return bool, integer, integer
    this.getCursorPos = nil

    ---@type parallelManager
    this.parallelManager = ui.parallelManager.new()

    ---@type selectionManager
    this.selectionManager = ui.selectionManager.new()

    this._needsRedraw = false
    this.draw = function()
        local x, y, w, h = this.getSimpleMaskRect()
        this.doDraw(this.buffer, x, y, w, h)
        this.buffer.draw(x, y, w, h)
    end

    ---@type event
    this._event = ui.event.new()

    this._execute = function()
        while true do
            this._event.pull()
            local eventName = this._event.name
            if
                eventName == "mouse_click" or eventName == "mouse_up" or eventName == "mouse_drag" or
                    eventName == "monitor_touch"
             then
                local element = this.doPointerEvent(this._event, this.getSimpleMaskRect())
                this.selectionManager.mouseEvent(this._event, element)
            else
                if not this.doNormalEvent(this._event) then
                    if eventName == "key" or eventName == "key_up" then
                        this.selectionManager.keyEvent(this._event)
                    end
                end
            end
            if this.getCursorPos then
                local blinking, posX, posY = this.getCursorPos()
                if blinking == nil then
                    this.getCursorPos = nil
                    term.setCursorBlink(false)
                else
                    term.setCursorPos(posX, posY)
                    term.setCursorBlink(blinking)
                end
            end
        end
    end
    this.parallelManager.addFunction(this._execute)
    this.execute = function()
        while true do
            this.parallelManager.init()
        end
    end

    return this
end
