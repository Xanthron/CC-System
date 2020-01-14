function new(previous, next, listener)
    ---@class selectionGroup:class
    local this = class.new("selectionGroup")

    ---@type selectionGroup
    this.previous, this.next = previous, next
    ---@type element[]
    this.elements = {}
    ---@type element[]
    this.current = nil

    this.listener = listener

    function this:hasElement(element)
        for i = 1, #self.elements do
            if self.elements[i] == element then
                return true
            end
        end
        return false
    end

    function this:addElement(element, left, up, right, down, reverse)
        element.select.left = left
        element.select.up = up
        element.select.right = right
        element.select.down = down
        table.insert(self.elements, element)
        if reverse then
            for i, v in pairs(self.elements) do
                if v == left then
                    v.select.right = element
                elseif v == up then
                    v.select.down = element
                elseif v == right then
                    v.select.left = element
                elseif v == down then
                    v.select.up = element
                end
            end
        end
    end

    function this:removeElement(element, reference)
        for i, v in ipairs(self.elements) do
            if v == element then
                table.remove(self.elements, i)
                if not reference then
                    return
                end
            end
            if reference then
                for k, v2 in pairs(v.select) do
                    if v2 == element then
                        v.select[k] = nil
                    end
                end
            end
        end
    end

    function this:callListener(name, source, ...)
        if not self.listener or self:listener(name, source, ...) ~= false then
            return true
        end
        return false
    end

    return this
end
