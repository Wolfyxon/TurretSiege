local Sprite = require("lib.2d.sprite")

---@class Entity: Sprite
local Entity = Sprite:new()
Entity:_appendClass("Entity")

Entity.hp = 100           ---@type number
Entity.invincible = false ---@type boolean

function Entity:new(o)
    o = Sprite.new(self, o)
    setmetatable(o, self)
    self.__index = self

    return o
end

function Entity:damage(amount)
    if self.invincible then return end

    self.hp = self.hp - amount
    if self.hp <= 0 then
        self:die()
    end
end

function Entity:die()
    self.hp = 0
    self:died()
end

function Entity:died() end

return Entity