local Entity = require("scenes.game.entity")

---@class Projectile: Entity
local Projectile = Entity:new()


Projectile.speed = 0.5          ---@type number
Projectile.rotationSpeed = 0  ---@type number
Projectile.damage = 2         ---@type number
Projectile.alreadyHit = false ---@type boolean

function Projectile:new(o)
    o = Entity.new(self, o)
    setmetatable(o, self)
    self.__index = self

    return o
end

function Projectile:update(delta)
    self.textureRotation = self.textureRotation + self.rotationSpeed  * delta
    self:moveRotated(self.speed * delta, 0)
end

return Projectile