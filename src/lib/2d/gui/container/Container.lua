local GuiNode = require("lib.2d.gui.GuiNode")

---@class Container: GuiNode
local Container = GuiNode:new()

function Container:new(o)
    o = GuiNode.new(self, o)
    setmetatable(o, self)
    self.__index = self

    o:onEvent("ready", function ()
        self:arrangeChildren()
    end)

    o:onEvent("nodeListUpdated", function ()
        self:arrangeChildren()
    end)

    return o
end

function Container:arrangeChildren() end

return Container