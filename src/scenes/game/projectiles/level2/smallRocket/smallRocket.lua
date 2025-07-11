local Projectile = require("scenes.game.Projectile")

---@class SmallRocketProjectile: Projectile
local SmallRocketProjectile = class("SmallRocketProjectile", Projectile)

SmallRocketProjectile.level = 2
SmallRocketProjectile.commonity = 0.5
SmallRocketProjectile.speed = 0.45
SmallRocketProjectile.damage = 10
SmallRocketProjectile.rotationOffset = 90
SmallRocketProjectile.moveTarget = "forward"

function SmallRocketProjectile:ready()
    self:setScaleAll(0.2)

    self:loadTextureFromFile("scenes/game/projectiles/level2/smallRocket/rocket.png")
end

function SmallRocketProjectile:update(delta)
    Projectile.update(self, delta)

    self.rotation = self.originalRotation + math.sin(self:getTime() * 10) * 15
end

return SmallRocketProjectile