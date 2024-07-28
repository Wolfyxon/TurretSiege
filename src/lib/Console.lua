local Console = {
    text = ""
}

function Console:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Console:print(...)
    local str = ""

    for i, v in ipairs({...}) do
        str = str .. tostring(v) .. " "
    end
    
    self.text = self.text .. str .. "\n"
end

function Console:draw()
    love.graphics.print(self.text, 0, 0)
end



return Console