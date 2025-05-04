local ListContainer = require("lib.2d.gui.container.ListContainer")
local Label = require("lib.2d.gui.Label")
local Color = require("lib.Color")
local GuiNode = require("lib.2d.gui.GuiNode")

---@class PauseGui: GuiNode
local PauseGui = GuiNode:new()
PauseGui.visible = false
PauseGui.updateMode = "always"

PauseGui.title = nil    ---@type Label

function PauseGui:ready()
    self.screen = "bottom"
    self.positioning = "topleft"
    self:setSizeAll(1)
    self.backgroundColor = Color:new(0, 0, 0, 0)

    self.title = Label:new()
    self.title:setText("Paused")
    self.title:setFontSize(64)
    self.title.x = 0.5
    self.title.y = 0.2
    self:addChild(self.title)

    local music = self.parent.music

    love.audio.setEffect("pause", { type = "reverb" })
    
    main.onEvent("keypressed", function (key)
        if key == "escape" then
            main.setPause(not main.isPaused())

            local paused = main.isPaused()
            music:setEffect("pause", paused)

            if paused then
                music:setVolume(0.5)
            else
                music:setVolume(1)
            end
        end
    end)

    print("PauseGui ready")
end

function PauseGui:update(delta)
    self.visible = self.color.a > 0.01
    self.title.visible = main.isPaused()

    local a = 0

    if main.isPaused() then
        a = 0.5
    end

    self.backgroundColor.a = math.lerp(self.backgroundColor.a, a, 10 * delta)
end

return PauseGui