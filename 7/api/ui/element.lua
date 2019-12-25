---
--- Create a new ui element
---@param parent element
---@param x integer
---@param y integer
---@param w integer
---@param h integer
---@param buffer buffer
---@return element
function new(parent, x, y, w, h)
    ---
    --- The base class of every ui element
    ---@class element
    local this = {}

    --TODO make hiding work
    this.isVisible = true
    this.mode = 1

    ---@type buffer
    this.buffer = ui.buffer.new(x, y, w, h)

    ---@type element[]
    this._elements = {}
    ---@type element
    this._parent = nil
    ---
    --- Set the given `element` as the parent of `this`. If it succeed it will return true. If the element is `this`, or `this` contains the element, then it will return false. The old parent, if exist, will be updated.
    ---@param element element | nil
    ---@param index integer | nil
    ---@return boolean
    this.setParent = function(element, index)
        if element == this then
            return false
        end
        if element and this.containsElement(element, true) then
            return false
        end
        if this._parent then
            for i = 1, #this._parent._elements do
                if this._parent._elements[i] == this then
                    table.remove(this._parent._elements, i)
                    break
                end
            end
        end
        this._parent = element
        if element then
            if index then
                table.insert(element._elements, index, this)
            else
                table.insert(element._elements, this)
            end
        else
            this._parent = nil
        end
        return true
    end
    ---
    --- Get the current `parent`.
    ---@return element
    this.getParent = function()
        return this._parent
    end
    ---
    --- Checks if `this` contains the `element`, if wanted the children get checked too. When the `element` is contained it will return true.
    ---@param element element
    ---@param checkChildren boolean
    ---@return boolean
    this.containsElement = function(element, checkChildren)
        for i = 1, #this._elements do
            if this._elements[i] == element then
                return true
            end
            if checkChildren == true and this._elements[i].containsElement(element) then
                return true
            end
        end
        return false
    end

    ---
    --- Get the `uiManager` that is responsible for handling this `element`.
    ---@return uiManager
    this.getManager = function()
        if this._parent then
            return this._parent.getManager()
        else
            return this
        end
    end

    this.setParent(parent)
    --endregion

    --- Get the *global* `rect` of this `element` split in to four `integer`.
    ---@return integer, integer, integer, integer
    this.getGlobalRect = function()
        return this.buffer.rect.getUnpacked()
    end
    --- Get the *global x position* of this `element`.
    ---@return integer
    this.getGlobalPosX = function()
        return this.buffer.rect.x
    end
    --- Get the *global y position* of this `element`.
    ---@return integer
    this.getGlobalPosY = function()
        return this.buffer.rect.y
    end

    --- Get the *local* `rect` of this `element` split in to four `integer`.
    ---@return integer, integer, integer, integer
    this.getLocalRect = function()
        return this.getLocalPosX(), this.getLocalPosY(), this.buffer.rect.w, this.buffer.rect.h
    end
    --- Get the *local x position* of this `element`.
    ---@return integer
    this.getLocalPosX = function()
        if this._parent then
            return this.buffer.rect.x - this._parent.buffer.rect.x + 1
        end
        return this.buffer.rect.x
    end
    --- Get the *local y position* of this `element`.
    ---@return integer
    this.getLocalPosY = function()
        if this._parent then
            return this.buffer.rect.y - this._parent.buffer.rect.y + 1
        end
        return this.buffer.rect.y
    end

    --- Get the *width* of this `element`.
    ---@return integer
    this.getWidth = function()
        return this.buffer.rect.w
    end
    --- Get the *width* of this `element`.
    ---@return integer
    this.getHeight = function()
        return this.buffer.rect.h
    end

    ---Set the *global* `rect` for this `element`. `nil` values will result in no change for the parameter.
    ---@param x integer
    ---@param y integer
    ---@param w integer
    ---@param h integer
    this.setGlobalRect = function(x, y, w, h)
        local newX, newY = this.getGlobalRect()
        this.buffer.rect.set(x, y, w, h)
        if x then
            x = x - newX
        end
        if y then
            y = y - newY
        end
        if x and y then
            for i = 1, #this._elements do
                this._elements[i].setLocalRect(x, y, nil, nil)
            end
        end
    end
    ---Set the *local* `rect` for this `element`. `nil` values will result in no change for the parameter.
    ---@param x integer
    ---@param y integer
    ---@param w integer
    ---@param h integer
    this.setLocalRect = function(x, y, w, h)
        if x == nil then
            x = 0
        end
        if y == nil then
            y = 0
        end
        this.buffer.rect.set(x + this.getGlobalPosX(), y + this.getGlobalPosY(), w, h)
        for i = 1, #this._elements do
            this._elements[i].setLocalRect(x, y, nil, nil)
        end
    end
    --endregion

    --region Mask
    ---@type padding
    this.maskPadding = nil --ui.padding(new(0,0,0,0))
    --- Get a `rect` mask as four `integer` of this and all parent `element`s with applied `padding`. If wanted overlapped with an additional `rect` mask.
    ---@param x integer
    ---@param y integer
    ---@param w integer
    ---@param h integer
    ---@return integer, integer, integer, integer, boolean
    this.getCompleteMaskRect = function(x, y, w, h, db)
        local possible = true
        if this._parent then
            x, y, w, h, possible = this._parent.getCompleteMaskRect(x, y, w, h, db)
            if possible == false then
                return x, y, w, h, possible
            end
        end
        if this.maskPadding then
            if x then
                return ui.rect.overlaps(x, y, w, h, this.maskPadding.getPaddedRect(this.buffer.rect.getUnpacked()))
            else
                x, y, w, h = this.maskPadding.getPaddedRect(this.buffer.rect.getUnpacked())
                return x, y, w, h, true
            end
        else
            if x then
                return this.buffer.rect.getOverlaps(x, y, w, h)
            else
                x, y, w, h = this.buffer.rect.getUnpacked()
                return x, y, w, h, true
            end
        end
    end

    ---
    --- Get a `rect` mask as four `integer` of this `element` with applied `padding`. If wanted overlapped with an additional `rect` mask.
    ---@param x integer
    ---@param y integer
    ---@param w integer
    ---@param h integer
    ---@return integer, integer, integer, integer, boolean
    this.getSimpleMaskRect = function(x, y, w, h)
        if this.maskPadding then
            if x then
                return ui.rect.overlaps(x, y, w, h, this.maskPadding.getPaddedRect(this.buffer.rect.getUnpacked()))
            else
                return this.maskPadding.getPaddedRect(this.buffer.rect.getUnpacked())
            end
        else
            if x then
                return this.buffer.rect.getOverlaps(x, y, w, h)
            else
                return this.buffer.rect.getUnpacked()
            end
        end
    end
    --endregion

    --region Draw and Input
    ---
    --- Draw this `element` and its children within in a `buffer`. If wanted only in a `rect` mask.
    ---@param buffer buffer
    ---@param mask mask
    this.doDraw = function(buffer, x, y, w, h)
        if x == nil then
            x, y, w, h = this.buffer.rect.getUnpacked()
        end
        buffer.contract(this.buffer, x, y, w, h)

        if this._elements == 0 then
            return
        end
        local possible = true
        x, y, w, h, possible = ui.rect.overlaps(x, y, w, h, this.getCompleteMaskRect())
        if possible then
            for i = 1, #this._elements do
                this._elements[i].doDraw(buffer, x, y, w, h)
            end
        end
    end

    ---
    --- Redraw the scene based on the mode in a mask: *this* = this and containing `element`s, *parent* = parent `element` and containing `element`s, *all* = all `elements`
    ---@param mode "'this'"|"'parent'"|"'all'"
    ---@param x integer
    ---@param y integer
    ---@param w integer
    ---@param h integer
    this.repaint = function(mode, x, y, w, h)
        if mode == "this" then
            --sleep(1)
            if x and false then
                x = x + 1
                y = y + 1
                w = w - 2
                h = h - 2
            end
            x, y, w, h = this.getCompleteMaskRect(x, y, w, h)
            local manager = this.getManager()
            this.doDraw(manager.buffer, x, y, w, h)
            manager.buffer.draw(x, y, w, h)
        elseif mode == "parent" then
            if this._parent then
                this._parent.repaint("this", x, y, w, h)
            end
        elseif mode == "all" then
            this.getManager().repaint("this", x, y, w, h)
        end
    end

    ---
    --- Handles all events in a `rect` mask that are *mouse_click*, *mouse_down*, *mouse_drag* for this and every `element` that it contains. Return the `element` if any is effected else it returns `nil`.
    ---@param event event
    ---@param mask rect
    this.doPointerEvent = function(event, x, y, w, h)
        local maskX, maskY, maskW, maskH, possible = this.getSimpleMaskRect(x, y, w, h)
        if possible then
            for i = #this._elements, 1, -1 do
                local element = this._elements[i].doPointerEvent(event, maskX, maskY, maskW, maskH)
                if element then
                    return element
                end
            end
        end
        return this._doPointerEvent(event, x, y, w, h)
    end

    ---
    --- Handles all events that are not *mouse_click*, *mouse_down*, *mouse_drag* for this and every `element` that it contains. Return the `element` if any is effected else it returns `nil`.
    ---@param event event
    ---@return element | nil
    this.doNormalEvent = function(event)
        for i = #this._elements, 1, -1 do
            local element = this._elements[i].doNormalEvent(event)
            if element then
                return element
            end
        end
        return this._doNormalEvent(event)
    end

    --- Intern function of an `element` handling all events in a `rect` mask that are *mouse_click*, *mouse_down*, *mouse_drag*. Return the `element` if it is effected else it returns `nil`.
    ---@param event event
    ---@return element | nil
    this._doPointerEvent = function(event, x, y, w, h)
        return nil
    end

    --- Intern function of an `element` handling all events that are not *mouse_click*, *mouse_down*, *mouse_drag*. Return the `element` if it is effected else it returns `nil`.
    ---@param event event
    ---@return element | nil
    this._doNormalEvent = function(event)
        return false
    end
    --endregion

    --- Recalculate its `buffer` data.
    this.recalculate = function()
    end

    return this
end
