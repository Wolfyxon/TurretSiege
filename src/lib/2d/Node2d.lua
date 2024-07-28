local utils = require("lib.utils")
local Color = require("src.lib.Color")

---@class Node2D
local Node2D = {
    eventHandlers = {},        ---@type {string: function[]}
    scene = nil,               ---@type Scene
    main = nil,                ---@type Main
    parent = nil,              ---@type Node2D
    children = {},             ---@type Node2D[]
    visible = true,            ---@type boolean
    screen = "inherit",        ---@type "all" | "inherit" | "left" | "bottom" -- NOTE: the top screen is called 'left'
    rotation = 0,              ---@type number
    scaleX = 1,                ---@type number
    scaleY = 1,                ---@type number
    isReady = false,           ---@type boolean
    classList = {"Node2D"},    ---@type string[]
    x = 0,                     ---@type number
    y = 0,                     ---@type number
    color = Color:new(1, 1, 1) ---@type Color
}

function Node2D:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    o.eventHandlers = utils.table.copy(self.eventHandlers)
    o.color = Color:new(1, 1, 1)
    o.children = {}

    return o
end

--== Dynamic methods ==--

---@param ... string
function Node2D:_registerEvent(...)
    for i, event in ipairs({...}) do
        self.eventHandlers[event] = {}
    end
end

---@param name string
function Node2D:emitEvent(name, ...)
    local handlers = self.eventHandlers[name]
    assert(handlers, "Unknown event '" .. name .. "'")

    for i, v in ipairs(handlers) do
        v(...)
    end
end

---@param name string
---@param handler function
function Node2D:onEvent(name, handler)
    local handlers = self.eventHandlers[name]
    assert(handlers, "Unknown event '" .. name .. "'")

    table.insert(handlers, handler)
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

    node:emitEvent("added", self)
    node:added(self)

    if not node.isReady then
        node:emitEvent("ready")
        node:ready()
    end

    self:emitEvent("nodeAdded", node)
    self:emitEvent("nodeListUpdated")
end

---@param node Node2D
function Node2D:disownChild(node)
    table.remove(self.children, node:getIndex())
    node.parent = nil
    node:emitEvent("removed")
    node:removed(self)
    self:emitEvent("nodeRemoved", node)
    self:emitEvent("nodeListUpdated")
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

---@param screen nil|"left"|"bottom"
function Node2D:drawRequest(screen, data)
    if not self.visible then return end

    love.graphics.push()

    love.graphics.translate(self.x * data.w, self.y * data.h)
    love.graphics.rotate(math.rad(self.rotation))
    love.graphics.scale(self.scaleX, self.scaleY)
    love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)

    if self:canBeDrawnOnScreen(screen) then
        self:draw(screen)
    end
    
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

--== Post logic ==--

Node2D:_registerEvent("ready", "added", "removed", "nodeAdded", "nodeRemoved", "nodeListUpdated")

return Node2D