_padding_metatable = {__newindex = function(self, key, value)
        error("Please use the given functions to edit Values", 2)
    end, __tostring = function(self)
        return "(" .. self.left .. ", " .. self.top .. ", " .. self.right .. ", " .. self.bottom .. ")"
    end, __eq = function(self, padding)
        return (self.left == padding.left and self.top == padding.top and self.right == padding.right and self.bottom == padding.bottom)
    end, __metatable = false}
function new(left, top, right, bottom)
    local this = {left = left or 0, top = top or 0, right = right or 0, bottom = bottom or 0}
    this.getUnpacked = function()
        return this.left, this.top, this.right, this.bottom
    end
    this.getPaddedRect = function(x, y, w, h)
        return x + this.left, y + this.top, w - this.right - this.left, h - this.bottom - this.top
    end
    this.set = function(left, top, right, bottom)
        this.left = left or this.left
        this.top = top or this.top
        this.right = right or this.right
        this.bottom = bottom or this.bottom
    end
    setmetatable(this, _padding_metatable)
    return this
end
