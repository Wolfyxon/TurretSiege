local Node2D = require("lib.2d.Node2d")
local Color = require("lib.Color")

---@class Circle: Node2D
local Circle = Node2D:new()

Circle.radius = 5         ---@type number
Circle.segments = 20      ---@type number
Circle.outlineSize = 0    ---@type number
Circle.fillColor = nil    ---@type Color
Circle.outlineColor = nil ---@type Color

function Circle:new(o)
    o = Node2D.new(self, o)
    setmetatable(o, self)
    self.__index = self

    o.fillColor = Color:new(1, 1, 1)
    o.outlineColor = Color:new(1, 1, 1)

    return o
end

function Circle:draw()
    self.fillColor:toGraphics()
    love.graphics.circle("fill", 0, 0, self.radius)

    self.outlineColor:toGraphics()
    love.graphics.setLineWidth(self.outlineSize)
    love.graphics.circle("line", 0, 0, self.radius)
end

return Circle