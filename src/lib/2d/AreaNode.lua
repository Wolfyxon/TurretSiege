local utils = require("lib.utils")
local Node2D = require("lib.2d.node2d")
local data = require("data")
local AreaNode = Node2D:new()

AreaNode.hitboxTypes = {"rect", "circle"}

function AreaNode:new(o, path)
    o = Node2D.new(self, o)
    setmetatable(o, self)
    self.__index = self

    o.hitboxType = "rect"
    o.height = 1
    o.width = 1

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
            love.graphics.circle("fill", x, y, self.width / 2)   
        end
    end
end

function AreaNode:setHitboxType(type)
    local found = false
    
    for i,v in ipairs(self.hitboxTypes) do
        if v == type then
            found = true
            break
        end
    end

    assert(found, "Unknown hitbox type '" .. tostring(type) .. "'")

    self.hitboxType = type
end

function AreaNode:getSize()
    return self.width, self.height
end

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