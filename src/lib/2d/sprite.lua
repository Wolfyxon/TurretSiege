local Node2D = require("src.lib.2d.node2d")
local Sprite = Node2D:new()

function Sprite:new(o, path)
    o = Node2D.new(self, o)
    setmetatable(o, self)
    self.__index = self

    o.sizeX = nil
    o.sizeY = nil

    if path then
        self:loadTextureFromFile(path)
    end

    return o
end

function Sprite:loadTextureFromFile(path)
    self.texture = love.graphics.newImage(path)
end

function Sprite:draw()
    if not self.texture then return end
    love.graphics.draw(self.texture, 0, 0, self.sizeX, self.sizeY)
end

return Sprite