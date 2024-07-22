local Projectile = require("scenes.game.projectile")

---@class AxeProjectile: Projectile
local AxeProjectile = Projectile:new()

local scale = 0.2

function AxeProjectile:new(o)
    o = Projectile.new(self, o)
    setmetatable(o, self)
    self.__index = self

    o.speed = 0.3
    o.rotationSpeed = -500
    o.damage = 2

    return o
end

function AxeProjectile:ready()
    self.scaleX = scale
    self.scaleY = scale

    self:loadTextureFromFile("scenes/game/projectiles/axe/axe.png")
end

return AxeProjectile