local Projectile = require("scenes.game.Projectile")

---@class AxeProjectile: Projectile
return class("AxeProjectile", Projectile):new()
    :set("speed", 0.3)
    :set("rotationSpeed", -500)
    :set("damage", 2)
    :setScaleAll(0.2)
    :loadTextureFromFile("scenes/game/projectiles/level1/axe/axe.png")
