local Scene = require("lib.2d.Scene")
local Sprite = require("lib.2d.Sprite")
local utils = require("lib.utils")
local data = require("data")

---@class DebugScene: Scene
local DebugScene = Scene:new()
DebugScene:_appendClass("DebugScene")

DebugScene.sprite = nil ---@type Sprite

local console = require("lib.Console"):new()

function DebugScene:load()
    console:print("Debug scene")
    console:print("Game version:", data.version)
    console:print("Platform:", utils.system.getPlatform())

    self.sprite = Sprite:new()
    self.sprite:loadTextureFromFile("scenes/game/projectiles/bullet/bullet.png")
    self.x = 0.5
    self.y = 0.5
    self:addChild(self.sprite)
end

function DebugScene:draw(screen)
    console:draw()
end

function DebugScene:update(delta)
    
end



return DebugScene