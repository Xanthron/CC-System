_rect_metatable = {
    __newindex = function(self, key, value)
        error("Please use the given functions to edit Values", 2)
    end,
    __tostring = function(self)
        return "(" .. self.x .. ", " .. self.y .. ", " .. self.w .. ", " .. self.h .. ")"
    end,
    __eq = function(self, rect)
        return (self.x == rect.x and self.y == rect.y and self.w == rect.w and self.h == rect.h)
    end,
    __metatable = false
}
ui.rect = {}
---Create a new rect
---@param x integer
---@param y integer
---@param w integer
---@param h integer
---@return rect
function ui.rect.new(x, y, w, h)
    ---Contains x, y, w, h and math operations
    ---@class rect
    local this = {x = x or 0, y = y or 0, w = w or 0, h = h or 0}
    ---Unpack x, y, w, h
    ---@return integer, integer, integer, integer
    function this:getUnpacked()
        return self.x, self.y, self.w, self.h
    end
    ---Set x, y, w, h
    ---@param x integer|optional
    ---@param y integer|optional
    ---@param w integer|optional
    ---@param h integer|optional
    ---@return nil
    function this:set(x, y, w, h)
        self.x = x or self.x
        self.y = y or self.y
        self.w = w or self.w
        self.h = h or self.h
    end
    ---Get the unpacked overlaps of this and a given unpacked rect
    ---@param x integer
    ---@param y integer
    ---@param w integer
    ---@param h integer
    ---@return integer, integer, integer, integer
    function this:getOverlaps(x, y, w, h)
        return ui.rect.overlaps(x, y, w, h, self:getUnpacked())
    end
    ---Checks if the given x and y is in this rect
    ---@param x integer
    ---@param y integer
    ---@return boolean
    function this:contains(x, y)
        return (x >= self.x and x < self.x + self.w and y >= self.y and y < self.y + self.h)
    end
    setmetatable(this, _rect_metatable)
    return this
end
---Overlaps two unpacked rect
---@param x1 integer
---@param y1 integer
---@param w1 integer
---@param h1 integer
---@param x2 integer
---@param y2 integer
---@param w2 integer
---@param h2 integer
---@return integer, integer, integer, integer
function ui.rect.overlaps(x1, y1, w1, h1, x2, y2, w2, h2)
    local newX = math.max(x1, x2)
    local newY = math.max(y1, y2)
    local newW = math.min(x1 + w1 - newX, x2 + w2 - newX)
    local newH = math.min(y1 + h1 - newY, y2 + h2 - newY)
    local possible = true
    if newW <= 0 or newH <= 0 then
        possible = false
    end
    return newX, newY, newW, newH, possible
end
