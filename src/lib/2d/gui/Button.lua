local Label = require("lib.2d.gui.Label")
local Color = require("lib.Color")
local utils = require("lib.utils")

---@class Button: Label
local Button = Label:new()
Button:_appendClass("Button")
Button:_registerEvent("pressed")

Button.backgroundColorNormal = Color:new(0.5, 0.5, 0)  ---@type Color
Button.backgroundColorFocused = Color:new(0.8, 0.8, 0) ---@type Color
Button.backgroundColorPressed = Color:new(1, 1, 1)     ---@type Color
Button.isPressed = false                               ---@type boolean
Button.wasPressed = false                              ---@type boolean
Button.focused = false                                 ---@type boolean 
Button.enabled = true                                  ---@type boolean
Button.next = nil                                      ---@type Button
Button.previous = nil                                  ---@type Button

local mX, mY = 0, 0

function Button:new(o)
    o = Label.new(self, o)
    setmetatable(o, self)
    self.__index = self


    o.backgroundColor = self.backgroundColorNormal:clone()
    o:setText("Button")

    return o
end

function Button:update(delta)
    self:checkMouseFocus()
    self:checkPress()
    
    self:updateBg(delta)
end

function Button:focus()
    local scene = self:getScene()
    if not scene then return end

    if self.focused then return end

    for i, v in ipairs(scene:getDescendants()) do
        if v:isA("Button") and v.focused then
            v:unfocus()
        end
    end

    self.focused = true
end

function Button:unfocus()
    self.focused = false
end

function Button:updateBg(delta)
    local tar = self.backgroundColorNormal

    if self.isPressed then
        tar = self.backgroundColorPressed
    else if self.focused then
        tar = self.backgroundColorFocused
    end
    end

    self.backgroundColor:lerp(tar, 10 * delta)
end

function Button:checkPress()
    if not self.enabled then return end
    if not self.focused then return end
    
    self.isPressed = utils.system.isMousePressed() or (love.keyboard and love.keyboard.isDown("return"))
    
    if not self.isPressed then
        self.wasPressed = false
        return
    end

    if self.wasPressed then return end

    self.wasPressed = self.isPressed

    if self.isPressed then
        self:emitEvent("pressed")
        self:pressed()
    end
end

---@return boolean
function Button:isHovered()
    if not love.mouse or not love.mouse.isCursorSupported() then return false end
    local mX, mY = utils.system.getMousePos("bottom")

    return self:containsGlobalPoint(mX, mY)
end

function Button:checkMouseFocus()
    if not love.mouse or not love.mouse.isCursorSupported() then return end

    local cmX, cmY = utils.system.getMousePos("bottom")

    if cmX ~= mX or cmY ~= mY then
        mX, mY = cmX, cmY

        if self:containsGlobalPoint(mX, mY) then
            self:focus()
        end
    end
end


function Button:pressed() end

return Button