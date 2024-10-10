local Projectile = require("scenes.game.Projectile")

---@class ShurikenProjectile: Projectile
local ShurikenProjectile = Projectile:new()
ShurikenProjectile:_appendClass("ShurikenProjectile")

ShurikenProjectile.rotationSpeed = 800
ShurikenProjectile.level = 2
ShurikenProjectile.comminity = 10.2
ShurikenProjectile.speed = 0.5
ShurikenProjectile.damage = 8
ShurikenProjectile.moveTarget = "forward"

function ShurikenProjectile:ready()
    self:loadTextureFromFile("scenes/game/projectiles/level2/shuriken/shuriken.png")
    self:setScaleAll(0.08)
    self:initHp(4)
    
    self:rotate(math.random(-100, 100))
end

function ShurikenProjectile:update(delta)
    Projectile.update(self, delta)

    local turret = self:getTurret()

    if turret then
        local speed = 1 / self:distanceToNode(turret)
        self.rotation = math.lerpAngle(self.rotation, self:rotationTo(turret.x, turret.y), speed * delta)
    end
end

return ShurikenProjectile