local Projectile = require("scenes.game.Projectile")

---@class SmallRocketProjectile: Projectile
local SmallRocketProjectile = Projectile:new()
SmallRocketProjectile:_appendClass("AxeProjectile")

SmallRocketProjectile.level = 2
SmallRocketProjectile.comminity = 0.5
SmallRocketProjectile.speed = 0.6
SmallRocketProjectile.damage = 10
SmallRocketProjectile.rotationOffset = 90

function SmallRocketProjectile:ready()
    self:setScaleAll(0.2)

    self:loadTextureFromFile("scenes/game/projectiles/smallRocket/rocket.png")
end

function SmallRocketProjectile:update(delta)
    Projectile.update(self, delta)

    self.rotation = self.originalRotation + math.sin(love.timer.getTime() * 10) * 15
end

return SmallRocketProjectile