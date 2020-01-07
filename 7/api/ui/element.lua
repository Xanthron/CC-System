function new(parent, x, y, w, h)
    local this = {}
    this.isVisible = true
    this.mode = 1
    this.buffer = ui.buffer.new(x, y, w, h)
    this._elements = {}
    this._parent = nil
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
    this.getParent = function()
        return this._parent
    end
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
    this.getManager = function()
        if this._parent then
            return this._parent.getManager()
        else
            return this
        end
    end
    this.setParent(parent)
    this.getGlobalRect = function()
        return this.buffer.rect.getUnpacked()
    end
    this.getGlobalPosX = function()
        return this.buffer.rect.x
    end
    this.getGlobalPosY = function()
        return this.buffer.rect.y
    end
    this.getLocalRect = function()
        return this.getLocalPosX(), this.getLocalPosY(), this.buffer.rect.w, this.buffer.rect.h
    end
    this.getLocalPosX = function()
        if this._parent then
            return this.buffer.rect.x - this._parent.buffer.rect.x + 1
        end
        return this.buffer.rect.x
    end
    this.getLocalPosY = function()
        if this._parent then
            return this.buffer.rect.y - this._parent.buffer.rect.y + 1
        end
        return this.buffer.rect.y
    end
    this.getWidth = function()
        return this.buffer.rect.w
    end
    this.getHeight = function()
        return this.buffer.rect.h
    end
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
    this.maskPadding = nil
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
    this.doDraw = function(buffer, x, y, w, h)
        if x == nil then
            x, y, w, h = this.buffer.rect.getUnpacked()
        end
        if this.isVisible then
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
    end
    this.repaint = function(mode, x, y, w, h)
        if mode == "this" then
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
        if this.mode ~= 2 then
            return this._doPointerEvent(event, x, y, w, h)
        end
    end
    this.doNormalEvent = function(event)
        for i = #this._elements, 1, -1 do
            local element = this._elements[i].doNormalEvent(event)
            if element then
                return element
            end
        end
        if this.mode ~= 2 then
            return this._doNormalEvent(event)
        end
    end
    this._doPointerEvent = function(event, x, y, w, h)
        return nil
    end
    this._doNormalEvent = function(event)
        return false
    end
    this.recalculate = function()
    end
    return this
end
