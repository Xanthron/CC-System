local _parallelElement_metadata = {__call = function(self, ...)
        return self.init()
    end}
function new(caller, func, data)
    local this = {}
    this.data = data or {}
    this.caller = caller
    this._func = func
    this.init = function()
        if this._func(this.data) == false then
            this.caller.removeFunction(this)
        end
    end
    setmetatable(this, _padding_metatable)
    return this
end
