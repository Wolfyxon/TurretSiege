local Projectile = require("scenes.game.Projectile")
local Audio = require("lib.Audio")

---@class ShurikenProjectile: Projectile
local ShurikenProjectile = class("ShurikenProjectile", Projectile)

ShurikenProjectile.rotationSpeed = 800
ShurikenProjectile.level = 2
ShurikenProjectile.commonity = 10.2
ShurikenProjectile.speed = 0.5
ShurikenProjectile.damage = 8
ShurikenProjectile.moveTarget = "forward"

function ShurikenProjectile:ready()
    self:loadTextureFromFile("scenes/game/projectiles/level2/shuriken/shuriken.png")
    self:setScaleAll(0.08)
    self:initHp(4)
    
    self:rotate(math.random(-100, 100))

    local audio = Audio:new():loadFromFile("scenes/game/projectiles/audio/metalHit.ogg", "static"):setVolume(0.3)
    audio.stopOnRemove = false
    self:addChild(audio)

    self:onEvent("damaged", function ()
        audio:setPitch(math.randomf(0.99, 1.04))
        audio:play()

        self:rotate(math.random(-20, 20))
    end)
end

function ShurikenProjectile:update(delta)
    Projectile.update(self, delta)

    local turret = self:getTurret()

    if turret then
        local speed = 1 / self:distanceToNode(turret)
        self.rotation = math.lerpAngle(self.rotation, self:rotationTo(turret.x, turret.y), speed * delta)
    end
end

return ShurikenProjectile