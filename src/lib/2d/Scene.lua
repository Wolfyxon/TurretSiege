local Node2D = require("lib.2d.Node2d")
local Color  = require("lib.Color")

---@class Scene: Node2D
local Scene = class("Scene", Node2D)

Scene.name = "scene"                             ---@type string?
Scene.backgroundColor = Color:new(0.3, 0.2, 0.1) ---@type Color

function Scene:reload()
    self:unload()
    self:load()
end

function Scene:draw()
    love.graphics.clear(self.backgroundColor:getRGBA())
end

function Scene:load() end
function Scene:unload() end


return Scene