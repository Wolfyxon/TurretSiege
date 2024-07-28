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

---@return Color
function Color:clone()
    return Color:new(self.r, self.g, self.b, self.a)
end

---@return number, number, number, number
function Color:getRGBA()
    return self.r, self.g, self.b, self.a
end

function Color:toGraphics()
    love.graphics.setColor(self.r, self.g, self.b, self.a)
end

return Color