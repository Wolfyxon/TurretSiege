local AreaNode = require("lib.2d.AreaNode")
local Color    = require("lib.Color")

---@class GuiNode: AreaNode
local GuiNode = AreaNode:new()

GuiNode.backgroundColor = nil ---@type Color
GuiNode.borderColor = nil     ---@type Color
GuiNode.borderSize = 0        ---@type number
GuiNode.borderRadius = 0.1    ---@type number
GuiNode.sizing = "extend"     ---@type "extend" | "minimal" | "keep" 

function GuiNode:new(o)
    o = AreaNode.new(self, o)
    setmetatable(o, self)
    self.__index = self

    o.backgroundColor = Color:new(0.2, 0.2, 0.2)
    o.borderColor = Color:new(1, 1, 1)

    return o
end

function GuiNode:draw()
    local ox = -(self.width / 2)
    local oy = -(self.height / 2)

    if self.positioning == "topleft" then
        ox = 0
        oy = 0
    end

    self.backgroundColor:toGraphics()
    love.graphics.rectangle(
        "fill",
        self.x + ox,
        self.y + oy,
        self.width,
        self.height,
        self.borderRadius * self.width,
        self.borderRadius * self.height
    )

    self.borderColor:toGraphics()
    love.graphics.rectangle(
        "line", 
        self.x + ox,
        self.y + oy,
        self.width,
        self.height,
        self.borderRadius * self.width,
        self.borderRadius * self.height
    )

    self.color:toGraphics()
end

function GuiNode:adjustSize() end

return GuiNode