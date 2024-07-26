local Sprite = require("lib.2d.sprite")

---@class Entity: Sprite
local Entity = Sprite:new()
Entity:_appendClass("Entity")
Entity:_registerEvent("died", "damaged")

Entity.hp = 100           ---@type number
Entity.invincible = false ---@type boolean

function Entity:new(o)
    o = Sprite.new(self, o)
    setmetatable(o, self)
    self.__index = self

    return o
end

function Entity:dealDamage(amount)
    if self.invincible then return end

    self.hp = self.hp - amount
    self:emitEvent("damaged")
    if self.hp <= 0 then
        self:die()
    end
end

function Entity:die()
    self.hp = 0
    self:died()
    self:emitEvent("died")
    self:orphanize()
end

function Entity:isAlive()
    return self.hp > 0
end

function Entity:died() end

return Entity