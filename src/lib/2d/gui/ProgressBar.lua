local Color = require("lib.Color")
local Label = require("lib.2d.gui.Label")
local GuiNode = require("lib.2d.gui.GuiNode")
local data  = require("data")
local utils = require("lib.utils")

---@class ProgressBar: Label
local ProgressBar = Label:new()

ProgressBar.textDisplayStyle = "value/max" ---@type "value/max" | "value" | "percent"
ProgressBar.barPositioning = "left"        ---@type "left" | "center"
ProgressBar.barColor = nil                 ---@type Color
ProgressBar.max = 100                      ---@type number
ProgressBar.value = 50                     ---@type number
ProgressBar.displayValue = 0               ---@type number

function ProgressBar:new(o)
    o = Label.new(self, o)
    setmetatable(o, self)
    self.__index = self

    o.backgroundColor = Color:new(0.1, 0.1, 0.1)
    o.barColor = Color:new(1, 0, 0)
    o.displayValue = o.value

    return o
end

function ProgressBar:update(delta)
    self.displayValue = utils.math.lerp(self.displayValue, self.value, delta * 10)

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
        x * data.width,
        y * data.height,
        w * data.width,
        self.height * data.height
    )

    self.color:toGraphics()
    self:drawText()
end

return ProgressBar