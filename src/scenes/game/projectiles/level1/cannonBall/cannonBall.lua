local Projectile = require("scenes.game.Projectile")

---@class CannonBallProjectile: Projectile
local CannonBallProjectile = class("CannonBallProjectile", Projectile)

CannonBallProjectile.speed = 0.4
CannonBallProjectile.rotationSpeed = 1000
CannonBallProjectile.damage = 5

local scale = 0.28

function CannonBallProjectile:ready()
    self.scaleX = scale
    self.scaleY = scale

    self:loadTextureFromFile("scenes/game/projectiles/level1/cannonBall/cannonBall.png")
end

return CannonBallProjectile