local Node2D = require("lib.2d.node2d")
local AreaNode = Node2D:new()


function AreaNode:new(o, path)
    o = Node2D.new(self, o)
    setmetatable(o, self)
    self.__index = self

    o.height = nil
    o.width = nil

    return o
end

return AreaNode