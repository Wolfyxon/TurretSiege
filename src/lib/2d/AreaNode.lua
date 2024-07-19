local Node2D = require("lib.2d.node2d")
local AreaNode = Node2D:new()

AreaNode.hitboxTypes = {"rect", "circle"}

function AreaNode:new(o, path)
    o = Node2D.new(self, o)
    setmetatable(o, self)
    self.__index = self

    o.hitboxType = "rect"
    o.height = nil
    o.width = nil

    return o
end

function AreaNode:getSize()
    return self.width, self.height
end

return AreaNode