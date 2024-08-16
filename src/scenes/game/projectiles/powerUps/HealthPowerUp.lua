local PowerUp = require("scenes.game.projectiles.powerUps.PowerUp")
local Color = require("lib.Color")

---@class HealthPowerUp: Powerup
local HealthPowerUp = PowerUp:new()

function HealthPowerUp:ready()
    self.color = Color:new(0.5, 1, 0.5)
end

function HealthPowerUp:collected()
    self.scene.turret:heal(10)
end

return HealthPowerUp