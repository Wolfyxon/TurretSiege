local Scene = {
    main = nil
}

function Scene:new(o, name)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    self.name = name or debug.getinfo(2, "S").short_src

    return o
end

function Scene:drawRequest(screen)
    self:draw(screen)
end

function Scene:draw(screen)
    love.graphics.print(self.name .. "\nNo draw function implemented. \nScreen name: " .. tostring(screen), 0, 0)
end

function Scene:updateRequest(delta)
    self:update(delta)
end

function Scene:update(delta) end
function Scene:load() end
function Scene:unload() end


return Scene