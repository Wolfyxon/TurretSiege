local gameData = require("gameData")
local utils    = require("lib.utils")

local AreaNode = require("lib.2d.AreaNode")

---@class Sprite: AreaNode
local Sprite = class("Sprite", AreaNode)

Sprite.texture = nil        ---@type ImageData?
Sprite.textureRotation = 0  ---@type number
Sprite.enableShadow = false ---@type boolean
Sprite.shadowOffset = 15    ---@type number
Sprite.shadowOpaticy = 0.4  ---@type number

---@param path string?
---@return self
function Sprite:new(path)
    local ins = initClass(self)
    
    if path then
        ins:loadTextureFromFile(path)
    end

    return ins
end

---@param path string
function Sprite:loadTextureFromFile(path)
    self.texture = assets.loadImage(path)

    local tW, tH = self:getTextureSize()
    self.width = tW / gameData.width
    self.height = tH / gameData.height
end

function Sprite:draw()
    if not self.texture then return end
    local tW, tH = self:getTextureSize()

    love.graphics.rotate(math.rad(self.textureRotation))

    love.graphics.setShader()

    if self.enableShadow then
        local r, g, b, a = love.graphics.getColor()

        local ox, oy = math.rotateDirection(self.shadowOffset, self.shadowOffset, -self:getGlobalRotation())

        love.graphics.rotate(-math.rad(self.textureRotation))
        love.graphics.translate(ox, oy)
        love.graphics.rotate(math.rad(self.textureRotation))

        love.graphics.setColor(0, 0, 0, self.shadowOpaticy * self.color.a)
        love.graphics.draw(self.texture, -(tW / 2), -(tH / 2))

        love.graphics.setColor(r, g, b, a)
        love.graphics.rotate(-math.rad(self.textureRotation))
        
        love.graphics.translate(-ox, -oy)
        love.graphics.rotate(math.rad(self.textureRotation))
    end


    local ox = 0
    local oy = 0

    if self.positioning == "center" then
        ox = -(tW / 2)
        oy = -(tH / 2)
    end

    love.graphics.setShader(self.shader)
    love.graphics.draw(self.texture, ox, oy)
end

function Sprite:getTextureSize()
    if not self.texture then return end
    return self.texture:getDimensions()
end

return Sprite