_rect_metatable = {__newindex = function(self, key, value)
        error("Please use the given functions to edit Values", 2)
    end, __tostring = function(self)
        return "(" .. self.x .. ", " .. self.y .. ", " .. self.w .. ", " .. self.h .. ")"
    end, __eq = function(self, rect)
        return (self.x == rect.x and self.y == rect.y and self.w == rect.w and self.h == rect.h)
    end, __metatable = false}
function new(x, y, w, h)
    local this = {x = x or 0, y = y or 0, w = w or 0, h = h or 0}
    this.getUnpacked = function()
        return this.x, this.y, this.w, this.h
    end
    this.set = function(x, y, w, h)
        this.x = x or this.x
        this.y = y or this.y
        this.w = w or this.w
        this.h = h or this.h
    end
    this.getOverlaps = function(x, y, w, h)
        return overlaps(x, y, w, h, this.getUnpacked())
    end
    this.contains = function(x, y)
        return (x >= this.x and x < this.x + this.w and y >= this.y and y < this.y + this.h)
    end
    setmetatable(this, _rect_metatable)
    return this
end
function overlaps(x1, y1, w1, h1, x2, y2, w2, h2)
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
