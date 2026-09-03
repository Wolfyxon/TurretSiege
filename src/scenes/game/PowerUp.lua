local utils = require("lib.utils")
local Projectile = require("scenes.game.Projectile")
local Sprite = require("lib.2d.Sprite")
local Tween = require("lib.Tween")
local Label = require("lib.2d.gui.Label")
local Color = require("lib.Color")

---@class PowerUp: Projectile
local PowerUp = class("PowerUp", Projectile)
PowerUp:_registerEvent("collected")

PowerUp.armorHp = 5                ---@type number
PowerUp.powerUpHp = 10             ---@type number
PowerUp.armor = {}                 ---@type Sprite[]
PowerUp.icon = nil                 ---@type Sprite
PowerUp.armorDistance = 0.15       ---@type number
PowerUp.targetArmorDistance = 0.15 ---@type number
PowerUp.iconImage = "none"         ---@type string
PowerUp.originalColor = nil        ---@type Color
PowerUp.tutorialLabel = nil        ---@type Label

PowerUp.collectCallback = function() end      ---@type function

PowerUp:setScaleAll(0.12)
PowerUp.speed = 0.1

local iconDir = "scenes/game/projectiles/powerUps/img/icons/"
local armorTexture = "scenes/game/projectiles/powerUps/img/armor.png"

function PowerUp:init()
    self.ignoredClasses = {"TurretShieldSegment"}
    self.color = self.color:clone()
    self.originalColor = self.color:clone()
    self:initHp(self.armorHp + self.powerUpHp)
    self:loadTextureFromFile("scenes/game/projectiles/powerUps/img/powerUp.png")
end

function PowerUp:armorChanged()
    if not self:isSafe() then
        return
    end

    self.damageSound = love.audio.newSource("scenes/game/projectiles/powerUps/powerUpHit.ogg", "static")
    self.deathSound = love.audio.newSource("scenes/game/projectiles/powerUps/powerUpBreak.ogg", "static")
    
    if self.tutorialLabel then
        return
    end

    if self:getScene().seenPowerupTutorial then
        return
    end

    self.tutorialLabel = Label:new()
    self.tutorialLabel:setFontSize(128)
    self.tutorialLabel:setText("Don't shoot!")
    self.tutorialLabel.rotation = -self.rotation
    self.tutorialLabel.color = Color:new(1, 1, 1, 0)
    self.tutorialLabel:moveRotated(0, -0.4)

    self:addChild(self.tutorialLabel)
end

function PowerUp:ready()
    local pwu = self

    self:onEvent("damaged", function ()
        pwu.targetArmorDistance = pwu.targetArmorDistance + 0.05

        if self.tutorialLabel and pwu.hp < pwu.maxHp * 0.3 then
            self.tutorialLabel:setText("I'm here to help")
        end

        if pwu:isSafe() then
             self.icon:move(math.randomf(-0.05, 0.05), math.randomf(-0.05, 0.05))

            if #self.armor ~= 0 then
                pwu.damage = 0
                
                Tween.fadeNode(pwu.armor[1], 0, 0.5)
                Tween.fadeNode(pwu.armor[2], 0, 0.5)

                self:armorChanged()
            end
        end
    end)

    self:onEvent("hit", function ()
        if not pwu:isSafe() then return end
        
        local game = pwu:getScene() ---@type GameScene

        if pwu.tutorialLabel then
            game.seenPowerupTutorial = true
        end

        pwu:emitEvent("collected")
        pwu:collectCallback()
        game.turret:powerUpReceived(pwu)
    end)

    self.icon = self:addChild(
        Sprite:new()
        :set("colorMode", "set")
        :set("enableShadow", false)
        :loadTextureFromFile(iconDir .. self.iconImage .. ".png")
    )

    if math.random(0, 5) == 0 then
        self.hp = self.hp - self.armorHp
        self.damage = 0

        self:armorChanged()
    else
        self.armor = {
            self:createArmor(),
            self:createArmor(180)
        }
    end

    self.icon.rotation = -self.rotation
    self.readyCallback()
end

---@param rotation number?
---@return Sprite
function PowerUp:createArmor(rotation)
    return self:addChild(
        Sprite:new()
        :loadTextureFromFile(armorTexture)
        :set("colorMode", "set")
        :set("rotation", rotation or 0)
        :setScaleAll(1.5)
    )
end

function PowerUp:update(delta)
    Projectile.update(self, delta)

    local extraDistance = math.abs(math.sin(self:getTime()) * 0.05)
    self.armorDistance = math.lerp(self.armorDistance, self.targetArmorDistance + extraDistance, 2 * delta)
    self:setArmorDistance(self.armorDistance)

    if self.tutorialLabel then
        self.tutorialLabel.color.a = 0.5 + math.sin(self:getTime() * 5) * 0.5
    end

    self.icon:lerpPosition(0, 0, delta * 10)
end

---@param callback function
---@return self
function PowerUp:onCollect(callback)
    self.collectCallback = callback
    return self
end

---@return boolean
function PowerUp:isSafe()
    return self.hp <= self.maxHp - self.armorHp
end

---@param distance number
function PowerUp:setArmorDistance(distance)
    if #self.armor == 0 then
        return
    end

    local la = self.armor[1]
    la.x = -distance

    local ra = self.armor[2]
    ra.x = distance
end

return PowerUp