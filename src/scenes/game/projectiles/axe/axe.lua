local Projectile = require("scenes.game.projectile")

---@class AxeProjectile: Projectile
local AxeProjectile = Projectile:new()

function AxeProjectile:new(o)
    o = Projectile.new(self, o)
    setmetatable(o, self)
    self.__index = self

    o.rotationSpeed = 4
    o.damage = 2

    return o
end

function AxeProjectile:ready()
    self:loadTextureFromFile("scenes/game/projectile/axe/axe.png")
end

return AxeProjectile