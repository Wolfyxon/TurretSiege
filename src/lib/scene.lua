local Scene = {}

function Scene.new(name)
    local this = {}

    this.name = name or debug.getinfo(2, "S").short_src
    this.main = nil

    function this.drawRequest(screen)
        this.draw(screen)
    end
    
    function this.draw(screen)
        love.graphics.print(this.name .. "\nNo draw function implemented. \nScreen name: " .. tostring(screen), 0, 0)
    end
    
    function this.updateRequest(delta)
        this.update(delta)
    end
    
    function this.update(delta) end
    function this.load() end
    function this.unload() end
    
    return this
end

return Scene