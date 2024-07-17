local Node2D = {
    parent = nil,
    children = {},
    
    x = 0,
    y = 0
}

function Node2D:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    return o
end

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

function Node2D:addChild(node)
    node:orphanize()
    node.parent = self
    table.insert(self.children, node)
end

function Node2D:disownChild(node)
    table.remove(self.children, node:getIndex())
end

function Node2D:draw(screen)
    for i, v in ipairs(self.children) do
        v:draw(screen)
    end
end

function Update:update(delta)
    for i, v in ipairs(self.children) do
        v:update(delta)
    end
end

return Node2D