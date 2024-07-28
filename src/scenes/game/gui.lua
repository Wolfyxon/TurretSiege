local Node2D = require("src.lib.2d.Node2d")

---@class GameGui: Node2D
local GameGui = Node2D:new()

function GameGui:ready()
    self.screen = "left"
end

return GameGui
