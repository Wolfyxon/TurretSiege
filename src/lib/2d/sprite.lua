local gameData = require("data")

local AreaNode = require("lib.2d.AreaNode")

---@class Sprite: AreaNode
local Sprite = AreaNode:new()

---@type ImageData|nil
Sprite.texture = nil

---@type number
Sprite.textureRotation = 0

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

    love.graphics.rotate(math.rad(self.textureRotation))
    love.graphics.draw(self.texture, -(tW / 2), -(tH / 2))
end

function Sprite:getTextureSize()
    if not self.texture then return end
    return self.texture:getDimensions()
end

return Sprite