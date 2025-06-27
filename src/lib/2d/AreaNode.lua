local Node2D = require("lib.2d.Node2d")
local gameData = require("gameData")

---@class AreaNode: Node2D
local AreaNode = class("AreaNode", Node2D)

---@alias Positioning "center" | "topleft"

AreaNode.shape = "rect"         ---@type string
AreaNode.positioning = "center" ---@type Positioning
AreaNode.width = 0              ---@type number
AreaNode.height = 0             ---@type number

function AreaNode:drawDebug()
    if self.shape == "rect" then
        local sx, sy = self:getGlobalScale()

        local ox = -(self.width / 2 * sx)
        local oy = -(self.height / 2 * sy)

        if self.positioning == "topleft" then
            ox = 0
            oy = 0
        end

        local x = (self.x + ox) * gameData.height
        local y = (self.y + oy) * gameData.height

        love.graphics.rectangle("fill", x, y, self.width * gameData.width, self.height * gameData.height)

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

---@return number, number
function AreaNode:getSize()
    return self.width, self.height
end

---@param size number
function AreaNode:setSizeAll(size)
    self.width = size
    self.height = size
end

---@param mode Positioning
---@return self
function AreaNode:setPositioning(mode)
    self.positioning = mode
    
    return self
end

-- TODO: Rotation support
---@return {string: number[]}
function AreaNode:getGlobalCorners()
    local sx, sy = self:getGlobalScale()

    local cx, cy = self:getGlobalPosition()
    local ox = (self.width / 2) * sx
    local oy = (self.height / 2) * sy

    if self.positioning == "topleft" then
        ox = 0
        oy = 0
    end

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

---@param x number
---@param y number
---@return boolean
function AreaNode:containsGlobalPoint(x, y)
    local sgX, sgY = self:getGlobalPosition()

    local w = self.width * self.scaleX
    local h = self.height * self.scaleY

    if self.positioning == "center" then
        w = w / 2
        h = h /2
    end

    return (
        x <= sgX + w and x >= sgX - w
        and
        y <= sgY + h and y >= sgY - h
    )
end

return AreaNode