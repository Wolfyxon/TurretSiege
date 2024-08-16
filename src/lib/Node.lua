local utils = require("lib.utils")

---@class Node
local Node = {
    classList = {"Node"},      ---@type string[]
    isReady = false,           ---@type boolean
    eventHandlers = {},        ---@type {string: function[]}
    main = nil,                ---@type Main
    parent = nil,              ---@type Node
    children = {},             ---@type Node[]
    uniqueId = ""              ---@type string
}

function Node:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    o.uniqueId = utils.string.genUniqueId()

    o.eventHandlers = table.copy(self.eventHandlers) -- do not change the 'self'
    o.children = {}

    return o
end

--== Dynamic functions ==--

---@param ... string
function Node:_registerEvent(...)
    for i, event in ipairs({...}) do
        self.eventHandlers[event] = {}
    end
end

---@param name string
function Node:emitEvent(name, ...)
    local handlers = self.eventHandlers[name]
    assert(handlers, "Unknown event '" .. name .. "'")

    for i, v in ipairs(handlers) do
        v(...)
    end
end

---@param name string
---@param handler function
function Node:onEvent(name, handler)
    local handlers = self.eventHandlers[name]
    assert(handlers, "Unknown event '" .. name .. "'")

    table.insert(handlers, handler)
end

---@return integer|nil
function Node:getIndex()
    if not self.parent then return end

    for i, v in ipairs(self.parent.children) do
        if v == self then
            return i
        end
    end
end

---@return string
function Node:toString()
    return self:getClass() .. "(" .. tostring(self) .. ")"
end

---@return string
function Node:getClass()
    return self.classList[#self.classList]
end

---@param className string
function Node:_appendClass(className)
    self.classList = table.copy(self.classList)
    table.insert(self.classList, className)
end

---@param class string
---@param exact? boolean
---@return boolean
function Node:isA(class, exact)
    if exact then
        return self:getClass() == class
    end

    return table.has(self.classList, class)
end

---@return Node[]
function Node:getAncestors()
    local res = {}

    local current = self.parent

    while current do
        table.insert(res, current)
        current = current.parent
    end

    return res
end

---@return Node[]
function Node:getDescendants()
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
---@return Node[]
function Node:getChildrenOfClass(class, exact)
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
---@return Node[]
function Node:getDescendantsOfClass(class, exact)
    local res = {}

    for i, v in ipairs(self:getDescendants()) do
        if v:isA(class, exact) then
            table.insert(res, v)
        end
    end

    return res
end

function Node:orphanize()
    if not self.parent then return end
    self.parent:disownChild(self)
end

---@param node Node
function Node:addChild(node)

    node:orphanize()
    node.parent = self
    node.main = node.main or self.main
    
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

---@param node Node
function Node:disownChild(node)
    table.remove(self.children, node:getIndex())
    node.parent = nil
    node:emitEvent("removed")
    node:removed(self)
    self:emitEvent("nodeRemoved", node)
    self:emitEvent("nodeListUpdated")
end


function Node:destroy()
    for i, v in ipairs(self:getDescendants()) do
        v:orphanize()
    end

    self:orphanize()
end

---@param delta number
function Node:updateRequest(delta)
    self:update(delta)

    for i, v in ipairs(self.children) do
        v:updateRequest(delta)
    end
end

---@return Scene|nil
function Node:getScene()
    for i, v in ipairs(self:getAncestors()) do
        if v:isA("Scene") then
            return v ---@type Scene
        end
    end
end

-- Overrides --

---@param delta number
function Node:update(delta) end

---@param newParent Node
function Node:added(newParent) end

---@param previousParent Node
function Node:removed(previousParent) end

function Node:ready() end

--== Static functions ==--

---@param instance table
---@return boolean
function Node.isNode(instance)
    if type(instance) ~= "table" then
        return false
    end

    local classList = instance.classList

    if not classList or type(classList) ~= "table" then
        return false
    end

    return table.has(classList, "Node")
end

--== Post logic ==--

Node:_registerEvent("ready", "added", "removed", "nodeAdded", "nodeRemoved", "nodeListUpdated")

return Node