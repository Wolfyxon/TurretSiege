local utils = require("lib.utils")

---@alias UpdateMode "inherit" | "always" | "pausable" | "pausedOnly" 

--[[local Node = {
    classList = {"Node"},      ---@type string[]
    isReady = false,           ---@type boolean
    eventHandlers = {},        ---@type {string: function[]}
    parent = nil,              ---@type Node
    children = {},             ---@type Node[]
    uniqueId = "",             ---@type string
    updateMode = "inherit"     ---@type UpdateMode
}]]

---@class Node: Object
local Node = class("Node")

Node.isReady = false            ---@type boolean
Node.eventHandlers = {}         ---@type {string: function[]}
Node.parent = nil               ---@type Node
Node.children = {}              ---@type Node[]
Node.uniqueId = ""              ---@type string
Node.updateMode = "inherit"     ---@type UpdateMode

function Node:init()
    self.uniqueId = utils.string.genUniqueId()
    self.eventHandlers = table.copy(self.eventHandlers) -- do not change the 'self'
    self.children = {}
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
        if v.ownerId == self.uniqueId then
            v.func(...)
        end
    end
end

---@param name string
---@param handler function
function Node:onEvent(name, handler)
    local handlers = self.eventHandlers[name]
    assert(handlers, "Unknown event '" .. name .. "'")

    table.insert(handlers, {
        func = handler,
        ownerId = self.uniqueId
    })
end

---@return integer?
function Node:getIndex()
    if not self.parent then return end

    for i, v in ipairs(self.parent.children) do
        if v == self then
            return i
        end
    end
end

---@return string
function Node:getClass()
    return self.classList[#self.classList]
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

---@return boolean
function Node:isInScene()
    local scene = main.getCurrentScene()
    if not scene then
        return false
    end

    return (self == scene) or (table.find(self:getAncestors(), scene) ~= nil)
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

function Node:clearChildren()
    for i, v in ipairs(self.children) do
        v:destroy()
    end
end

function Node:destroy()
    for i, v in ipairs(self:getDescendants()) do
        v:orphanize()
    end

    self:orphanize()
end

---@return UpdateMode
function Node:getRealUpdateMode()
    if self.updateMode == "inherit" then
        if self.parent then
            return self.parent:getRealUpdateMode()
        else
            return "pausable"
        end
    end

    return self.updateMode
end

---@return number
function Node:getTime()
    local mode = self:getRealUpdateMode()
    
    if mode == "always" then
        return love.timer.getTime()
    elseif mode == "pausable" then
        return main.activeTime
    elseif mode == "pausedOnly" then
        return main.pausedTime
    end

    error("Failed to get node time, unsupported update mode")
end

---@return boolean
function Node:isPaused()
    if self.updateMode == "always" then
        return false
    end

    if self.updateMode == "pausable" or (self.updateMode == "inherit" and not self.parent) then
        return main.isPaused()
    end

    if self.updateMode == "pausedOnly" then
        return not main.isPaused()
    end

    return self.parent:isPaused()
end

---@param delta number
function Node:updateRequest(delta)
    if not self:isPaused() then
        self:update(delta)
    end

    for i = 1, #self.children do
        local node = self.children[i]

        if node then
            node:updateRequest(delta) 
        end
    end
end

---@return Scene?
function Node:getScene()
    for i, v in ipairs(self:getAncestors()) do
        if v:isA("Scene") then
            return v ---@type Scene
        end
    end
end

---@return string
function Node:__tostring()
    return self:getClass() .. "(" .. tostring(self) .. ")"
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