local Entity = require("scenes.game.entity")
local Projectile = require("scenes.game.projectile")
local Sprite = require("lib.2d.sprite")
local utils = require("lib.utils")
local data  = require("data")

---@class Turret
local Turret = Entity:new()

local scale = 0.15

function Turret:new(o)
    o = Entity.new(self, o)
    setmetatable(o, self)
    self.__index = self

    o.targetRotation = 0
    o.rotationSpeed = 5
    o.fireCooldown = 0.2
    o.lastFireTime = 0

    o.base = Sprite:new({}, "scenes/game/turret/img/base.png")
    o.cannon = Sprite:new({}, "scenes/game/turret/img/cannon.png")
    
    o.cannon.x = 0.2
    
    o.scaleX = scale
    o.scaleY = scale
    o.x = 0.5
    o.y = 0.5

    o:addChild(o.cannon)
    o:addChild(o.base)

    return o
end

function Turret:update(delta)
    if love.mouse.isCursorSupported() then
        local x, y = utils.getMousePos()
        self.targetRotation = self:rotationTo(x, y)
    end

    if love.mouse.isDown(1) then
        self:fire()
    end

    self.rotation = utils.math.lerpAngle(self.rotation, self.targetRotation, self.rotationSpeed * delta)
    self.cannon.x = utils.math.lerp(self.cannon.x, 0.2, 5 * delta)
end

function Turret:fire()
    local now = love.timer.getTime()
    if now < self.lastFireTime + self.fireCooldown then 
        return 
    end
    self.lastFireTime = now

    self.cannon.x = 0.15

    local b = Projectile:new()
    b.speed = 3
    b.x = self.x
    b.y = self.y
    b.scaleX = scale
    b.scaleY = scale
    b.rotation = self.rotation
    b.r = 1
    b.g = 0.5
    b.b = 0

    b:loadTextureFromFile("scenes/game/projectiles/bullet/bullet.png")
    b:moveRotated(0.02, 0)
    self.parent:addChild(b)
end

return Turret