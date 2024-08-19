local Node2D = require("lib.2d.Node2d")
local ListContainer = require("lib.2d.gui.container.ListContainer")
local Label = require("lib.2d.gui.Label")
local Color = require("lib.Color")
local ProgressBar = require("lib.2d.gui.ProgressBar")

---@class GameGui: Node2D
local GameGui = Node2D:new()

GameGui.healthDisplay = nil ---@type Node2D
GameGui.hasEffect = false ---@type boolean
GameGui.effectBar = nil ---@type ProgressBar

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

    local effectBar = ProgressBar:new()
    effectBar.textDisplayStyle = "none"
    effectBar.barPositioning = "center"
    effectBar:setText("Effect name")
    effectBar.barColor = Color:new(0.5, 1, 0.5)
    effectBar.width = 0.5
    effectBar.height = 0.02
    effectBar.scaleY = 0
    
    healthDisplay:addChild(effectBar)
    self.effectBar = effectBar

    self:addChild(healthDisplay)
    healthDisplay:arrangeChildren()
end

function GameGui:update(delta)
    local turret = self:getScene().turret ---@type Turret

    if turret then
        self.hpBar.value = turret.hp
        self.hpBar.max = turret.maxHp
    end

    local effectBarSpeed = 0.5
    
    if self.hasEffect then
        self.effectBar.scaleY = math.lerp(self.effectBar.scaleY, 1, effectBarSpeed * delta)
    else
        self.effectBar.scaleY = math.lerp(self.effectBar.scaleY, 0, effectBarSpeed * delta)
    end
end

---@param name string
---@param duration number
---@param color Color
function GameGui:setEffect(name, duration, color)
    local bar = self.effectBar

    bar:setText(name)
    bar.value = bar.max
    self.hasEffect = true

    local t = self:createTween()
              :addKeyframe(bar, {
                value = 0
              }, duration)
    t:play()
end

return GameGui
