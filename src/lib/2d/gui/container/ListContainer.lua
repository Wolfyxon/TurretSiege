local Container = require("lib.2d.gui.container.Container")

---@class ListContainer: Container
local ListContainer = class("ListContainer", Container)

ListContainer.mode = "vertical" ---@type "vertical" | "horizontal"
ListContainer.spacing = 0       ---@type number

-- TODO: left, right, center mode

function ListContainer:arrangeChildren()
    if self.mode == "vertical" then
        local currentY = 0
        
        for i, v in ipairs(self.children) do
            v.y = currentY
            currentY = currentY + self.spacing

            if v:isA("AreaNode") then
                currentY = currentY + v.height
            end
            
        end
    end

    if self.mode == "horizontal" then
        local currentX = 0
        
        for i, v in ipairs(self.children) do
            v.x = currentX
            currentX = currentX + self.spacing

            if v:isA("AreaNode") then
                currentX = currentX + v.width
            end
        end
    end

    self:adjustSize()
end

function ListContainer:adjustSize()
    local maxW = 0
    local maxH = 0

    for i, v in ipairs(self.children) do
        if v:isA("AreaNode") then
            maxW = math.max(maxW, v.width)
            maxH = math.max(maxH, v.height)
        end
    end

    if self.sizing == "extend" then
        if self.width < maxW then
            self.width = maxW
        end

        if self.height < maxH then
            self.height = maxH
        end
    
    elseif self.sizing == "minimal" then
        self.width = maxW
        self.height = maxH
    end
end

return ListContainer