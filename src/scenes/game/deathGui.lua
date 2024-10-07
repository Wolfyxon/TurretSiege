local GuiNode = require("lib.2d.gui.GuiNode")
local ListContainer = require("lib.2d.gui.container.ListContainer")
local Label = require("lib.2d.gui.Label")
local Button = require("lib.2d.gui.Button")
local Color = require("lib.Color")

---@class DeathGui: GuiNode
local DeathGui = GuiNode:new()

local targetColor = Color:new(0, 0, 0, 0.5)

local randomTexts = {
    "You are dead",
    "You can do better!",
    "Almost",
    "That was a tough one.",
    "They got you.",
    "That hurts",
    "Don't give up!"
}

function DeathGui:ready()
    self.backgroundColor = Color:new(0, 0, 0, 0)
    self.positioning = "topleft"
    self.visible = false
    self:setSizeAll(1)
    
    --== Label ==--

    local lbl = Label:new()
    lbl.x = 0.5
    lbl.y = 0.3
    lbl:setText(table.random(randomTexts))
    lbl:setFontSize(64)
    self:addChild(lbl)

    --== Buttons ==--

    local buttonWidth = 0.5
    local buttonHeight = 0.05

    local buttons = ListContainer:new()
    buttons.spacing = 0.01
    buttons.x = 0.5
    buttons.y = 0.7

    local btnRestart = Button:new()
    btnRestart.width = buttonWidth
    btnRestart.height = buttonHeight
    btnRestart:setText("Restart")
    buttons:addChild(btnRestart)

    btnRestart:onEvent("pressed", function ()
        main.loadSceneByName("game")
    end)

    local btnMenu = Button:new()
    btnMenu.width = buttonWidth
    btnMenu.height = buttonHeight
    btnMenu:setText("Main menu")
    buttons:addChild(btnMenu)

    btnMenu:onEvent("pressed", function ()
        main.loadSceneByName("menu")
    end)

    buttons:arrangeChildren()
    self:addChild(buttons)
end

function DeathGui:update(delta)
    if self.visible then
        self.backgroundColor:lerp(targetColor, delta * 5)
    end
end

return DeathGui