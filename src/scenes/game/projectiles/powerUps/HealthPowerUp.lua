local PowerUp = require("scenes.game.projectiles.powerUps.PowerUp")
local Color = require("lib.Color")

---@class HealthPowerUp: PowerUp
local HealthPowerUp = PowerUp:new()

HealthPowerUp.iconImage = "health"

function HealthPowerUp:ready()
    PowerUp.ready(self)
    self.color = Color:new(0.5, 1, 0.5)
end

function HealthPowerUp:collected()
    self:getScene().turret:heal(10)
end

return HealthPowerUp