---@return uiManager
function new(x, y, w, h)
    ---@class uiManager:element
    local this = ui.element.new(nil, x, y, w, h)

    ui.buffer.fillWithColor(this.buffer, " ", colors.black, colors.white)

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
