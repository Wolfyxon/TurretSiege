local PowerUp = require("scenes.game.projectiles.powerUps.PowerUp")
local Color = require("lib.Color")

---@class HealthPowerUp: PowerUp
return class("HealthPowerUp", PowerUp):new()
    :setColor(Color:new(0.5, 1, 0.5))
    :set("commonity", 0.1)
    :set("iconImage", "health")
    :onCollect(function(self)
        self:getScene().turret:heal(25)
    end)
