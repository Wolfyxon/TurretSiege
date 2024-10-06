local Entity = require("scenes.game.Entity")

---@class Projectile: Entity
local Projectile = Entity:new()
Projectile:_appendClass("Projectile")
Projectile:_registerEvent("hit")

Projectile.hp = 3

Projectile.moveTarget = "turret"     ---@type "turret" | "forward"
Projectile.owner = nil               ---@type Entity
Projectile.comminity = 1             ---@type number
Projectile.level = 1                 ---@type number
Projectile.speed = 0.5               ---@type number
Projectile.rotationSpeed = 0         ---@type number
Projectile.originalRotation = 0      ---@type number
Projectile.damage = 2                ---@type number
Projectile.alreadyHit = false        ---@type boolean
Projectile.lifeTime   = 8            ---@type number
Projectile.spawnedAt  = 0            ---@type number
Projectile.damageProjectiles = false ---@type boolean

function Projectile:new(o)
    o = Entity.new(self, o)
    setmetatable(o, self)
    self.__index = self

    o.spawnedAt = love.timer.getTime()
    o.damageSound = love.audio.newSource("scenes/game/projectiles/audio/smallHit.ogg", "static")


    local t = nil
    local oc = nil
    o:onEvent("damaged", function ()
        if t then t:stop() end
        if not oc then
            oc = o.color:clone()
        end

        t = o:createTween()
                :addKeyframe(o.color, { 
                    r = 1,
                    g = 0.5,
                    b = 0.5,
                    a = 0.8 
                }, 0.05)
                :addKeyframe(o.color, { 
                    r = oc.r,
                    g = oc.g,
                    b = oc.b,
                    a = oc.a
                }, 0.05)
        t:play()
    end)

    return o
end

---@param entity Entity
function Projectile:hit(entity)
    if not self.parent then return end

    entity:dealDamage(self.damage)
    self:emitEvent("hit", entity)
    self:orphanize()
end

function Projectile:update(delta)
    if love.timer.getTime() > self.spawnedAt + self.lifeTime then
        self:destroy()
        return
    end

    if (self.x < -0.1 or self.x > 1.1) or (self.y < -0.1 or self.y > 1.1) then
        self:destroy()
        return
    end

    self.textureRotation = self.textureRotation + self.rotationSpeed  * delta

    if self.moveTarget == "forward" then
        self:moveRotated(self.speed * delta, 0)
    end

    if self.moveTarget == "turret" then
        self:moveToward(0.5, 0.5, self.speed * delta)
    end
    

    for i, v in ipairs(self:getScene():getDescendantsOfClass("Entity")) do
        if self.owner ~= v and self:isTouching(v) and v:getClass() ~= self:getClass() then
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

return Projectile