local Scene = require("lib.2d.Scene")
local Sprite = require("lib.2d.Sprite")
local utils = require("lib.utils")
local data = require("data")

---@class DebugScene: Scene
local DebugScene = Scene:new()
DebugScene:_appendClass("DebugScene")

DebugScene.sprite = nil ---@type Sprite

function DebugScene:load()

    self.sprite = Sprite:new()
    self.sprite:loadTextureFromFile("scenes/game/projectiles/bullet/bullet.png")
    self.sprite.x = 0.5
    self.sprite.y = 0.5
    self:addChild(self.sprite)
end

function DebugScene:draw(screen)
    
end

function DebugScene:update(delta)
    
end



return DebugScene