local utils = require("lib.utils")

---@class Node2D
local Node2D = {
    main = nil,      ---@type Main
    parent = nil,    ---@type Node2D
    children = {},   ---@type Node2D[]
    visible = true,  ---@type boolean
    rotation = 0,    ---@type number
    scaleX = 1,      ---@type number
    scaleY = 1,      ---@type number
    isReady = false, ---@type boolean
    x = 0,           ---@type number
    y = 0,           ---@type number

    r = 1,           ---@type number
    g = 1,           ---@type number
    b = 1,           ---@type number
    a = 1            ---@type number
}

function Node2D:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    o.children = {}

    return o
end

---@return integer|nil
function Node2D:getIndex()
    if not self.parent then return end

    for i, v in ipairs(self.parent.children) do
        if v == self then
            return i
        end
    end
end

function Node2D:orphanize()
    if not self.parent then return end
    self.parent:disownChild(self)
end

---@param node Node2D
function Node2D:addChild(node)
    node:orphanize()
    node.parent = self
    node.main = node.main or self.main
    table.insert(self.children, node)

    node.added(self)
end

---@param node Node2D
function Node2D:disownChild(node)
    table.remove(self.children, node:getIndex())
    node.removed(self)
end

---@param screen nil|"left"|"bottom"
function Node2D:drawRequest(screen, data)
    if not self.visible then return end

    love.graphics.push()

    love.graphics.translate(self.x * data.w, self.y * data.h)
    love.graphics.scale(self.scaleX, self.scaleY)
    love.graphics.rotate(math.rad(self.rotation))
    love.graphics.setColor(self.r, self.g, self.b, self.a)

    self:draw(screen)

    for i, v in ipairs(self.children) do
        v:drawRequest(screen, data)
    end

    love.graphics.pop()
end

---@param delta number
function Node2D:updateRequest(delta)
    self:update(delta)

    for i, v in ipairs(self.children) do
        v:updateRequest(delta)
    end
end

---@param x number
---@param y number
function Node2D:rotationTo(x, y)
    return utils.math.rotationTo(self.x, self.y, x, y)
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
function Node2D:moveRotated(x, y)
    local ang = math.rad(self.rotation)
    local rx = x * math.cos(ang) - y * math.sin(ang)
    local ry = x * math.sin(ang) + y * math.cos(ang)
    self:move(rx, ry)
end

---@param screen nil|"left"|"bottom"
function Node2D:draw(screen) end

---@param delta number
function Node2D:update(delta) end

---@param newParent Node2D
function Node2D:added(newParent) end

---@param previousParent Node2D
function Node2D:removed(previousParent) end

function Node2D:ready() end

return Node2D