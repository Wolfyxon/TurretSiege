local Node2D = require("lib.2d.Node2d")

---@class Scene: Node2D
local Scene = class("Scene", Node2D)

Scene.name = "scene" ---@type string?

function Scene:draw(screen)
    love.graphics.print(self.name .. "\nNo draw function implemented. \nScreen name: " .. tostring(screen), 0, 0)
end

function Scene:reload()
    self:unload()
    self:load()
end

function Scene:load() end
function Scene:unload() end


return Scene