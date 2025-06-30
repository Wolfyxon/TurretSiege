local TurretGun = require("scenes.game.turret.TurretGun")
local Projectile = require("scenes.game.Projectile")
local Color = require("lib.Color")

local color = Color:new255(255, 106, 0)

---@class BasicGun: TurretGun
return TurretGun:new("Basic gun", "scenes/game/turret/img/cannon.png")
        :setCooldown(0.2)
        :onFire(function(self)
            local b = class("TurretBullet", Projectile):new()
            b:loadTextureFromFile("scenes/game/projectiles/bullet/bullet.png")
            b.ignoredClasses = {"TurretShieldSegment"}
            b.moveTarget = "forward"
            b.owner = self
            b.damageProjectiles = true
            b.speed = 1
            b.x = self.turret.x
            b.y = self.turret.y
            b:setScaleAll(0.15)
            b.rotation = self.turret.bulletRotation
            b.color = color

            self.turret.parent:addChild(b)
            b:moveRotated(0.05, 0)
        end)