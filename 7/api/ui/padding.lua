_padding_metatable = {
    __newindex = function(self, key, value)
        error("Please use the given functions to edit Values", 2)
    end,
    __tostring = function(self)
        return "(" .. self.left .. ", " .. self.top .. ", " .. self.right .. ", " .. self.bottom .. ")"
    end,
    __eq = function(self, padding)
        return (self.left == padding.left and self.top == padding.top and self.right == padding.right and self.bottom == padding.bottom)
    end,
    __metatable = false
}

--- Create a new padding.
---@return padding
function new(left, top, right, bottom)
    ---@class padding
    local this = {left = left or 0, top = top or 0, right = right or 0, bottom = bottom or 0}

    --- Get the four values in order of *left*, *top*, *right*, *bottom* as `integer`.
    ---@return integer, integer, integer, integer
    this.getUnpacked = function()
        return this.left, this.top, this.right, this.bottom
    end

    --- Applies the padding on a `rect` and returns it as four `integer`.
    ---@param x integer
    ---@param y integer
    ---@param w integer
    ---@param h integer
    ---@return integer, integer, integer, integer
    this.getPaddedRect = function(x, y, w, h)
        return x + this.left, y + this.top, w - this.right - this.left, h - this.bottom - this.top
    end

    --- Sets the values new.
    ---@param left integer
    ---@param top integer
    ---@param right integer
    ---@param bottom integer
    this.set = function(left, top, right, bottom)
        this.left = left or this.left
        this.top = top or this.top
        this.right = right or this.right
        this.bottom = bottom or this.bottom
    end

    setmetatable(this, _padding_metatable)

    return this
end
