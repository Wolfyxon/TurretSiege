local utils = require("lib.utils")

---@class Node2D
local Node2D = {
    scene = nil,             ---@type Scene
    main = nil,              ---@type Main
    parent = nil,            ---@type Node2D
    children = {},           ---@type Node2D[]
    visible = true,          ---@type boolean
    rotation = 0,            ---@type number
    scaleX = 1,              ---@type number
    scaleY = 1,              ---@type number
    isReady = false,         ---@type boolean
    classList = {"Node2D"},  ---@type string[]
    x = 0,                   ---@type number
    y = 0,                   ---@type number

    r = 1,                   ---@type number
    g = 1,                   ---@type number
    b = 1,                   ---@type number
    a = 1                    ---@type number
}

function Node2D:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    o.children = {}

    return o
end

--== Dynamic methods ==--

---@return integer|nil
function Node2D:getIndex()
    if not self.parent then return end

    for i, v in ipairs(self.parent.children) do
        if v == self then
            return i
        end
    end
end

---@return string
function Node2D:getClass()
    return self.classList[#self.classList]
end

---@param className string
function Node2D:_appendClass(className)
    self.classList = utils.table.copy(self.classList)
    table.insert(self.classList, className)
end

---@param class string
---@param exact? boolean
---@return boolean
function Node2D:isA(class, exact)
    if exact then
        return self:getClass() == class
    end

    return utils.table.find(self.classList, class) ~= nil
end

---@return Node2D[]
function Node2D:getAncestors()
    local res = {}

    local current = self.parent

    while current do
        table.insert(res, current)
        current = current.parent
    end

    return res
end

---@return Node2D[]
function Node2D:getDescendants()
    local res = {}

    for i, v in ipairs(self.children) do
        table.insert(res, v)
        
        for ii, vv in ipairs(v:getDescendants()) do
            table.insert(res, vv)
        end
    end

    return res
end

---@param class string
---@param exact? boolean
---@return Node2D[]
function Node2D:getChildrenOfClass(class, exact)
    local res = {}

    for i, v in ipairs(self.children) do
        if v:isA(class, exact) then
            table.insert(res, v)
        end
    end

    return res
end

---@param class string
---@param exact? boolean
---@return Node2D[]
function Node2D:getDescendantsOfClass(class, exact)
    local res = {}

    for i, v in ipairs(self:getDescendants()) do
        if v:isA(class, exact) then
            table.insert(res, v)
        end
    end

    return res
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
    local x = self.x
    local y = self.y

    for i, v in ipairs(self:getAncestors()) do
        x = x + v.x
        y = y + v.y
    end

    return x, y
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

function Node2D:orphanize()
    if not self.parent then return end
    self.parent:disownChild(self)
end

---@param node Node2D
function Node2D:addChild(node)
    node:orphanize()
    node.parent = self
    node.main = node.main or self.main
    
    node.scene = self.scene
    if self:isA("Scene") then
        node.scene = self
    end

    table.insert(self.children, node)

    node.added(self)

    if not node.isReady then
        node:ready()
    end
end

---@param node Node2D
function Node2D:disownChild(node)
    table.remove(self.children, node:getIndex())
    node.parent = nil
    node:removed(self)
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
    local rx, ry = utils.math.rotateDirection(x, y, self.rotation)
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

--== Static methods ==--

---@param instance table
---@return boolean
function Node2D.isNode2D(instance)
    if type(instance) ~= "table" then
        return false
    end

    local classList = instance.classList

    if not classList or type(classList) ~= "table" then
        return false
    end

    return utils.table.find(classList, "Node2D") ~= nil
end

return Node2D