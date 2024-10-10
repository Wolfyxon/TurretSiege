local PowerUp = require("scenes.game.projectiles.powerUps.PowerUp")
local Color = require("lib.Color")

---@class ShieldPowerUp: PowerUp
local ShieldPowerUp = PowerUp:new()
ShieldPowerUp:_appendClass("ShieldPowerUp")

ShieldPowerUp.color = Color:new(0.5, 0.8, 1)
ShieldPowerUp.iconImage = "shield"
ShieldPowerUp.comminity = 1

function ShieldPowerUp:collected()
    self:getTurret():spawnShield()
end

return ShieldPowerUp