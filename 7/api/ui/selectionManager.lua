function new()
    ---@class selectionManager:class
    local this = class.new("selectionManager")

    ---@type selectionGroup[]
    this.groups = {}
    ---@type selectionGroup
    this.current = nil
    ---@type repeatItem
    this.repeatItem = ui.repeatItem.new(0.8, 0.1, 0.8)

    ---Select a group by passing it or any element of it. If wanted the element gets selected. --TODO add to listener description (Any current value gets set)
    ---@param var1 element|selectionGroup
    ---@param mode "0"|"1"|"3"
    ---@param source string
    ---@return nil
    function this:select(var1, source, mode)
        local newElement = var1.current
        ---@type element
        local currentElement
        if var1:isClass("element") then
            ---@type selectionGroup
            local newGroup
            for i = 1, #self.groups do
                local group = self.groups[i]
                if group:hasElement(var1) then
                    newGroup = group
                    break
                end
            end
            if newGroup and newGroup == self.current and newGroup.current ~= var1 then
                if newGroup:callListener("selection_change", source, newGroup.current, var1) then
                    newGroup.current:changeMode(1)
                    newGroup.current = var1
                    newGroup.current:changeMode(mode)
                end
                return
            else
                newElement = var1
                var1 = newGroup
            end
        end
        if self.current == var1 then
            local current = var1.current
            if var1:callListener("selection_reselect", source, current) then
                current:changeMode(mode)
            end
        else
            if self.current then
                currentElement = self.current.current
            end
            if (not self.current or self.current:callListener("selection_lose_focus", source, currentElement, newElement)) and var1:callListener("selection_get_focus", source, currentElement, newElement) then
                if currentElement then
                    currentElement:changeMode(1)
                end
                self.current = var1
                self.current.current = newElement
                newElement:changeMode(mode)
            end
        end
    end

    ---Deselects the current selected element
    ---@param source string
    ---@return nil
    function this:deselect(source)
        if self.current:callListener("selection_lose_focus", source, self.current.current) then
            self.current.current:changeMode(1)
        end
    end

    ---Handles key events
    ---@param event event
    ---@return nil
    function this:keyEvent(event)
        if event.name == "key" then
            if not self.current or not self.current:callListener("key", "key", event.param1, event.param2) or self.repeatItem:call() == false then
                return
            end

            local currentGroup = self.current
            local currentElement = self.current.current
            if currentElement then
                if currentElement.mode > 1 then
                    ---@type string
                    local direction
                    if event.param1 == 15 or event.param1 == 18 then
                        if currentGroup.next then
                            self:select(currentGroup.next, "key", 3)
                        end
                        return
                    elseif event.param1 == 16 then
                        if currentGroup.previous then
                            self:select(currentGroup.previous, "key", 3)
                        end
                        return
                    elseif event.param1 == 203 or event.param1 == 30 then
                        direction = "left"
                    elseif event.param1 == 200 or event.param1 == 17 then
                        direction = "up"
                    elseif event.param1 == 205 or event.param1 == 32 then
                        direction = "right"
                    elseif event.param1 == 208 or event.param1 == 31 then
                        direction = "down"
                    end
                    if direction then
                        ---@type element|selectionGroup
                        local newElement = currentElement.select[direction]
                        if newElement and newElement:isType("selectionGroup") then
                            newElement = newElement.current
                        end
                        while newElement and newElement.mode == 2 do
                            newElement = newElement.select[direction]
                            if newElement and newElement:isType("selectionGroup") then
                                newElement = newElement.current
                            end
                        end
                        if newElement then
                            if newElement:isType("selectionGroup") or not currentGroup:hasElement(newElement) then
                                self:select(newElement, "key", 3)
                            elseif currentGroup:callListener("selection_change", "key", currentElement, newElement) then
                                currentElement:changeMode(1)
                                currentGroup.current = newElement
                                newElement:changeMode(3)
                            end
                        end
                    end
                else
                    if currentGroup:callListener("selection_reselect", "key", currentElement) then
                        currentGroup.current:changeMode(3)
                    end
                end
            else
                if event.param1 == 15 or event.param1 == 18 then
                    if currentGroup.next then
                        self:select(currentGroup.next, "key", 3)
                    end
                elseif event.param1 == 16 then
                    if currentGroup.previous then
                        self:select(currentGroup.previous, "key", 3)
                    end
                end
            end
        elseif event.name == "key_up" then
            self.repeatItem:reset()
            if self.current then
                self.current:callListener("key_up", "key", event.param1)
            end
        end
    end
    ---Handles mouse events
    ---@param event event
    ---@param element element
    ---@return nil
    function this:mouseEvent(event, element)
        if not self.current or not self.current:callListener("mouse", "mouse", event) or event.name ~= "mouse_click" then
            return
        end
        if element then
            self:select(element, "mouse", 0)
        else
            self:deselect("mouse")
        end
    end

    ---Add a selectionGroup to this container
    ---@param group selectionGroup
    ---@return nil
    function this:addGroup(group)
        table.insert(self.groups, group)
    end
    ---Create and add a new selectionGroup to this container
    ---@param previous selectionGroup|optional
    ---@param next selectionGroup|optional
    ---@param listener function|optional
    ---@return selectionGroup
    function this:addNewGroup(previous, next, listener)
        local group = ui.selectionGroup.new(previous, next, listener)
        table.insert(self.groups, group)
        return group
    end
    ---Remove a selectionGroup
    ---@param group selectionGroup
    ---@return nil
    function this:removeGroup(group)
        for i, v in ipairs(self.groups) do
            if v == group then
                self.current = group.previous or group.next
                table.remove(self.groups, i)
                return
            end
        end
    end

    return this
end
