local ListContainer = require("lib.2d.gui.container.ListContainer")
local Label = require("lib.2d.gui.Label")
local Color = require("lib.Color")
local GuiNode = require("lib.2d.gui.GuiNode")

---@class PauseGui: GuiNode
local PauseGui = GuiNode:new()
PauseGui.visible = true

PauseGui.title = nil    ---@type Label

function PauseGui:ready()
    self.screen = "bottom"
    self.positioning = "topleft"
    self.backgroundColor = Color:new(0, 0, 0, 0)
    self:setSizeAll(1)

    self.title = Label:new()
    self.title:setText("Paused")
    self.title:setFontSize(64)
    self.title.x = 0.5
    self.title.y = 0.2
    self:addChild(self.title)

end

function PauseGui:update(delta)
    
end

return PauseGui