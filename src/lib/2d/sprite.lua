local Node2D = require("lib.2d.node2d")
local Sprite = Node2D:new()

local gameData = require("data")

function Sprite:new(o, path)
    o = Node2D.new(self, o)
    setmetatable(o, self)
    self.__index = self

    o.sizeX = nil
    o.sizeY = nil

    if path then
        o:loadTextureFromFile(path)
    end

    return o
end

function Sprite:loadTextureFromFile(path)
    self.texture = love.graphics.newImage(path)
end

function Sprite:draw()
    if not self.texture then return end
    local tW, tH = self:getTextureSize()

    love.graphics.draw(self.texture, -(tW / 2), -(tH / 2), self.sizeX, self.sizeY)
end

function Sprite:getTextureSize()
    if not self.texture then return end
    return self.texture:getDimensions()
end

function Sprite:getOrigin()
    local w, h = self:getTextureSize()
    return self.x + w / 2, self.y + h / 2
end

return Sprite