local Sprite = require("lib.2d.sprite")

local Entity = Sprite:new()

function Entity:new(o)
    o = Sprite.new(self, o)
    setmetatable(o, self)
    self.__index = self

    o.hp = 100
end

function Entity:damage(amount)
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
