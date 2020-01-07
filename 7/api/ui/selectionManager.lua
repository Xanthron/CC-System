function new()
    local this = {}
    this._currentSelectionGroup = nil
    this.setCurrentSelectionGroup = function(selectionGroup, source, ...)
        _switch(this, selectionGroup, source, ...)
    end
    this.getCurrentSelectionGroup = function()
        return this._currentSelectionGroup
    end
    this.selectionGroups = {}
    this.repeatItem = ui.repeatItem.new(0.8, 0.1, 0.8)
    this.addSelectionGroup = function(selectionGroup)
        table.insert(this.selectionGroups, selectionGroup)
    end
    this.addNewSelectionGroup = function(previous, next, listener)
        local selectionGroup = ui.selectionGroup.new(previous, next, listener)
        table.insert(this.selectionGroups, selectionGroup)
        return selectionGroup
    end
    this.removeSelectionGroup = function(selectionGroup)
        for index, value in ipairs(this.selectionGroups) do
            if value == selectionGroup then
                this._currentSelectionGroup = selectionGroup.previous or selectionGroup.next
                table.remove(this.selectionGroups, index)
                return
            end
        end
    end
    this.focusGroup = function(group)
    end
    this.keyEvent = function(event)
        if event.name == "key" then
            if this._currentSelectionGroup.listener and this._currentSelectionGroup.listener("key", "key", event.param1, event.param2) == false then
                return
            end
            if this.repeatItem.call() == false then
                return
            end
            if not this._currentSelectionGroup then
                return
            end
            local currentSelectionElement = this._currentSelectionGroup.currentSelectionElement
            local currentElement = nil
            if this._currentSelectionGroup.currentSelectionElement then
                currentElement = this._currentSelectionGroup.currentSelectionElement.element
            end
            if this._currentSelectionGroup.currentSelectionElement then
                currentElement = this._currentSelectionGroup.currentSelectionElement.element
            end
            if currentSelectionElement then
                if currentElement.mode == 3 or currentElement.mode == 2 then
                    if event.param1 == 15 or event.param1 == 18 then
                        if this._currentSelectionGroup.next then
                            _switch(this, this._currentSelectionGroup.next, "key", event.param1)
                        end
                    elseif event.param1 == 16 then
                        if this._currentSelectionGroup.previous then
                            _switch(this, this._currentSelectionGroup.previous, "key", event.param1)
                        end
                    elseif event.param1 == 203 or event.param1 == 30 then
                        _select(this._currentSelectionGroup, "left", "key")
                    elseif event.param1 == 200 or event.param1 == 17 then
                        _select(this._currentSelectionGroup, "up", "key")
                    elseif event.param1 == 205 or event.param1 == 32 then
                        _select(this._currentSelectionGroup, "right", "key")
                    elseif event.param1 == 208 or event.param1 == 31 then
                        _select(this._currentSelectionGroup, "down", "key")
                    end
                else
                    if not this._currentSelectionGroup.listener or this._currentSelectionGroup.listener("selection_reselect", "key", currentSelectionElement.element) ~= false then
                        currentSelectionElement.element.mode = 3
                        if not currentSelectionElement.element._inAnimation then
                            currentSelectionElement.element.recalculate()
                            currentSelectionElement.element.repaint("this")
                        end
                    end
                end
            else
                if event.param1 == 15 or event.param1 == 18 then
                    if this._currentSelectionGroup.next then
                        _switch(this, this._currentSelectionGroup.next, "key", event.param1)
                    end
                elseif event.param1 == 16 then
                    if this._currentSelectionGroup.previous then
                        _switch(this, this._currentSelectionGroup.previous, "key", event.param1)
                    end
                end
            end
        elseif event.name == "key_up" then
            this.repeatItem.reset()
            if this._currentSelectionGroup.listener then
                this._currentSelectionGroup.listener("key_up", "key", event.param1)
            end
        end
    end
    this.mouseEvent = function(event, element)
        if (this._currentSelectionGroup.listener and this._currentSelectionGroup.listener("mouse", "mouse", event) == false) or event.name ~= "mouse_click" then
            return
        end
        local currentElement = nil
        if this._currentSelectionGroup.currentSelectionElement then
            currentElement = this._currentSelectionGroup.currentSelectionElement.element
        end
        if element then
            for _, v in ipairs(this.selectionGroups) do
                local isManaging, managedSelectionElement = v.manageElement(element)
                if isManaging then
                    if v == this._currentSelectionGroup then
                        if currentElement == element then
                            return
                        end
                        if not v.listener or v.listener("selection_change", "mouse", currentElement, element) ~= false then
                            if currentElement and currentElement.mode == 3 then
                                currentElement.mode = 1
                                if not currentElement._inAnimation then
                                    currentElement.recalculate()
                                    currentElement.repaint("this")
                                end
                            end
                            v.currentSelectionElement = managedSelectionElement
                        end
                    elseif not this._currentSelectionGroup.listener or this._currentSelectionGroup.listener("selection_lose_focus", "mouse", currentElement, element) ~= false then
                        if currentElement and currentElement.mode == 3 then
                            currentElement.mode = 1
                            if not currentElement._inAnimation then
                                currentElement.recalculate()
                                currentElement.repaint("this")
                            end
                        end
                        if v.listener then
                            v.listener("selection_get_focus", "mouse", currentElement, element)
                        end
                        this._currentSelectionGroup = v
                        if v.currentSelectionElement then
                            currentElement = v.currentSelectionElement.element
                        end
                        if currentElement == element then
                            return
                        end
                        if not v.listener or v.listener("selection_change", "mouse", currentElement, element) ~= false then
                            if currentElement and currentElement.mode == 3 then
                                currentElement.mode = 1
                                if not currentElement._inAnimation then
                                    currentElement.recalculate()
                                    currentElement.repaint("this")
                                end
                            end
                            v.currentSelectionElement = managedSelectionElement
                        end
                    end
                    return
                end
            end
        elseif this._currentSelectionGroup.currentSelectionElement and this._currentSelectionGroup.currentSelectionElement.element.mode == 3 then
            local currentElement = this._currentSelectionGroup.currentSelectionElement.element
            if not this._currentSelectionGroup.listener or this._currentSelectionGroup.listener("selection_lose_focus_mouse", currentElement, nil) ~= false then
                currentElement.mode = 1
                if not currentElement._inAnimation then
                    currentElement.recalculate()
                    currentElement.repaint("this")
                end
            end
        end
    end
    this.select = function(element, source)
        local currentElement = nil
        if this._currentSelectionGroup.currentSelectionElement then
            currentElement = this._currentSelectionGroup.currentSelectionElement.element
        end
        for _, v in ipairs(this.selectionGroups) do
            local isManaging, managedSelectionElement = v.manageElement(element)
            if isManaging then
                if v == this._currentSelectionGroup then
                    if currentElement == element then
                        if not v.listener or v.listener("selection_reselect", source or "code", currentElement, element) ~= false then
                            if element.mode == 1 then
                                element.mode = 3
                                if not element._inAnimation then
                                    element.recalculate()
                                    element.repaint("this")
                                end
                            end
                        end
                    elseif not v.listener or v.listener("selection_change", source or "code", currentElement, element) ~= false then
                        if currentElement and currentElement.mode == 3 then
                            currentElement.mode = 1
                            if not currentElement._inAnimation then
                                currentElement.recalculate()
                                currentElement.repaint("this")
                            end
                        end
                        v.currentSelectionElement = managedSelectionElement
                        if not v.listener or v.listener("selection_change", source or "code", currentElement, element) ~= false then
                            if element.mode == 1 then
                                element.mode = 3
                                if not element._inAnimation then
                                    element.recalculate()
                                    element.repaint("this")
                                end
                            end
                        end
                    end
                elseif not this._currentSelectionGroup.listener or this._currentSelectionGroup.listener("selection_lose_focus", source or "code", currentElement, element) ~= false then
                    if currentElement and currentElement.mode == 3 then
                        currentElement.mode = 1
                        if not currentElement._inAnimation then
                            currentElement.recalculate()
                            currentElement.repaint("this")
                        end
                    end
                    if v.listener then
                        v.listener("selection_get_focus", source or "code", currentElement, element)
                    end
                    this._currentSelectionGroup = v
                    if v.currentSelectionElement then
                        currentElement = v.currentSelectionElement.element
                    end
                    if currentElement == element then
                        if element.mode == 1 then
                            if not v.listener or v.listener("selection_reselect", source or "code", element) ~= false then
                                element.mode = 3
                                if not element._inAnimation then
                                    currentElement.recalculate()
                                    currentElement.repaint("this")
                                end
                            end
                        end
                    elseif not v.listener or v.listener("selection_change", source or "code", currentElement, element) ~= false then
                        if currentElement and currentElement.mode == 3 then
                            currentElement.mode = 1
                            if not currentElement._inAnimation then
                                currentElement.recalculate()
                                currentElement.repaint("this")
                            end
                        end
                        v.currentSelectionElement = managedSelectionElement
                        if element.mode == 1 then
                            element.mode = 3
                            if not element._inAnimation then
                                element.recalculate()
                                element.repaint("this")
                            end
                        end
                    end
                end
                return
            end
        end
    end
    return this
