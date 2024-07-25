local Projectile = require("scenes.game.projectile")

---@class AxeProjectile: Projectile
local AxeProjectile = Projectile:new()
AxeProjectile:_appendClass("AxeProjectile")

AxeProjectile.speed = 0.3
AxeProjectile.rotationSpeed = -500
AxeProjectile.damage = 2

local scale = 0.2

function AxeProjectile:ready()
    self.scaleX = scale
    self.scaleY = scale

    self:loadTextureFromFile("scenes/game/projectiles/axe/axe.png")
end

return AxeProjectile