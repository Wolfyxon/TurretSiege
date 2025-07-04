local PowerUp = require("scenes.game.projectiles.powerUps.PowerUp")
local Color = require("lib.Color")

---@class ShieldPowerUp: PowerUp
local ShieldPowerUp = class("ShieldPowerUp", PowerUp)

ShieldPowerUp.color = Color:new(0.5, 0.8, 1)
ShieldPowerUp.iconImage = "shield"
ShieldPowerUp.comminity = 0.02

function ShieldPowerUp:collected()
    self:getTurret():spawnShield()
end

return ShieldPowerUp