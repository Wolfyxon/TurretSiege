local utils = require("lib.utils")
local Node2D = require("lib.2d.node2d")
local data = require("data")

---@class AreaNode: Node2D
local AreaNode = Node2D:new()

local shapes = {"rect", "circle"}

---@type string
AreaNode.shape = "rect"
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
---@return number[][]
function AreaNode:getGlobalCorners()
    local cx, cy = self:getGlobalPosition()
    local ox, oy = self.width / 2, self.height / 2

    return {
        {cx - ox, cy - oy}, -- top left
        {cx + ox, cy - oy}, -- top right
        {cx - ox, cy + oy}, -- bottom left
        {cx + ox, cy + oy}, -- bottom right
    }
end

return AreaNode