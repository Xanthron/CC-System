--TODO Better Metadata
local _parallelElement_metadata = {
    __call = function(self, ...)
        return self.init()
    end
}

--- Create a new `parallelElement`
---@param caller parallelManager
---@param func function
---@param data table
---@return parallelElement
function new(caller, func, data)
    --- A class to store additional data for a `function` that should occur parallel
    ---@class parallelElement
    local this = {}

    this.data = data or {}
    this.caller = caller
    this._func = func
    --- Init the stored function. The stored data is given as argument.
    this.init = function()
        if this._func(this.data) == false then
            this.caller.removeFunction(this)
        end
    end

    setmetatable(this, _padding_metatable)

    return this
end
