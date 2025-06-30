local gameData = require("gameData")

local Color = require("lib.Color")
local Node = require("lib.Node")
local Tween = require("lib.Tween")
local Timer = require("lib.Timer")

---@alias Screen "left" | "bottom" -- NOTE: the top screen is called 'left'
---@alias ScreenTarget "all" | Screen
---@alias ScreenMode "inherit" | ScreenTarget
---@alias ColorMode "set" | "mul" | "add" | "sub"

---@class Node2D: Node
local Node2D = class("Node2D", Node)

Node2D.visible = true             ---@type boolean
Node2D.colorMode = "mul"          ---@type ColorMode
Node2D.screen = "inherit"         ---@type ScreenMode
Node2D.rotation = 0               ---@type number
Node2D.scaleX = 1                 ---@type number
Node2D.scaleY = 1                 ---@type number
Node2D.x = 0                      ---@type number
Node2D.y = 0                      ---@type number
Node2D.color = Color:new(1, 1, 1) ---@type Color

function Node2D:init()
    self.color = (self.color or Color:new(1, 1, 1)):clone()
end

--== Dynamic methods ==--

---@return boolean
function Node2D:isVisibleInTree()
    if not self.visible then
        return false
    end

    for i, v in ipairs(self:getAncestors()) do
        if not v.visible then
            return false
        end
    end

    return true
end

---@param color Color
---@return self
function Node2D:setColor(color)
    self.color = color
    
    return self
end

---@param scale number
---@return self
function Node2D:setScaleAll(scale)
    self.scaleX = scale
    self.scaleY = scale

    return self
end

---@param x number
---@param y number
---@return self
function Node2D:setPosition(x, y)
    self.x = x
    self.y = y

    return self
end

---@return number
function Node2D:getGlobalRotation()
    local rot = self.rotation

    for i,v in ipairs(self:getAncestors()) do
        rot = rot + v.rotation
    end

    return rot
end

---@return number, number
function Node2D:getGlobalPosition()
    local x, y = self.x, self.y
    local scaleX, scaleY = self.scaleX, self.scaleY
    
    for i, v in ipairs(self:getAncestors()) do
        local rad = math.rad(v.rotation)
        local cos_rad = math.cos(rad)
        local sin_rad = math.sin(rad)
        
        local rotated_x = cos_rad * x - sin_rad * y
        local rotated_y = sin_rad * x + cos_rad * y

        x = rotated_x + v.x
        y = rotated_y + v.y

        x = x * v.scaleX
        y = y * v.scaleY

        scaleX = scaleX * v.scaleX
        scaleY = scaleY * v.scaleY
    end

    return x, y
end

---@param x number
---@param y number
---@return self
function Node2D:setGlobalPosition(x, y)
    local ancestors = self:getAncestors()

    for i = #ancestors, 1, -1 do
        local anc = ancestors[i]

        x = (x / anc.scaleX) - anc.x
        y = (y / anc.scaleY) - anc.y

        local rad = math.rad(-anc.rotation)
        local cos_rad = math.cos(rad)
        local sin_rad = math.sin(rad)
        
        local rx = cos_rad * x - sin_rad * y
        local ry = sin_rad * x + cos_rad * y

        x = rx
        y = ry
    end
    
    self.x = x / self.scaleX
    self.y = y / self.scaleY

    return self
end

---@return number, number
function Node2D:getGlobalScale()
    local sx = self.scaleY
    local sy = self.scaleX

    for i, v in ipairs(self:getAncestors()) do
        sx = sx * v.scaleX
        sy = sy * v.scaleY
    end

    return sx, sy
end

---@return ScreenTarget
function Node2D:getTargetScreen()
    if self.screen ~= "inherit" then
        return self.screen ---@type ScreenTarget
    end
    
    for i, v in ipairs(self:getAncestors()) do
        if v.screen ~= "inherit" then
            return v.screen  ---@type ScreenTarget
        end
    end

    return "all"
end

---@param screen Screen?
---@return boolean
function Node2D:canBeDrawnOnScreen(screen)
    if not screen then return true end
    if screen == "right" then return false end -- disable 3D
    local target = self:getTargetScreen()
    return target == screen or target == "all"
end

---@return boolean
function Node2D:isTransformDefault()
    return self.x == 0 and self.y == 0 and self.rotation == 0 and self.scaleX == 1 and self.scaleY == 1
end

---@return Color
function Node2D:getDrawnColor()
    if not self.parent or not self.parent:isA("Node2D") or self.colorMode == "set`" then
        return self.color:clone()
    end

    local color = self.parent:getDrawnColor()
    local m = self.colorMode

    if m == "add" then
        return color + self.color
    elseif m == "sub" then
        return color - self.color
    elseif m == "mul" then
        return color * self.color
    end

    return self.color
end

---@param screen Screen?
function Node2D:drawRequest(screen)
    if not self.visible then return end

    local grp = love.graphics

    grp.push("transform")

    if not self:isTransformDefault() then
        grp.translate(self.x * gameData.width, self.y * gameData.height)
        grp.rotate(math.rad(self.rotation))
        grp.scale(self.scaleX, self.scaleY)
    end

    grp.setColor(self:getDrawnColor():getRGBA())

    --if self:canBeDrawnOnScreen(screen) then
    self:draw(screen)
    --end
    
    for i = 1, #self.children do
        local node = self.children[i]
        
        if node:isA("Node2D") then
            node:drawRequest(screen)
        end
    end

    love.graphics.pop()
end

---@param x number
---@param y number
function Node2D:rotationTo(x, y)
    return math.rotationTo(self.x, self.y, x, y)
end

---@param node Node2D
---@return number
function Node2D:distanceToNode(node)
    local x1, y1 = self:getGlobalPosition()
    local x2, y2 = node:getGlobalPosition()

    return math.distanceTo(x1, y1, x2, y2)
end

---@param deg number
function Node2D:rotate(deg)
    self.rotation = self.rotation + deg
end

---@param x number
---@param y number
function Node2D:move(x, y)
    self.x = self.x + x
    self.y = self.y + y
end

---@param x number
---@param y number
---@param rotation? number
function Node2D:moveRotated(x, y, rotation)
    local rx, ry = math.rotateDirection(x, y, rotation or self.rotation)
    self:move(rx, ry)
end

---@param x number
---@param y number
---@param speed number
function Node2D:moveToward(x, y, speed)
    local rot = self:rotationTo(x, y)
    self:moveRotated(speed, 0, rot)
end

---@return Tween
function Node2D:createTween()
    local t = Tween:new()
    self:addChild(t)

    return t
end

---@return Timer
function Node2D:createTimer()
    local t = Timer:new()
    self:addChild(t)

    return t
end

---@param screen Screen?
function Node2D:draw(screen) end

return Node2D