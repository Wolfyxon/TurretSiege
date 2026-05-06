local ListContainer = require("lib.2d.gui.container.ListContainer")
local Label = require("lib.2d.gui.Label")
local Color = require("lib.Color")
local GuiNode = require("lib.2d.gui.GuiNode")
local Button  = require("lib.2d.gui.Button")

---@class PauseGui: GuiNode
local PauseGui = class("PauseGui", GuiNode)

PauseGui.visible = false
PauseGui.updateMode = "always"

PauseGui.title = nil    ---@type Label
PauseGui.list = nil     ---@type ListContainer

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

    self.list = ListContainer:new()
    self.list.spacing = 0.01
    self.list:setPosition(0.5, 0.5)
    self:addChild(self.list)
    
    self:addButton("Resume", function()
        main.setPause(false)
    end)

    self:addButton("Quit to menu", function()
        main.setPause(false)
        main.loadSceneByName("menu")
    end)

    local music = self.parent.music

    love.audio.setEffect("pause", { type = "reverb" })
    
    local keyEventId = main.onEvent("keypressed", function (key)
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

    self:onEvent("removed", function ()
        main.disconnectEvent("keypressed", keyEventId)
    end)

    print("PauseGui ready")
end

function PauseGui:update(delta)
    local a = 0
    local paused = main.isPaused()

    self.visible = self.color.a > 0.01
    self.title.visible = paused
    self.list.visible = paused

    if paused then
        a = 0.5
    end

    self.backgroundColor.a = math.lerp(self.backgroundColor.a, a, 10 * delta)
end

---@param text string
---@param onClick function
function PauseGui:addButton(text, onClick)
    local btn = Button:new()

    btn:setText(text)
    btn:onEvent("pressed", onClick)
    btn:setSize(0.5, 0.05)

    self.list:addChild(btn)
end

return PauseGui