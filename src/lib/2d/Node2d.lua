local utils = require("lib.utils")
local Color = require("lib.Color")
local Node = require("lib.Node")
local Tween = require("lib.Tween")

---@class Node2D: Node
local Node2D = Node:new()

Node2D.visible = true             ---@type boolean
Node2D.screen = "inherit"         ---@type "all" | "inherit" | "left" | "bottom" -- NOTE: the top screen is called 'left'
Node2D.rotation = 0               ---@type number
Node2D.scaleX = 1                 ---@type number
Node2D.scaleY = 1                 ---@type number
Node2D.x = 0                      ---@type number
Node2D.y = 0                      ---@type number
Node2D.color = Color:new(1, 1, 1) ---@type Color

Node2D:_appendClass("Node2D")

function Node2D:new(o)
    o = Node.new(self, o)
    setmetatable(o, self)
    self.__index = self
    
    local col = o.color
    if col then
        col = col:clone()
    end

    o.color = col or Color:new(1, 1, 1)

    return o
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

---@param scale number
function Node2D:setScaleAll(scale)
    self.scaleX = scale
    self.scaleY = scale
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

---@return "all" | "left" | "bottom"
function Node2D:getTargetScreen()
    if self.screen ~= "inherit" then
        return self.screen ---@type "all" | "left" | "bottom"
    end
    
    for i, v in ipairs(self:getAncestors()) do
        if v.screen ~= "inherit" then
            return v.screen  ---@type "all" | "left" | "bottom"
        end
    end

    return "all"
end

---@param screen nil | "left" | "bottom"
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

---@param screen nil|"left"|"bottom"
function Node2D:drawRequest(screen, data)
    if not self.visible then return end

    love.graphics.push()

    if not self:isTransformDefault() then
        love.graphics.translate(self.x * data.w, self.y * data.h)
        love.graphics.rotate(math.rad(self.rotation))
        love.graphics.scale(self.scaleX, self.scaleY)
    end

    love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)

    if self:canBeDrawnOnScreen(screen) then
        self:draw(screen)
    end
    
    for i, v in ipairs(self.children) do
        if v:isA("Node2D") then
            v:drawRequest(screen, data)
        end
    end

    love.graphics.pop()
end

---@param x number
---@param y number
function Node2D:rotationTo(x, y)
    return math.rotationTo(self.x, self.y, x, y)
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

---@param screen nil|"left"|"bottom"
function Node2D:draw(screen) end

return Node2D