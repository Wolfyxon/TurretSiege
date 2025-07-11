local Projectile = require("scenes.game.Projectile")

---@class AxeProjectile: Projectile
local AxeProjectile = class("AxeProjectile", Projectile)

AxeProjectile.speed = 0.3
AxeProjectile.rotationSpeed = -500
AxeProjectile.damage = 2

local scale = 0.2

function AxeProjectile:ready()
    self.scaleX = scale
    self.scaleY = scale

    self:loadTextureFromFile("scenes/game/projectiles/level1/axe/axe.png")
end

return AxeProjectile