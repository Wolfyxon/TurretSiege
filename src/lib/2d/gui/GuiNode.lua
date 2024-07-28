local AreaNode = require("lib.2d.AreaNode")
local Color    = require("lib.Color")
local data     = require("data")

---@class GuiNode: AreaNode
local GuiNode = AreaNode:new()

GuiNode.backgroundColor = nil ---@type Color
GuiNode.borderColor = nil     ---@type Color
GuiNode.borderSize = 0        ---@type number
GuiNode.borderRadius = 0      ---@type number
GuiNode.sizing = "extend"     ---@type "extend" | "minimal" | "keep" 

function GuiNode:new(o)
    o = AreaNode.new(self, o)
    setmetatable(o, self)
    self.__index = self

    o.backgroundColor = Color:new(0, 0, 0, 0)
    o.borderColor = Color:new(0, 0, 0, 0)

    return o
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