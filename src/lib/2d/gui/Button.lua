local Label = require("lib.2d.gui.Label")
local Color = require("lib.Color")
local utils = require("lib.utils")

---@class Button: Label
local Button = class("Button", Label)
Button:_registerEvent("pressed")

Button.backgroundColorNormal = Color:new(0.6, 0.3, 0)  ---@type Color
Button.backgroundColorFocused = Color:new(0.9, 0.6, 0) ---@type Color
Button.backgroundColorPressed = Color:new(1, 1, 1)     ---@type Color
Button.focused = false                                 ---@type boolean 
Button.enabled = true                                  ---@type boolean
Button.next = nil                                      ---@type Button
Button.previous = nil                                  ---@type Button
Button._mode = "mouse"                                 ---@type "mouse" | "keys"

Button.mX = 0
Button.mY = 0

function Button:init()
    self.backgroundColor = Button.backgroundColorNormal:clone()
    self:setText("Button")

    main.onEvent("mousepressed", function ()
        self:pressRequest()
    end)
end

function Button:update(delta)
    self:checkMouseFocus()
    
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

---@return boolean
function Button:isHovered()
    if not utils.system.hasMouse() then return false end
    if not self:isVisibleInTree() then return false end

    local mX, mY = utils.system.getMousePos("bottom")

    return self:containsGlobalPoint(mX, mY)
end

function Button:checkMouseFocus()
    if not utils.system.hasMouse() then return end
    if not self:isVisibleInTree() then return false end

    local cmX, cmY = utils.system.getMousePos("bottom")

    if cmX ~= self.mX or cmY ~= self.mY then
        self.mX, self.mY = cmX, cmY
        self._mode = "mouse"

        if self:containsGlobalPoint(self.mX, self.mY) then
            self:focus()
        else
            self:unfocus()
        end
    end
end

function Button:pressRequest()
    if not self.parent then return end
    if not self.focused then return end
    if not self:isInScene() then return end
    if not self:isVisibleInTree() then return end

    self:emitEvent("pressed")
    self:pressed()
end

function Button:pressed() end

return Button