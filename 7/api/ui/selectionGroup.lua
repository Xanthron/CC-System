function new(previous, next, listener)
    ---Container of selectionElements
    ---@class selectionGroup
    local this = {previous = previous, next = next, listener = listener}
    this.currentSelectionElement = nil
    this.selectionElements = {}
    ---Create and add a new selectionElement to this container
    ---@param element element
    ---@param left selectionElement|optional
    ---@param up selectionElement|optional
    ---@param right selectionElement|optional
    ---@param down selectionElement|optional
    ---@return selectionElement
    function this:addNewSelectionElement(element, left, up, right, down)
        local selectionElement = ui.selectionElement.new(element, left, up, right, down)
        table.insert(self.selectionElements, selectionElement)
        return selectionElement
    end
    ---Add a selectionElement to this container
    ---@param selectionElement selectionElement
    ---@return nil
    function this:addSelectionElement(selectionElement)
        table.insert(self.selectionElements, selectionElement)
    end
    ---Remove a selectionElement
    ---@param selectionElement selectionElement
    ---@return nil
    function this:removeSelectionElement(selectionElement)
        for index, value in ipairs(self.selectionElements) do
            if value == selectionElement then
                table.remove(self.selectionElements, index)
                return
            end
        end
    end
    ---Check if this has a selectionElement --TODO rename to hasSelectionElement
    ---@param selectionElement selectionElement
    ---@return boolean
    function this:containsSelectionElement(selectionElement)
        for index, value in ipairs(self.selectionElements) do
            if value == selectionElement then
                return true
            end
        end
        return false
    end
    ---Check if it manages an element and returns it if true
    ---@param element element
    ---@return boolean, element
    function this:manageElement(element)
        for index, value in ipairs(self.selectionElements) do
            if value.element == element then
                return true, value
            end
        end
        return false, nil
    end
    return this
end
