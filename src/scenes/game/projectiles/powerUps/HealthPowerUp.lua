local PowerUp = require("scenes.game.projectiles.powerUps.PowerUp")
local Color = require("lib.Color")

---@class HealthPowerUp: PowerUp
local HealthPowerUp = PowerUp:new()
HealthPowerUp:_appendClass("HealthPowerUp")

HealthPowerUp.color = Color:new(0.5, 1, 0.5)
HealthPowerUp.iconImage = "health"


function HealthPowerUp:collected()
    self:getScene().turret:heal(25)
end

return HealthPowerUp