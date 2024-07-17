local Node2D = require("src.lib.2d.node2d")
local Sprite = require("src.lib.2d.sprite")

local Turret = Node2D:new()

function Turret:new(o)
    o = Node2D.new(self, o)
    setmetatable(o, self)
    self.__index = self

    o.base = Sprite:new({}, "scenes/game/turret/img/base.png")
    o.cannon = Sprite:new({}, "scenes/game/turret/img/cannon.png")
    
    o:addChild(o.cannon)
    o:addChild(o.base)

    return o
end

return Turret