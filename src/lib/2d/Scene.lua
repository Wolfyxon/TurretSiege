local Node2D = require("lib.2d.Node2d")

---@class Scene: Node2D
local Scene = class("Scene", Node2D)

Scene.name = "scene" ---@type string?

function Scene:draw()
    love.graphics.print(self.name .. "\nNo draw function implemented")
end

function Scene:reload()
    self:unload()
    self:load()
end

function Scene:load() end
function Scene:unload() end


return Scene