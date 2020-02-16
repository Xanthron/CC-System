ui.element = {}
---Create a new element
---@param parent element
---@param x integer
---@param y integer
---@param w integer
---@param h integer
---@param T string
---@return element
function ui.element.new(parent, name, x, y, w, h)
    ---Base of every ui element
    ---@class element:class
    local this = class.new("element")
    if not name == false then
        this:_addType(name)
    end

    ---@type boolean
    this.isVisible = true
    ---@type "1"|"2"|"3"|"4"
    this.mode = 1
    ---@type buffer
    this.buffer = ui.buffer.new(x, y, w, h)
    ---@type element[]
    this._elements = {}
    ---@type element
    this._parent = nil
    ---@type padding
    this.maskPadding = nil

    ---@type selectElement
    this.select = {}

    ---Changes the visual appearance of an element by changing its mode and redraws it
    ---@param self element
    ---@return nil
    function this:changeMode(mode, overwriteDeselection)
        if mode > 0 and self.mode ~= mode and (overwriteDeselection or self.mode ~= 2) then
            self.mode = mode
            if not self._inAnimation then
                self:recalculate()
                self:repaint("this")
            end
        end
    end

    ---Set the parent of an element
    ---@param element element
    ---@param index index|optional
    ---@return boolean
    function this:setParent(element, index)
        if element == self then
            return false
        end
        if element and self:containsElement(element, true) then
            return false
        end
        if self._parent then
            for i = 1, #self._parent._elements do
                if self._parent._elements[i] == self then
                    table.remove(self._parent._elements, i)
                    break
                end
            end
        end
        self._parent = element
        if element then
            if index then
                table.insert(element._elements, index, self)
            else
                table.insert(element._elements, self)
            end
        else
            self._parent = nil
        end
        return true
    end
    ---Get the parent of this element
    ---@return element
    function this:getParent()
        return self._parent
    end

    ---Check if this has the given element. If checkChildren is true then the children get checked too.
    ---@param element element
    ---@param checkChildren boolean
    ---@return boolean
    function this:containsElement(element, checkChildren)
        for i = 1, #self._elements do
            if self._elements[i] == element then
                return true
            end
            if checkChildren == true and self._elements[i]:containsElement(element) then
                return true
            end
        end
        return false
    end
    ---Get the uiManager of this element
    ---@return uiManager
    function this:getManager()
        if self._parent then
            return self._parent:getManager()
        else
            return self
        end
    end
    ---Get the global unpacked rect
    ---@return integer, integer, integer, integer
    function this:getGlobalRect()
        return self.buffer.rect:getUnpacked()
    end
    ---Get the global x position
    ---@return integer
    function this:getGlobalPosX()
        return self.buffer.rect.x
    end
    ---Get the global y position
    ---@return integer
    function this:getGlobalPosY()
        return self.buffer.rect.y
    end
    ---Get the local unpacked rect
    ---@return integer, integer, integer, integer
    function this:getLocalRect()
        return self:getLocalPosX(), self:getLocalPosY(), self.buffer.rect.w, self.buffer.rect.h
    end
    ---Get the local x position
    ---@return integer
    function this:getLocalPosX()
        if self._parent then
            return self.buffer.rect.x - self._parent.buffer.rect.x + 1
        end
        return self.buffer.rect.x
    end
    ---Get the local y position
    ---@return integer
    function this:getLocalPosY()
        if self._parent then
            return self.buffer.rect.y - self._parent.buffer.rect.y + 1
        end
        return self.buffer.rect.y
    end
    ---Get the with
    ---@return integer
    function this:getWidth()
        return self.buffer.rect.w
    end
    ---Get the height
    ---@return integer
    function this:getHeight()
        return self.buffer.rect.h
    end
    ---Set the global rect
    ---@param x integer
    ---@param y integer
    ---@param w integer
    ---@param h integer
    ---@return nil
    function this:setGlobalRect(x, y, w, h)
        local newX, newY = self:getGlobalRect()
        self.buffer.rect:set(x, y, w, h)
        if x then
            x = x - newX
        end
        if y then
            y = y - newY
        end
        if x and y then
            for i = 1, #self._elements do
                self._elements[i]:setLocalRect(x, y, nil, nil)
            end
        end
    end
    ---Set the local rect
    ---@param x integer
    ---@param y integer
    ---@param w integer
    ---@param h integer
    ---@return nil
    function this:setLocalRect(x, y, w, h)
        if x == nil then
            x = 0
        end
        if y == nil then
            y = 0
        end
        self.buffer.rect:set(x + self:getGlobalPosX(), y + self:getGlobalPosY(), w, h)
        for i = 1, #self._elements do
            self._elements[i]:setLocalRect(x, y, nil, nil)
        end
    end
    ---Get the unpacked rect in consideration of all parent rects and paddings
    ---@param x integer|optional
    ---@param y integer|optional
    ---@param w integer|optional
    ---@param h integer|optional
    ---@return integer, integer, integer, integer
    function this:getCompleteMaskRect(x, y, w, h)
        local possible = true
        if self._parent then
            x, y, w, h, possible = self._parent:getCompleteMaskRect(x, y, w, h)
            if possible == false then
                return x, y, w, h, possible
            end
        end
        if self.maskPadding then
            if x then
                return ui.rect.overlaps(x, y, w, h, self.maskPadding:getPaddedRect(self.buffer.rect:getUnpacked()))
            else
                x, y, w, h = self.maskPadding:getPaddedRect(self.buffer.rect:getUnpacked())
                return x, y, w, h, true
            end
        else
            if x then
                return self.buffer.rect:getOverlaps(x, y, w, h)
            else
                x, y, w, h = self.buffer.rect:getUnpacked()
                return x, y, w, h, true
            end
        end
    end
    ---Get the unpacked rect in consideration of paddings
    ---@param x integer|optional
    ---@param y integer|optional
    ---@param w integer|optional
    ---@param h integer|optional
    ---@return integer, integer, integer, integer
    function this:getSimpleMaskRect(x, y, w, h)
        if self.maskPadding then
            if x then
                return ui.rect.overlaps(x, y, w, h, self.maskPadding:getPaddedRect(self.buffer.rect:getUnpacked()))
            else
                return self.maskPadding:getPaddedRect(self.buffer.rect:getUnpacked())
            end
        else
            if x then
                return self.buffer.rect:getOverlaps(x, y, w, h)
            else
                return self.buffer.rect:getUnpacked()
            end
        end
    end
    ---Intern function to draw this element in a buffer
    ---@param buffer buffer
    ---@param x integer|optional
    ---@param y integer|optional
    ---@param w integer|optional
    ---@param h integer|optional
    ---@return nil
    function this:doDraw(buffer, x, y, w, h)
        if x == nil then
            x, y, w, h = self.buffer.rect:getUnpacked()
        end
        if self.isVisible then
            buffer:contract(self.buffer, x, y, w, h)
            if self._elements == 0 then
                return
            end
            local possible = true
            x, y, w, h, possible = ui.rect.overlaps(x, y, w, h, self:getCompleteMaskRect())
            if possible then
                for i = 1, #self._elements do
                    self._elements[i]:doDraw(buffer, x, y, w, h)
                end
            end
        end
    end
    ---Repaint "this" = this element | "parent" = parent element and all children | "all" all elements
    ---@param mode "this"|"parent"|"all"
    ---@param x integer|optional
    ---@param y integer|optional
    ---@param w integer|optional
    ---@param h integer|optional
    ---@return nil
    function this:repaint(mode, x, y, w, h)
        if mode == "this" then
            if x and false then
                x = x + 1
                y = y + 1
                w = w - 2
                h = h - 2
            end
            x, y, w, h = self:getCompleteMaskRect(x, y, w, h)
            local manager = self:getManager()
            self:doDraw(manager.buffer, x, y, w, h)
            manager.buffer:draw(x, y, w, h)
        elseif mode == "parent" then
            if self._parent then
                self._parent:repaint("this", x, y, w, h)
            end
        elseif mode == "all" then
            self:getManager():repaint("this", x, y, w, h)
        else
            error("given mode (" .. mode .. ") is not supported", 2)
        end
    end
    ---Intern function for events dedicated to the mouse
    ---@param event event
    ---@param x integer|optional
    ---@param y integer|optional
    ---@param w integer|optional
    ---@param h integer|optional
    ---@return element|nil
    function this:doPointerEvent(event, x, y, w, h)
        local maskX, maskY, maskW, maskH, possible = self:getSimpleMaskRect(x, y, w, h)
        if possible then
            for i = #self._elements, 1, -1 do
                local element = self._elements[i]:doPointerEvent(event, maskX, maskY, maskW, maskH)
                if element then
                    return element
                end
            end
        end
        if self.mode ~= 2 then
            return self:_doPointerEvent(event, x, y, w, h)
        end
    end
    ---Intern function for every event except events dedicated to the mouse
    ---@param event event
    ---@return element|nil
    function this:doNormalEvent(event)
        for i = #self._elements, 1, -1 do
            local element = self._elements[i]:doNormalEvent(event)
            if element then
                return element
            end
        end
        if self.mode ~= 2 then
            return self:_doNormalEvent(event)
        end
    end
    ---Assigned function for every event dedicated to the mouse
    ---@param event event
    ---@param x integer|optional
    ---@param y integer|optional
    ---@param w integer|optional
    ---@param h integer|optional
    ---@return element|nil
    function this:_doPointerEvent(event, x, y, w, h)
        return nil
    end
    ---Assigned function for every event except events dedicated to the mouse
    ---@param event event
    ---@return element|nil
    function this:_doNormalEvent(event)
        return nil
    end
    ---Recalculate the buffer of this element
    ---@return nil
    function this:recalculate()
    end

    this:setParent(parent)

    return this
end
