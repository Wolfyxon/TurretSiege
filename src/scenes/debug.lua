local Scene = require("lib.2d.Scene")
local Sprite = require("lib.2d.Sprite")
local Color = require("lib.Color")
local utils = require("lib.utils")
local data = require("data")

---@class DebugScene: Scene
local DebugScene = Scene:new()
DebugScene:_appendClass("DebugScene")

DebugScene.sprite = nil ---@type Sprite
DebugScene.cursor = nil ---@type Sprite
DebugScene.protractor = nil ---@type Sprite

function DebugScene:load()

    self.protractor = Sprite:new()
    self.protractor:loadTextureFromFile("scenes/protractor.png")
    self.protractor.x = 0.5
    self.protractor.y = 0.5
    self.protractor:setScaleAll(0.3)
    self:addChild(self.protractor)

    self.sprite = Sprite:new()
    self.sprite:loadTextureFromFile("scenes/game/projectiles/bullet/bullet.png")
    self.sprite.color = Color.RED:clone()
    self.sprite.scaleX = 5
    self.sprite.scaleY = 0.2
    self.sprite.x = 0.5
    self.sprite.y = 0.5
    self:addChild(self.sprite)

    self.cursor = Sprite:new()
    self.cursor:loadTextureFromFile("scenes/game/projectiles/powerUps/img/icons/health.png")
    self.cursor:setScaleAll(0.1)
    self.cursor.color = Color.GREEN:clone()
    self:addChild(self.cursor)
end

function DebugScene:draw(screen)
    
end

function DebugScene:update(delta)
    if love.mouse and love.mouse.isCursorSupported() then
        local x, y = utils.system.getMousePos()
        self.cursor.x = x
        self.cursor.y = y
        self.sprite.rotation = self.sprite:rotationTo(x, y)
    end
end



return DebugScene