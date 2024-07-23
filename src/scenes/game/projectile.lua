local Entity = require("scenes.game.entity")

---@class Projectile: Entity
local Projectile = Entity:new()
Projectile:_appendClass("Projectile")

Projectile.hp = 2

Projectile.speed = 0.5               ---@type number
Projectile.rotationSpeed = 0         ---@type number
Projectile.damage = 2                ---@type number
Projectile.alreadyHit = false        ---@type boolean
Projectile.lifeTime   = 5            ---@type number
Projectile.spawnedAt  = 0            ---@type number
Projectile.damageProjectiles = false ---@type boolean

function Projectile:new(o)
    o = Entity.new(self, o)
    setmetatable(o, self)
    self.__index = self

    o.spawnedAt = love.timer.getTime()

    return o
end

---@param entity Entity
function Projectile:hit(entity)
    entity:dealDamage(self.damage)
    self:orphanize()
end

function Projectile:update(delta)
    if love.timer.getTime() > self.spawnedAt + self.lifeTime then
        self:orphanize()
        return
    end

    self.textureRotation = self.textureRotation + self.rotationSpeed  * delta
    self:moveRotated(self.speed * delta, 0)

    for i, v in ipairs(self.scene:getDescendantsOfClass("Entity")) do
        if self:isTouching(v) then
            if v:isA("Projectile") then
                if self.damageProjectiles then
                    self:hit(v)
                end
            else
                self:hit(v)
            end
        end
    end

end

return Projectile