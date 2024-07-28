local utils = require("lib.utils")
local Node2D = require("lib.2d.node2d")
local data = require("data")

---@class AreaNode: Node2D
local AreaNode = Node2D:new()
AreaNode:_appendClass("AreaNode")

local shapes = {"rect", "circle"}

AreaNode.shape = "rect" ---@type string
AreaNode.width = 0      ---@type number
AreaNode.height = 0     ---@type number


function AreaNode:new(o)
    o = Node2D.new(self, o)
    setmetatable(o, self)
    self.__index = self

    return o
end

function AreaNode:drawDebug()
    if self.shape == "rect" then
        local x = (self.x - self.width / 2) * data.height
        local y = (self.y - self.height / 2) * data.height

        love.graphics.rectangle("fill", x, y, self.width * data.width, self.height * data.height)

        --[[for i, corner in ipairs(self:getRectCorners()) do
            local x = corner[1]
            local y = corner[2]

            love.graphics.circle("fill", x, y, 10, 8)
        end]]
    else 
        if self.shape == "circle" then
            love.graphics.circle("fill", self.x, self.y, self.width / 2)   
        end
    end
end

---@param shape "rect"|"circle"
function AreaNode:setShape(shape)
    local found = false
    
    for i,v in ipairs(shapes) do
        if v == type then
            found = true
            break
        end
    end

    assert(found, "Unknown shape '" .. tostring(shape) .. "'")

    self.shape = shape
end

---@return number, number
function AreaNode:getSize()
    return self.width, self.height
end

-- TODO: Rotation support
---@return {string: number[]}
function AreaNode:getGlobalCorners()
    local sx, sy = self:getGlobalScale()

    local cx, cy = self:getGlobalPosition()
    local ox = (self.width / 2) * sx
    local oy = (self.height / 2) * sy

    return {
        topLeft = {cx - ox, cy - oy},
        topRight = {cx + ox, cy - oy},
        bottomLeft = {cx - ox, cy + oy},
        bottomRight = {cx + ox, cy + oy},
    }
end

---@param area AreaNode
---@return boolean
function AreaNode:isTouching(area)
    if area == self then return false end

    local selfCorners = self:getGlobalCorners()
    local otherCorners = area:getGlobalCorners()

    local selfLeft = selfCorners.topLeft[1]
    local selfRight = selfCorners.topRight[1]
    local selfTop = selfCorners.topLeft[2]
    local selfBottom = selfCorners.bottomLeft[2]

    local otherLeft = otherCorners.topLeft[1]
    local otherRight = otherCorners.topRight[1]
    local otherTop = otherCorners.topLeft[2]
    local otherBottom = otherCorners.bottomLeft[2]

    return not (
        selfRight < otherLeft or
        selfLeft > otherRight or
        selfBottom < otherTop or
        selfTop > otherBottom
    )
end

return AreaNode