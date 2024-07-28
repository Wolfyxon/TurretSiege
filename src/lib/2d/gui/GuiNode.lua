local AreaNode = require("lib.2d.AreaNode")
local Color    = require("lib.Color")

---@class GuiNode: AreaNode
local GuiNode = AreaNode:new()

GuiNode.backgroundColor = nil ---@type Color
GuiNode.borderColor = nil     ---@type Color
GuiNode.borderSize = 0        ---@type number
GuiNode.borderRadius = 0.1    ---@type number

function GuiNode:new(o)
    o = AreaNode.new(self, o)
    setmetatable(o, self)
    self.__index = self

    o.backgroundColor = Color:new(0.5, 0.5, 0.5)
    o.borderColor = Color:new(1, 1, 1)

    return o
end

function GuiNode:draw()
    local ox = -(self.width / 2)
    local oy = -(self.height / 2)

    love.graphics.setColor(self.backgroundColor:getRGBA())
    love.graphics.rectangle(
        "fill",
        self.x + ox,
        self.y + oy,
        self.width,
        self.height,
        self.borderRadius / self.width,
        self.borderRadius / self.height
    )

    love.graphics.setColor(self.borderColor:getRGBA())
    love.graphics.rectangle(
        "line", 
        self.x + ox,
        self.y + oy,
        self.width,
        self.height,
        self.borderRadius / self.width,
        self.borderRadius / self.height
    )
end

return GuiNode