end
function _select(selectionGroup, direction, source)
    local currentSelectionElement = selectionGroup.currentSelectionElement
    local newSelection = currentSelectionElement[direction]
    while newSelection and newSelection.element.mode == 2 do
        newSelection = newSelection[direction]
    end
    if newSelection then
        if not selectionGroup.listener or selectionGroup.listener("selection_change", source, currentSelectionElement.element, newSelection.element) ~= false then
            if currentSelectionElement.element.mode > 2 then
                currentSelectionElement.element.mode = 1
                if not currentSelectionElement.element._inAnimation then
                    currentSelectionElement.element.recalculate()
                    currentSelectionElement.element.repaint("this")
                end
            end
            newSelection.element.mode = 3
            if not newSelection.element._inAnimation then
                newSelection.element.recalculate()
                newSelection.element.repaint("this")
            end
        end
        selectionGroup.currentSelectionElement = newSelection
    end
end
function _switch(selectionManager, selectionGroup, source, ...)
    if selectionManager._currentSelectionGroup == selectionGroup or selectionGroup == nil then
        return
    end
    local currentElement = nil
    if selectionManager._currentSelectionGroup and selectionManager._currentSelectionGroup.currentSelectionElement then
        currentElement = selectionManager._currentSelectionGroup.currentSelectionElement.element
    end
    local newElement = nil
    if selectionGroup.currentSelectionElement then
        newElement = selectionGroup.currentSelectionElement.element
    end
    if selectionManager._currentSelectionGroup and (not selectionManager._currentSelectionGroup.listener or selectionManager._currentSelectionGroup.listener("selection_lose_focus", source, currentElement, newElement, ...) ~= false) then
        if currentElement and currentElement.mode > 2 then
            currentElement.mode = 1
            if not currentElement._inAnimation then
                currentElement.recalculate()
                currentElement.repaint("this")
            end
        end
    end
    if not selectionGroup.listener or selectionGroup.listener("selection_get_focus", source, currentElement, newElement, ...) ~= false then
        if newElement and (newElement.mode == 1 or newElement.mode == 4) then
            newElement.mode = 3
            if not newElement._inAnimation then
                newElement.recalculate()
                newElement.repaint("this")
            end
        end
    end
    selectionManager._currentSelectionGroup = selectionGroup
end
