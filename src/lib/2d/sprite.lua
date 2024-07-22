local gameData = require("data")
local utils    = require("lib.utils")

local AreaNode = require("lib.2d.AreaNode")

---@class Sprite: AreaNode
local Sprite = AreaNode:new()
Sprite:_appendClass("Sprite")

---@type ImageData|nil
Sprite.texture = nil

---@type number
Sprite.textureRotation = 0

---@type boolean
Sprite.enableShadow = true

---@type number
Sprite.shadowOffset = 15

---@type number
Sprite.shadowOpaticy = 0.4

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

    if self.enableShadow then
        local r, g, b, a = love.graphics.getColor()

        local ox, oy = utils.math.rotateDirection(self.shadowOffset, self.shadowOffset, -self:getGlobalRotation())
        
        love.graphics.translate(ox, oy)

        love.graphics.setColor(0, 0, 0, self.shadowOpaticy)
        love.graphics.draw(self.texture, -(tW / 2), -(tH / 2))

        love.graphics.setColor(r, g, b, a)
        love.graphics.translate(-ox, -oy)
    end


    love.graphics.draw(self.texture, -(tW / 2), -(tH / 2))
end

function Sprite:getTextureSize()
    if not self.texture then return end
    return self.texture:getDimensions()
end

return Sprite