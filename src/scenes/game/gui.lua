local Node2D = require("lib.2d.Node2d")
local ListContainer = require("lib.2d.gui.container.ListContainer")
local Label = require("lib.2d.gui.Label")
local ProgressBar = require("lib.2d.gui.ProgressBar")

---@class GameGui: Node2D
local GameGui = Node2D:new()

GameGui.healthDisplay = nil ---@type Node2D

function GameGui:ready()
    self.screen = "left"

    --== Health display ==--
    local healthDisplay = ListContainer:new()
    healthDisplay.spacing = 0.02
    healthDisplay.x = 0.5
    healthDisplay.y = 0.02

    local hpLbl = Label:new()
    hpLbl.textScale = 0.3
    hpLbl:setText("Turret health")
    healthDisplay:addChild(hpLbl)

    local hpBar = ProgressBar:new()
    hpBar.barPositioning = "center"
    hpBar.width = 0.5
    hpBar.height = 0.04

    self.hpBar = hpBar
    healthDisplay:addChild(hpBar)
    self.healthDisplay = healthDisplay


    self:addChild(healthDisplay)
    healthDisplay:arrangeChildren()
end

function GameGui:update()
    local turret = self:getScene().turret ---@type Turret

    if turret then
        self.hpBar.value = turret.hp
        self.hpBar.max = turret.maxHp
    end
end

return GameGui
