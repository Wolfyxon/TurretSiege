local Container = require("lib.2d.gui.container.Container")

---@class ListContainer: Container
local ListContainer = Container:new()

ListContainer.mode = "vertical" ---@type "vertical" | "horizontal"
ListContainer.spacing = 0       ---@type number

-- TODO: left, right, center mode

function ListContainer:new(o)
    o = Container.new(self, o)
    setmetatable(o, self)
    self.__index = self


    return o
end

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
end

return ListContainer