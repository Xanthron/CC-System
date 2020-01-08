_padding_metatable = {
    __newindex = function(self, key, value)
        error("Please use the given functions to edit Values", 2)
    end,
    __tostring = function(self)
        return "(" .. self.left .. ", " .. self.top .. ", " .. self.right .. ", " .. self.bottom .. ")"
    end,
    __eq = function(self, padding)
        return (self.left == padding.left and self.top == padding.top and self.right == padding.right and
            self.bottom == padding.bottom)
    end,
    __metatable = false
}
---Create a new padding
---@return padding
function new(left, top, right, bottom)
    ---@class padding
    local this = {left = left or 0, top = top or 0, right = right or 0, bottom = bottom or 0}
    ---Get unpacked padding
    ---@return integer, integer, integer, integer
    function this:getUnpacked()
        return self.left, self.top, self.right, self.bottom
    end
    ---Get rect with applied padding
    ---@param x integer
    ---@param y integer
    ---@param w integer
    ---@param h integer
    ---@return integer, integer, integer, integer
    function this:getPaddedRect(x, y, w, h)
        return x + self.left, y + self.top, w - self.right - self.left, h - self.bottom - self.top
    end
    ---Sets the padding
    ---@param left integer|optional
    ---@param top integer|optional
    ---@param right integer|optional
    ---@param bottom integer|optional
    function this:set(left, top, right, bottom)
        self.left = left or self.left
        self.top = top or self.top
        self.right = right or self.right
        self.bottom = bottom or self.bottom
    end
    setmetatable(this, _padding_metatable)
    return this
end
