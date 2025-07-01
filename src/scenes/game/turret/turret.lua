local Entity = require("scenes.game.Entity")
local TurretShield = require("scenes.game.turret.shield")
local Sprite = require("lib.2d.Sprite")
local utils = require("lib.utils")
local Circle = require("lib.2d.Circle")
local Color = require("lib.Color")
local gameData = require("gameData")

local basicGun = require("scenes.game.turret.guns.basic")

---@class Turret: Entity
local Turret = class("Turret", Entity)

local scale = 0.15

local joystick = love.joystick.getJoysticks()[1]
local manualRotationSpeed = 20

Turret.damageSound = love.audio.newSource("scenes/game/turret/audio/damage.ogg", "static")
Turret.deathSound = love.audio.newSource("scenes/game/turret/audio/death.ogg", "static")

Turret.bulletRotation = 0       ---@type number
Turret.bulletTargetRotation = 0 ---@type number
Turret.targetRotation = 0       ---@type number
Turret.rotationSpeed = 5        ---@type number
Turret.fireCooldown = 0.2       ---@type number
Turret.lastFireTime = 0         ---@type number
Turret.cannon = nil             ---@type Sprite
Turret.base = nil               ---@type Sprite
Turret.currentGun = nil         ---@type TurretGun
Turret.projectiles = {}         ---@type Projectile[]

function Turret:init()
    self.lastFireTime = self:getTime()

    self.base = Sprite:new("scenes/game/turret/img/base.png")
    self.base.enableShadow = true

    self.currentGun = self:addChild(basicGun:setPosition(0.2, 0))
    self.currentGun.turret = self

    self:setScaleAll(scale)
    self.x = 0.5
    self.y = 0.5

    self:addChild(self.base)

    local t = nil
    self:onEvent("damaged", function ()
        if t then t:stop() end

        local range = 0.005
        local function r() return 0.5 + math.randomf(-range, range) end

        t = self:createTween()
                  :addKeyframe(self, { x = r(), y = r() }, 0.05)
                  :addKeyframe(self, { x = 0.5, y = 0.5 }, 0.05)
        t:play()
    end)

    self:onEvent("died", function ()
        self:shockwave()
    end)

    local customHp = utils.config.getFlagNumberValue("turretHp")

    if customHp then
        self.hp = customHp
    end
end

function Turret:update(delta)
    if utils.system.hasMouse() then
        local x, y = utils.system.getMousePos()
        self.bulletTargetRotation = self:rotationTo(x, y)
        
        x = x - self.x
        y = y - self.y

        local ratio = gameData.width / gameData.height
        if ratio > 1 then
            x = x * ratio
        else
            x = x / ratio
        end
        self.targetRotation = self:rotationTo(self.x + x, self.y + y)
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

    self.bulletRotation = math.lerpAngle(self.bulletRotation, self.bulletTargetRotation, self.rotationSpeed * delta)
    self.rotation = math.lerpAngle(self.rotation, self.targetRotation, self.rotationSpeed * delta)
end

---@param powerUp PowerUp
function Turret:powerUpReceived(powerUp)
    self:shockwave(50, powerUp.originalColor, 30)
end

-- TODO: Fix freeze on fire on 3DS
function Turret:fire()
    self.currentGun:fire()
end

---@param radius? number
---@param color? Color
function Turret:shockwave(radius, color, speed)
    radius = radius or 250
    speed = speed or 50

    local cir = Circle:new()

    cir.fillColor = Color.TRANSPARENT:clone()
    cir.outlineColor = color or Color.WHITE:clone()
    cir.outlineSize = 10
    cir.radius = 0
    cir.x = self.x
    cir.y = self.y

    local targetColor = cir.outlineColor:clone()
    targetColor.a = 0

    local t = self.parent:createTween()
    t:addKeyframe(cir, {
        radius = radius,
        outlineColor = targetColor
    }, radius / speed)

    t:onEvent("finished", function ()
        cir:destroy()
    end)

    t:play()

    self.parent:addChild(cir)
end

function Turret:spawnShield()
    local shield = TurretShield:new()
    shield.x = 0.5
    shield.y = 0.5

    self.parent:addChild(shield)
end

return Turret