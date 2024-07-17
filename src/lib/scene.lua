local Scene = {}
Scene.main = nil

function Scene.drawRequest(screen)
    Scene.draw(screen)
end

function Scene.draw(screen)
    love.graphics.print("No draw function implemented. \nScreen name: " .. tostring(screen), 0, 0)
end

function Scene.updateRequest(delta)
    Scene.update(delta)
end

function Scene.update(delta) end
function Scene.load() end
function Scene.unload() end

return Scene