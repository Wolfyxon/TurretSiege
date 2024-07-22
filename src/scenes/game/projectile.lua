local Entity = require("scenes.game.entity")

---@class Projectile: Entity
local Projectile = Entity:new()
Projectile:_appendClass("Projectile")

Projectile.speed = 0.5        ---@type number
Projectile.rotationSpeed = 0  ---@type number
Projectile.damage = 2         ---@type number
Projectile.alreadyHit = false ---@type boolean
Projectile.lifeTime   = 5     ---@type number
Projectile.spawnedAt  = 0     ---@type number

function Projectile:new(o)
    o = Entity.new(self, o)
    setmetatable(o, self)
    self.__index = self

    o.spawnedAt = love.timer.getTime()

    return o
end

function Projectile:update(delta)
    if love.timer.getTime() > self.spawnedAt + self.lifeTime then
        self:orphanize()
        return
    end

    self.textureRotation = self.textureRotation + self.rotationSpeed  * delta
    self:moveRotated(self.speed * delta, 0)
end

return Projectile