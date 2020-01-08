local _parallelElement_metadata = {
    __call = function(self, ...)
        return self.init()
    end
}
---Create a new parallelElement
---@param caller parallelManager|nil
---@param func function
---@param data table
---@return parallelElement
function new(caller, func, data)
    ---@class parallelElement
    local this = {}
    this.data = data or {}
    this.caller = caller --TODO not correct naming
    this._func = func
    ---Call the given function
    return nil
    function this:init(self)
        if self._func(self.data) == false then
            self.caller:removeFunction(self)
        end
    end
    setmetatable(this, _padding_metatable)
    return this
end
