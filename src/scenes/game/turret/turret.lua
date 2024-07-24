local Entity = require("scenes.game.entity")
local Projectile = require("scenes.game.projectile")
local Sprite = require("lib.2d.sprite")
local utils = require("lib.utils")
local data  = require("data")
local Color = require("lib.color")

---@class Turret: Entity
local Turret = Entity:new()

local scale = 0.15
local bulletColor = Color:new(1, 0.5, 0.5)

local fireSound = love.audio.newSource("scenes/game/turret/fire.ogg", "static")

Turret.targetRotation = 0 ---@type number
Turret.rotationSpeed = 5  ---@type number
Turret.fireCooldown = 0.2 ---@type number
Turret.lastFireTime = 0   ---@type number
Turret.cannon = nil       ---@type Sprite
Turret.base = nil         ---@type Sprite
Turret.projectiles = {}   ---@type Projectile[]

function Turret:new(o)
    o = Entity.new(self, o)
    setmetatable(o, self)
    self.__index = self

    o.projectiles = {}

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

    local x, y = utils.getMousePos()
    self.targetRotation = self:rotationTo(x, y)

    if love.mouse and love.mouse.isDown(1) then
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

    fireSound:stop()
    fireSound:play()

    self.lastFireTime = now
    self.cannon.x = 0.15

    local b = Projectile:new()
    b:_appendClass("TurretBullet")
    b.owner = self
    b.damageProjectiles = true
    b.speed = 3
    b.x = self.x
    b.y = self.y
    b.scaleX = scale
    b.scaleY = scale
    b.rotation = self.rotation
    b.color = bulletColor
    
    table.insert(self.projectiles, b)
    
    -- NOTE: self.projectiles can't be accessed in the sub-function so it has to be point to a variable
    local projectiles = self.projectiles
    function b:removed()
        utils.table.erase(projectiles, b)
    end

    b:loadTextureFromFile("scenes/game/projectiles/bullet/bullet.png")
    b:moveRotated(0.02, 0)
    self.parent:addChild(b)
end

return Turret