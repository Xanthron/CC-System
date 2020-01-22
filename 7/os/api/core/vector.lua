vector = {}
---@class vector
local _v = {}
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
function _v:round(nTolerance)
    nTolerance = nTolerance or 1.0
    return vector.new(
        math.floor((self.x + (nTolerance * 0.5)) / nTolerance) * nTolerance,
        math.floor((self.y + (nTolerance * 0.5)) / nTolerance) * nTolerance,
        math.floor((self.z + (nTolerance * 0.5)) / nTolerance) * nTolerance
    )
end

local _v_m = {}
function _v_m.__add(v1, v2)
    return vector.new(v1.x + v2.x, v1.y + v2.y, v1.z + v2.z)
end
function _v_m.__sub(v1, v2)
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
    return (v1.x == v2.x and v1.y == v2.y and v1.z and v2.z)
end
function _v_m.__lt(v1, v2)
    return (v2:sqLength() < v1:sqLength())
end
function _v_m.__le(v1, v2)
    return (v1:sqLength() <= v2:sqLength())
end
--_v_m.__index = _v
function _v_m.__newindex(v, value)
    print("jo")
    error("Vector cant be set", 2)
end
function _v_m.__index(v, value)
    print("jo")
    error("Vector cant be set", 2)
end

---@return vector
function vector.new(x, y, z)
    --@type vector
    local v = {}
    setmetatable(v, _v_m)
    rawset(v, "x", tonumber(x))
    rawset(v, "y", tonumber(y))
    rawset(v, "z", tonumber(z))
    return v
end
vector.one = vector.new(1, 1, 1)
vector.zero = vector.new(0, 0, 0)
vector.forward = vector.new(1, 0, 0)
vector.backward = vector.new(-1, 0, 0)
vector.left = vector.new(0, -1, 0)
vector.right = vector.new(0, 1, 0)
vector.up = vector.new(1, 0, 0)
vector.down = vector.new(-1, 0, 0)

local v1 = vector.new(1, 2, 3)
--print(v1:length())
v1.x = 10
print(v1)
