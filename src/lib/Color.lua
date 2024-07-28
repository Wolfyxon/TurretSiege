local utils = require("lib.utils")

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

---@param color Color
function Color:lerp(color, speed)
    self.r = utils.math.lerp(self.r, color.r, speed)
    self.g = utils.math.lerp(self.g, color.g, speed)
    self.b = utils.math.lerp(self.b, color.b, speed)
    self.a = utils.math.lerp(self.a, color.a, speed)
end

---@param r number
---@param g number
---@param b number
---@param a number
---@param speed number
function Color:lerpRGBA(r, g, b, a, speed)
    self.r = utils.math.lerp(self.r, r, speed)
    self.g = utils.math.lerp(self.g, g, speed)
    self.b = utils.math.lerp(self.b, b, speed)
    self.a = utils.math.lerp(self.a, a, speed)
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