local Node2D = require("lib.2d.node2d")
local Sprite = require("lib.2d.sprite")

local Turret = Node2D:new()

function Turret:new(o)
    o = Node2D.new(self, o)
    setmetatable(o, self)
    self.__index = self

    o.base = Sprite:new({}, "scenes/game/turret/img/base.png")
    o.cannon = Sprite:new({}, "scenes/game/turret/img/cannon.png")
    
    o.cannon.x = 0.2
    
    o.scaleX = 0.3
    o.scaleY = 0.3
    o.x = 0.5
    o.y = 0.5

    o:addChild(o.cannon)
    o:addChild(o.base)

    return o
end

return Turret