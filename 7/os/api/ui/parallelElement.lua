--TODO Check if necessary
local _parallelElement_metadata = {
    __call = function(self, ...)
        return self:init(...)
    end
}
ui.parallelElement = {}
---Create a new parallelElement
---@param caller parallelManager|nil
---@param func function
---@param data table
---@return parallelElement
function ui.parallelElement.new(caller, func, data)
    ---@class parallelElement
    local this = {}

    ---@type table
    this.data = data or {}
    ---@type parallelManager
    this.caller = caller --TODO not correct naming
    ---@type function
    this._func = func
    ---Call the given function
    ---@return nil
    function this.init()
        if this._func(this.data) == false then
            this.caller:removeFunction(this)
        end
    end
    setmetatable(this, _padding_metatable)
    return this
end
