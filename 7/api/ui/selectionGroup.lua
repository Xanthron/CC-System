---@param previous selectionGroup
---@param next selectionGroup
---@param listener function
---@return selectionGroup
function new(previous, next, listener)
    --- Manage the selection of multiple elements and calls a listener function if something changes.
    ---@class selectionGroup
    local this = {previous = previous, next = next, listener = listener}

    ---@type selectionElement
    this.currentSelectionElement = nil
    ---@type selectionElement[]
    this.selectionElements = {}

    --- Create a new `selectionElement` and add it to the group.
    ---@param element element
    ---@param left selectionElement
    ---@param up selectionElement
    ---@param right selectionElement
    ---@param down selectionElement
    ---@return selectionElement
    this.addNewSelectionElement = function(element, left, up, right, down)
        local selectionElement = ui.selectionElement.new(element, left, up, right, down)
        table.insert(this.selectionElements, selectionElement)
        return selectionElement
    end

    --- Add an existing `selectionElement` to the group
    ---@param selectionElement selectionElement
    this.addSelectionElement = function(selectionElement)
        table.insert(this.selectionElements, selectionElement)
    end

    ---@param selectionElement selectionElement
    this.removeSelectionElement = function(selectionElement)
        for index, value in ipairs(this.selectionElements) do
            if value == selectionElement then
                table.remove(this.selectionElements, index)
                return
            end
        end
    end

    ---@param selectionElement selectionElement
    this.containsSelectionElement = function(selectionElement)
        for index, value in ipairs(this.selectionElements) do
            if value == selectionElement then
                return true
            end
        end
        return false
    end

    ---@param element element
    ---@return boolean, element
    this.manageElement = function(element)
        for index, value in ipairs(this.selectionElements) do
            if value.element == element then
                return true, value
            end
        end
        return false, nil
    end

    return this
end
