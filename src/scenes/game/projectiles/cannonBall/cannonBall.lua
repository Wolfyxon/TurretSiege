local Projectile = require("scenes.game.projectile")

---@class CannonBallProjectile: Projectile
local CannonBallProjectile = Projectile:new()
CannonBallProjectile:_appendClass("AxeProjectile")

CannonBallProjectile.speed = 0.4
CannonBallProjectile.rotationSpeed = 1000
CannonBallProjectile.damage = 5

local scale = 0.28

function CannonBallProjectile:ready()
    self.scaleX = scale
    self.scaleY = scale

    self:loadTextureFromFile("scenes/game/projectiles/cannonBall/cannonBall.png")
end

return CannonBallProjectile