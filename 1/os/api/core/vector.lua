vector = {}
---@class vector
local _v = {}
---@return vector
function _v:copy()
    return vector.new(self:unpack())
end
function _v:set(x, y, z)
    if x then
        self.x = x
    end
    if y then
        self.y = y
    end
    if z then
        self.z = z
    end
end
function _v:unpack()
    return self.x, self.y, self.z
end
function _v:dot(o)
    return self.x * o.x + self.y * o.y + self.z * o.z
end
function _v:cross(o)
    return vector.new(self.y * o.z - self.z * o.y, self.z * o.x - self.x * o.z, self.x * o.y - self.y * o.x)
end
function _v:sqLength()
    return self.x * self.x + self.y * self.y + self.z * self.z
end
function _v:length()
    return math.sqrt(self:sqLength())
end
function _v:normalize()
    return self:mul(1 / self:length())
end
function _v:round(tolerance)
    tolerance = tolerance or 1.0
    return vector.new(math.floor((self.x + (tolerance * 0.5)) / tolerance) * tolerance, math.floor((self.y + (tolerance * 0.5)) / tolerance) * tolerance, math.floor((self.z + (tolerance * 0.5)) / tolerance) * tolerance)
end

local _v_m = {}
function _v_m.__add(v1, v2)
    return vector.new(v1.x + v2.x, v1.y + v2.y, v1.z + v2.z)
end
---@return vector
function _v_m.__sub(v1, v2)
    if type(v2) ~= "table" then
        error("No vector", 3)
    end
    return vector.new(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z)
end
function _v_m.__mul(v1, v2)
    return vector.new(v1.x * v2, v1.y * v2, v1.z * v2)
end
function _v_m.__div(v, m)
    return vector.new(v.x / m, v.y / m, v.z / m)
end
function _v_m.__unm(v)
    return vector.new(-v.x, -v.y, -v.z)
end
function _v_m.__tostring(v)
    return v.x .. "," .. v.y .. "," .. v.z
end
function _v_m.__eq(v1, v2)
    return (v1.x == v2.x and v1.y == v2.y and v1.z == v2.z)
end
function _v_m.__lt(v1, v2)
    return (v2:sqLength() < v1:sqLength())
end
function _v_m.__le(v1, v2)
    return (v1:sqLength() <= v2:sqLength())
end
_v_m.__index = _v

---@return vector
function vector.new(x, y, z)
    --@type vector
    local v = {
        x = tonumber(x) or x,
        y = tonumber(y) or y,
        z = tonumber(z) or z
    }
    setmetatable(v, _v_m)
    return v
end
function vector.copy(v)
    return v:copy()
end
vector.one = vector.new(1, 1, 1)
vector.zero = vector.new(0, 0, 0)
vector.forward = vector.new(1, 0, 0)
vector.backward = vector.new(-1, 0, 0)
vector.left = vector.new(0, -1, 0)
vector.right = vector.new(0, 1, 0)
vector.up = vector.new(0, 0, 1)
vector.down = vector.new(0, 0, -1)

---@param v1  vector
---@param v2  vector
---@param v3  vector
function vector.contains(v1, v2, v3)
    local vMin = vector.new(math.min(v1.x, v2.x), math.min(v1.y, v2.y), math.min(v1.z, v2.z))
    local vMax = vector.new(math.max(v1.x, v2.x), math.max(v1.y, v2.y), math.max(v1.z, v2.z))
    if v3.x >= vMin.x and v3.x <= vMax.x and v3.y >= vMin.y and v3.y <= vMax.y and v3.z >= vMin.z and v3.z <= vMax.z then
        return true
    else
        return false
    end
end

function vector.convert(list)
    setmetatable(list, _v_m)
end
