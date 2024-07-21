local Projectile = require("scenes.game.projectile")

---@class AxeProjectile: Projectile
local AxeProjectile = Projectile:new()

function AxeProjectile:new(o)
    o = Projectile.new(self, o)
    setmetatable(o, self)
    self.__index = self

    o.rotationSpeed = -500
    o.damage = 2

    return o
end

function AxeProjectile:ready()
    self.scaleX = 0.4
    self.scaleY = 0.4

    self:loadTextureFromFile("scenes/game/projectiles/axe/axe.png")
end

return AxeProjectile