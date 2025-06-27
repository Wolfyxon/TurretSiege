local Node2D = require("lib.2d.Node2d")
local Label = require("lib.2d.gui.Label")

---@class DebugMenu: Node2D
local DebugMenu = class("DebugMenu", Node2D)

DebugMenu.fpsLabel = nil ---@type Label

function DebugMenu:ready()
    local dm = self
    
    main.onEvent("keypressed", function(key)
        if key == "f3" then
            dm.visible = not dm.visible
        end
    end)

    self.visible = false
    self.fpsLabel = self:addChild(
        Label:new()
        :setPosition(0.5, 0.9)
        :setText("FPS: unknown")
    )
end

function DebugMenu:update(delta)
    self.fpsLabel:setText("FPS: " .. tostring(love.timer.getFPS()))
end

return DebugMenu