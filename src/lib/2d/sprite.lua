local AreaNode = require("src.lib.2d.AreaNode")
local Sprite = AreaNode:new()

local gameData = require("data")

function Sprite:new(o, path)
    o = AreaNode.new(self, o)
    setmetatable(o, self)
    self.__index = self

    if path then
        o:loadTextureFromFile(path)
    end

    return o
end

function Sprite:loadTextureFromFile(path)
    self.texture = love.graphics.newImage(path)

    local tW, tH = self:getTextureSize()
    self.width = tW / gameData.width
    self.height = tH / gameData.height
end

function Sprite:draw()
    if not self.texture then return end
    local tW, tH = self:getTextureSize()

    love.graphics.draw(self.texture, -(tW / 2), -(tH / 2))
end

function Sprite:getTextureSize()
    if not self.texture then return end
    return self.texture:getDimensions()
end

return Sprite