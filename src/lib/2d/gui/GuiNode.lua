local AreaNode = require("lib.2d.AreaNode")
local Color    = require("lib.Color")
local data     = require("data")

---@class GuiNode: AreaNode
local GuiNode = class("GuiNode", AreaNode)

GuiNode.backgroundColor = nil ---@type Color
GuiNode.borderColor = nil     ---@type Color
GuiNode.borderSize = 0        ---@type number
GuiNode.borderRadius = 0      ---@type number
GuiNode.sizing = "extend"     ---@type "extend" | "minimal" | "keep" 

function GuiNode:init()
    self.backgroundColor = Color:new(0, 0, 0, 0)
    self.borderColor = Color:new(0, 0, 0, 0)

    self:onEvent("nodeListUpdated", function ()
        self:adjustSize()
    end)
end

function GuiNode:draw()
    local ox = -(self.width / 2) * data.width
    local oy = -(self.height / 2) * data.height

    if self.positioning == "topleft" then
        ox = 0
        oy = 0
    end

    self.backgroundColor:toGraphics()
    love.graphics.rectangle(
        "fill",
        ox,
        oy,
        self.width * data.width,
        self.height * data.height,
        self.borderRadius * (self.width * data.width),
        self.borderRadius * (self.height * data.height)
    )

    love.graphics.setLineWidth(self.borderSize)
    self.borderColor:toGraphics()
    love.graphics.rectangle(
        "line", 
        ox,
        oy,
        self.width * data.width,
        self.height * data.height,
        self.borderRadius * (self.width * data.width),
        self.borderRadius * (self.height * data.height)
    )

    self.color:toGraphics()
end

function GuiNode:adjustSize() end

return GuiNode