local scene = require("lib.scene"):new()
local console = require("lib.console"):new()

function scene:load()
    console.print("Debug scene")
    console.print("Game version:", scene.main.version)
end

function scene:draw(screen)
    console.draw()
end

function scene:update(delta)
    
end



return scene