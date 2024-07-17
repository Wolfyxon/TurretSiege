local scene = require("lib.scene")
local console = require("lib.console")

function scene.load()
    console.print("Debug scene")
    console.print("Game version:", scene.main.version)
    
end

function scene.draw(screen)
    console.draw()
end

function scene.update(delta)
    
end



return scene