local utils = require("lib.utils")

local Node2D = {
    parent = nil,
    visible = true,
    rotation = 0,
    scaleX = 1,
    scaleY = 1,
    x = 0,
    y = 0,

    r = 1,
    g = 1,
    b = 1,
    a = 1
}

function Node2D:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    o.children = {}

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

    node.added(self)
end

function Node2D:disownChild(node)
    table.remove(self.children, node:getIndex())
    node.removed(self)
end

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

function Node2D:updateRequest(delta)
    self:update(delta)

    for i, v in ipairs(self.children) do
        v:updateRequest(delta)
    end
end

function Node2D:rotationTo(x, y)
    return utils.math.rotationTo(self.x, self.y, x, y)
end

function Node2D:rotate(deg)
    self.rotation = self.rotation + deg
end

function Node2D:move(x, y)
    self.x = self.x + x
    self.y = self.y + y
end

function Node2D:moveRotated(x, y)
    local ang = math.rad(self.rotation)
    local rx = x * math.cos(ang) - y * math.sin(ang)
    local ry = x * math.sin(ang) + y * math.cos(ang)
    self:move(rx, ry)
end

function Node2D:draw(screen) end
function Node2D:update(delta) end
function Node2D.added(newParent) end
function Node2D.removed(previousParent) end

return Node2D