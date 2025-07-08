local Entity = require("scenes.game.Entity")

---@class Projectile: Entity
local Projectile = class("Projectile", Entity)
Projectile:_registerEvent("hit")

Projectile.hp = 3

Projectile.ignoredClasses = {}       ---@type string[]
Projectile.moveTarget = "turret"     ---@type "turret" | "forward"
Projectile.owner = nil               ---@type Entity
Projectile.commonity = 1             ---@type number
Projectile.level = 1                 ---@type number
Projectile.speed = 0.5               ---@type number
Projectile.rotationSpeed = 0         ---@type number
Projectile.rotationOffset = 0        ---@type number
Projectile.originalRotation = 0      ---@type number
Projectile.damage = 2                ---@type number
Projectile.alreadyHit = false        ---@type boolean
Projectile.lifeTime   = 8            ---@type number
Projectile.spawnedAt  = 0            ---@type number
Projectile.damageProjectiles = false ---@type boolean

Projectile.readyCallback = function() end ---@type function

function Projectile:init()
    self.ignoredClasses = {}
    self.spawnedAt = self:getTime()
    self.damageSound = love.audio.newSource("scenes/game/projectiles/audio/smallHit.ogg", "static")

    local t = nil
    local oc = nil
    local proj = self

    self.enableShadow = true

    self:onEvent("damaged", function ()
        if t then t:stop() end
        if not oc then
            oc = proj.color:clone()
        end

        t = proj:createTween()
                :addKeyframe(proj.color, { 
                    r = 1,
                    g = 0.5,
                    b = 0.5,
                    a = 0.8 
                }, 0.05)

                :addKeyframe(proj.color, { 
                    r = oc.r,
                    g = oc.g,
                    b = oc.b,
                    a = oc.a
                }, 0.05)
        t:play()
    end)
end

---@param entity Entity
function Projectile:hit(entity)
    if not self.parent then return end

    entity:dealDamage(self.damage)
    self:emitEvent("hit", entity)
    self:orphanize()
end

function Projectile:update(delta)
    if self:getTime() > self.spawnedAt + self.lifeTime then
        self:destroy()
        return
    end

    if (self.x < -0.1 or self.x > 1.1) or (self.y < -0.1 or self.y > 1.1) then
        self:destroy()
        return
    end

    self.textureRotation = self.textureRotation + self.rotationSpeed  * delta

    if self.moveTarget == "forward" then
        self:moveRotated(self.speed * delta, 0, self.rotation - self.rotationOffset)
    end

    if self.moveTarget == "turret" then
        self:moveToward(0.5, 0.5, self.speed * delta)
    end
    

    for i, v in ipairs(self:getScene():getDescendantsOfClass("Entity")) do
        if self.owner ~= v and self:isTouching(v) and v:getClass() ~= self:getClass() then
           local ignored = false
           
            for ii, vv in ipairs(self.ignoredClasses) do
                if v:isA(vv) then
                    ignored = true
                    break
                end
           end

           if not ignored then
                if v:isA("Projectile") then
                    if self.damageProjectiles then
                        self:hit(v)
                    end
                else
                    self:hit(v)
                end
           end

        end
    end

end

---@param callback function
---@return self
function Projectile:onReady(callback)
    self.readyCallback = callback
    return self
end


---@return Turret?
function Projectile:getTurret()
    return main.getCurrentScene().turret
end

return Projectile