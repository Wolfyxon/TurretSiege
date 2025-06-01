local GuiNode = require("lib.2d.gui.GuiNode")
local data    = require("data")

---@class Label: GuiNode
local Label = class("Label", GuiNode)

local fontPath = "fonts/ChakraPetch-Bold.ttf"
local globalFontScale = 0.3

Label.padding = 5           ---@type number
Label.textObj = nil         ---@type Text
Label.wrapping = "word"     ---@type "word" | "character" | "nowrap"
Label.textAlign = "center"  ---@type "center" | "left" | "right"
Label.formatted = false     ---@type boolean
Label._unprocessedText = "" ---@type string
Label._fontSize = 16        ---@type integer

function Label:init()
    self:setFontSize(16)
end

function Label:draw()
    GuiNode.draw(self)
    self:drawText()
end

function Label:drawText()
    local tW = self.textObj:getWidth() * globalFontScale
    local tH = self.textObj:getHeight() * globalFontScale

    local ox = -(tW / 2)
    local oy = -(tH / 2)

    if self.textAlign == "left" then
        ox = 0
    end

    if self.textAlign == "right" then
        ox = tW
    end

    if self.positioning == "topleft" then
        ox = 0
        oy = 0
    end

    love.graphics.draw(self.textObj, ox, oy, 0, globalFontScale, globalFontScale)
end

---@param size integer
function Label:setFontSize(size)
    self._fontSize = size
    local font = love.graphics.newFont(fontPath, size)

    local newText = love.graphics.newText or love.graphics.newTextBatch
    self.textObj = newText(font)
    self:setText(self:getText())
end

function Label:adjustSize()
    if self.sizing == "keep" then return end

    local tW = (self.textObj:getWidth() * globalFontScale + self.padding) / data.width
    local tH = (self.textObj:getHeight() * globalFontScale + self.padding) / data.width

    if self.sizing == "minimal" then
        self.width = tW
        self.height = tH

        return
    end

    if self.sizing == "extend" then
        if self.width < tW then
            self.width = tW
        end
        if self.height < tH then
            self.height = tH
        end
    end
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

    self:adjustSize()
end

---@return string
function Label:getText()
    return self._unprocessedText
end

return Label