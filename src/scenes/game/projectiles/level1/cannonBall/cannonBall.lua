local Projectile = require("scenes.game.Projectile")

---@class CannonBallProjectile: Projectile
return class("CannonBallProjectile", Projectile):new()
    :set("speed", 0.4)
    :set("rotationSpeed", 1000)
    :set("damage", 5)
    :setScaleAll(0.28)
    :loadTextureFromFile("scenes/game/projectiles/level1/cannonBall/cannonBall.png")
