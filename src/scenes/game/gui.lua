local Node2D = require("lib.2d.node2d")

---@class GameGui: Node2D
local GameGui = Node2D:new()

function GameGui:ready()
    self.screen = "left"
end

return GameGui
