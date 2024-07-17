local Node2D = require("lib.2d.node2d")

local Scene = Node2D:new()

function Scene:new(o, name)
    o = Node2D.new(self, o)
    setmetatable(o, self)
    self.__index = self

    o.main = nil
    o.name = name or debug.getinfo(2, "S").short_src

    return o
end

function Scene:draw(screen)
    love.graphics.print(self.name .. "\nNo draw function implemented. \nScreen name: " .. tostring(screen), 0, 0)
end

function Scene:load() end
function Scene:unload() end


return Scene