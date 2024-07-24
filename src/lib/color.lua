---@class Color
local Color = {
    r = 1, ---@type number
    g = 1, ---@type number
    b = 1, ---@type number
    a = 1  ---@type number
}

---@param r number
---@param g number
---@param b number
---@param a? number
function Color:new(r, g, b, a)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.r = r
    o.g = g
    o.b = b
    o.a = a or 1

    return o
end

return Color