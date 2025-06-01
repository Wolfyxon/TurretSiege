local GuiNode = require("lib.2d.gui.GuiNode")

---@class Container: GuiNode
local Container = class("Container", GuiNode)

function Container:init()
    self:onEvent("ready", function ()
        self:arrangeChildren()
    end)

    self:onEvent("nodeListUpdated", function ()
        self:arrangeChildren()
    end)
end

function Container:arrangeChildren() end

return Container