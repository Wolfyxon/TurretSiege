local Entity = require("entity")

---@class Projectile
local Projectile = Entity:new()

Projectile.speed = 2

function Projectile:new(o)
    o = Projectile.new(self, o)
    setmetatable(o, self)
    self.__index = self

    return o
end

function Projectile:update(delta)
    self:moveRotated(self.speed * delta, 0)
end