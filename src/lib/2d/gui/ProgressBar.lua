local Color = require("lib.Color")
local Label = require("lib.2d.gui.Label")
local GuiNode = require("lib.2d.gui.GuiNode")
local data    = require("data")

---@class ProgressBar: Label
local ProgressBar = Label:new()

ProgressBar.textDisplayStyle = "value/max" ---@type "value/max" | "value" | "percent"
ProgressBar.barColor = nil                 ---@type Color
ProgressBar.max = 100                      ---@type number
ProgressBar.value = 50                     ---@type number

function ProgressBar:new(o)
    o = Label.new(self, o)
    setmetatable(o, self)
    self.__index = self

    o.backgroundColor = Color:new(0.1, 0.1, 0.1)
    o.barColor = Color:new(1, 0, 0)

    return o
end

function ProgressBar:update()
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

    local x = -(self.width / 2 * data.width)
    local y = -(self.height / 2 * data.height) - 0.5

    if self.positioning == "topleft" then
        x = 0
        y = 0
    end

    self.barColor:toGraphics()
    love.graphics.rectangle(
        "fill",
        x,
        y,
        ((self.value / self.max) * self.width) * data.width,
        self.height * data.height
    )

    self.color:toGraphics()
    self:drawText()
end

return ProgressBar