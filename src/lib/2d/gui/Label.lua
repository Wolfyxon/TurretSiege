local GuiNode = require("lib.2d.gui.GuiNode")

---@class Label: GuiNode
local Label = GuiNode:new()
local font = love.graphics.getFont()

Label.textScale = 0.5       ---@type number
Label.textObj = nil         ---@type Text
Label.wrapping = "word"     ---@type "word" | "character" | "nowrap"
Label.formatted = false     ---@type boolean
Label._unprocessedText = "" ---@type string

function Label:new(o)
    o = GuiNode.new(self, o)
    setmetatable(o, self)
    self.__index = self

    o.textObj = love.graphics.newText(font, "")

    return o
end

function Label:draw()
    local tW = self.textObj:getWidth() * self.textScale
    local tH = self.textObj:getHeight() * self.textScale

    local ox = -(tW / 2)
    local oy = -(tH / 2)

    if self.positioning == "topleft" then
        ox = 0
        oy = 0
    end

    love.graphics.draw(self.textObj, ox, oy, 0, self.textScale, self.textScale)
end

---@param text string | any
function Label:setText(text)
    text = tostring(text) or "nil"
    self._unprocessedText = text

    -- TODO: wrapping
    
    if self.formatted then
        self.textObj:setf(text)
    else
        self.textObj:set(text)
    end
end

---@return string
function Label:getText()
    return self._unprocessedText
end

return Label