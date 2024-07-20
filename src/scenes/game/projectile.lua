local Entity = require("scenes.game.entity")

---@class Projectile: Entity
local Projectile = Entity:new()

---@type number
Projectile.speed = 5
---@type number
Projectile.damage = 2
---@type boolean
Projectile.alreadyHit = false

function Projectile:new(o)
    o = Entity.new(self, o)
    setmetatable(o, self)
    self.__index = self

    return o
end

function Projectile:update(delta)
    self:moveRotated(self.speed * delta, 0)
end

return Projectile