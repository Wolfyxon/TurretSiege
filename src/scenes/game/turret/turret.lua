local Entity = require("scenes.game.Entity")
local Projectile = require("scenes.game.Projectile")
local Sprite = require("lib.2d.Sprite")
local utils = require("lib.utils")
local Circle = require("lib.2d.Circle")
local Color = require("lib.Color")

---@class Turret: Entity
local Turret = Entity:new()

local scale = 0.15
local bulletColor = Color:new(1, 0.5, 0.5)

local fireSound = love.audio.newSource("scenes/game/turret/audio/fire.ogg", "static")
local joystick = love.joystick.getJoysticks()[1]
local manualRotationSpeed = 20

Turret.damageSound = love.audio.newSource("scenes/game/turret/audio/damage.ogg", "static")
Turret.deathSound = love.audio.newSource("scenes/game/turret/audio/death.ogg", "static")

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

    local t = nil
    o:onEvent("damaged", function ()
        if t then t:stop() end

        local range = 0.005
        local function r() return 0.5 + math.randomf(-range, range) end

        t = o:createTween()
                  :addKeyframe(o, { x = r(), y = r() }, 0.05)
                  :addKeyframe(o, { x = 0.5, y = 0.5 }, 0.05)
        t:play()
    end)

    o:onEvent("died", function ()
        o:shockwave()
    end)

    return o
end

function Turret:update(delta)
    if (love.mouse and love.mouse.isCursorSupported()) or ((not love.mouse or not love.mouse.isCursorSupported()) and utils.system.isMousePressed()) then
        local x, y = utils.system.getMousePos()
        self.targetRotation = self:rotationTo(x, y) 
    end

    if love.mouse and love.mouse.isDown(1) then
        self:fire()
    end

    if joystick then
        if joystick:isGamepadDown("a") then
            self:fire()
        end

        if joystick:isGamepadDown("dpleft") then
            self.targetRotation = self.targetRotation - manualRotationSpeed * delta
        end

        if joystick:isGamepadDown("dpright") then
            self.targetRotation = self.targetRotation + manualRotationSpeed * delta
        end
    end

    self.rotation = math.lerpAngle(self.rotation, self.targetRotation, self.rotationSpeed * delta)
    self.cannon.x = math.lerp(self.cannon.x, 0.2, 5 * delta)
end

---@param powerUp PowerUp
function Turret:powerUpReceived(powerUp)
    
end

-- TODO: Fix freeze on fire on 3DS
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
    b.moveTarget = "forward"
    b.owner = self
    b.damageProjectiles = true
    b.speed = 1
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
        table.erase(projectiles, b)
    end

    b:loadTextureFromFile("scenes/game/projectiles/bullet/bullet.png")
    b:moveRotated(0.02, 0)
    self.parent:addChild(b)
end

function Turret:shockwave()
    local cir = Circle:new()

    cir.fillColor = Color.TRANSPARENT
    cir.outlineColor = Color.WHITE:clone()
    cir.outlineSize = 10
    cir.radius = 0
    cir.x = self.x
    cir.y = self.y

    function cir:update(delta)
        cir.radius = cir.radius + delta * 300
        cir.outlineColor:lerp(Color.TRANSPARENT, delta * 3)

        if cir.radius > 250 then
            cir:destroy()
        end
    end
    
    self.parent:addChild(cir)
end

return Turret