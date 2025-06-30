local Color = require("lib.Color")
local Label = require("lib.2d.gui.Label")
local GuiNode = require("lib.2d.gui.GuiNode")
local gameData = require("gameData")
local utils = require("lib.utils")

---@class ProgressBar: Label
local ProgressBar = class("ProgressBar", Label)

---@alias BarPositioning "left" | "center"

ProgressBar.textDisplayStyle = "value/max" ---@type "value/max" | "value" | "percent" | "none"
ProgressBar.textEnabled = true             ---@type boolean
ProgressBar.barPositioning = "left"        ---@type BarPositioning
ProgressBar.barColor = nil                 ---@type Color
ProgressBar.max = 100                      ---@type number
ProgressBar.value = 50                     ---@type number
ProgressBar.displayValue = 0               ---@type number

function ProgressBar:init()
    self.backgroundColor = Color:new(0.1, 0.1, 0.1)
    self.barColor = Color:new(1, 0, 0)
    self.displayValue = self.value
end

---@param mode BarPositioning
---@return self
function ProgressBar:setBarPositioning(mode)
    self.barPositioning = mode
    return self
end

---@param state boolean
---@return self
function ProgressBar:setTextEnabled(state)
    self.textEnabled = state
    return self
end

---@param color Color
function ProgressBar:setBarColor(color)
    self.barColor = color
    return self
end


function ProgressBar:update(delta)
    self.displayValue = math.lerp(self.displayValue, self.value, delta * 10)

    if self.textDisplayStyle == "value/max" then
        self:setText(tostring(self.value) .. "/" .. tostring(self.max))
    end

    if self.textDisplayStyle == "value" then
        self:setText(tostring(self.value))
    end

    if self.textDisplayStyle == "percent" then
        self:setText(tostring(self.value / self.max * 100) .. "%")
    end
end

function ProgressBar:draw()
    GuiNode.draw(self)

    local x = -(self.width / 2)
    local y = -(self.height / 2)
    local w = (self.displayValue / self.max) * self.width

    if self.positioning == "topleft" then
        x = 0
        y = 0
    end

    if self.barPositioning == "center" then
        x = -(w / 2)
    end

    self.barColor:toGraphics()
    love.graphics.rectangle(
        "fill",
        x * gameData.width,
        y * gameData.height,
        w * gameData.width,
        self.height * gameData.height
    )

    self.color:toGraphics()

    if self.textEnabled then
        self:drawText()
    end
end

return ProgressBar