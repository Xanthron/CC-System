function new(previous, next, listener)
    local this = {previous = previous, next = next, listener = listener}
    this.currentSelectionElement = nil
    this.selectionElements = {}
    this.addNewSelectionElement = function(element, left, up, right, down)
        local selectionElement = ui.selectionElement.new(element, left, up, right, down)
        table.insert(this.selectionElements, selectionElement)
        return selectionElement
    end
    this.addSelectionElement = function(selectionElement)
        table.insert(this.selectionElements, selectionElement)
    end
    this.removeSelectionElement = function(selectionElement)
        for index, value in ipairs(this.selectionElements) do
            if value == selectionElement then
                table.remove(this.selectionElements, index)
                return
            end
        end
    end
    this.containsSelectionElement = function(selectionElement)
        for index, value in ipairs(this.selectionElements) do
            if value == selectionElement then
                return true
            end
        end
        return false
    end
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
