local utils = require("lib.utils")
local Node2D = require("lib.2d.node2d")
local data = require("data")

---@class AreaNode: Node2D
local AreaNode = Node2D:new()

local hitboxTypes = {"rect", "circle"}

---@type string
AreaNode.hitboxType = "rect"
---@type number
AreaNode.width = 0
---@type number
AreaNode.height = 0


function AreaNode:new(o)
    o = Node2D.new(self, o)
    setmetatable(o, self)
    self.__index = self

    return o
end

function AreaNode:drawDebug()
    if self.hitboxType == "rect" then
        local x = (self.x - self.width / 2) * data.height
        local y = (self.y - self.height / 2) * data.height

        love.graphics.rectangle("fill", x, y, self.width * data.width, self.height * data.height)

        for i, corner in ipairs(self:getRectCorners()) do
            local x = corner[1]
            local y = corner[2]

            love.graphics.circle("fill", x, y, 10, 8)
        end
    else 
        if self.hitboxType == "circle" then
            love.graphics.circle("fill", self.x, self.y, self.width / 2)   
        end
    end
end

---@param type "rect"|"circle"
function AreaNode:setHitboxType(type)
    local found = false
    
    for i,v in ipairs(hitboxTypes) do
        if v == type then
            found = true
            break
        end
    end

    assert(found, "Unknown hitbox type '" .. tostring(type) .. "'")

    self.hitboxType = type
end

---@return number, number
function AreaNode:getSize()
    return self.width, self.height
end

---@return number[][]
function AreaNode:getRectCorners()
    local cx = self.x + self.width / 2
    local cy = self.y + self.height / 2
    
    return {
        {utils.math.rotatePoint(self.x, self.y, cx, cy, self.rotation)},
        {utils.math.rotatePoint(self.x + self.width, self.y, cx, cy, self.rotation)},
        {utils.math.rotatePoint(self.x + self.width, self.y + self.height, cx, cy, self.rotation)},
        {utils.math.rotatePoint(self.x, self.y + self.height, cx, cy, self.rotation)}
    }
end

return AreaNode