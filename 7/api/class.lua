function new(class)
    ---@class class
    local this = {}

    this.hasClass = true
    ---@type string[]
    ---@private
    this._classes = {}

    function this:isClass(class)
        if class.isClass == true then
            class = class:getName()
        end
        if type(class) == "string" then
            for i = 1, #self._classes do
                if self._classes[i] == class then
                    return true
                end
            end
        else
            error("object or string expected to compare class to object", 2)
        end
        return false
    end

    function this:isType(class)
        if class.isClass == true then
            return self:getName() == class:getName()
        elseif type(class) == "string" then
            return self:getName() == class
        else
            error("object or string expected to compare class to object", 2)
        end
        return false
    end

    ---@protected
    function this:_addType(class)
        table.insert(self._classes, class)
    end

    ---Get the name of the class
    ---@return string
    function this:getName()
        return self._classes[#self._classes]
    end

    this:_addType(class)

    return this
end
