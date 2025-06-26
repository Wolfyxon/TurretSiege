local utils = require("lib.utils")
local Projectile = require("scenes.game.Projectile")
local Sprite = require("lib.2d.Sprite")
local Tween = require("lib.Tween")

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

    local pwu = self

    self:onEvent("damaged", function ()
        pwu.targetArmorDistance = pwu.targetArmorDistance + 0.05

        if pwu:isSafe() then
            pwu.damage = 0
            
            Tween.fadeNode(pwu.armor[1], 0, 0.5)
            Tween.fadeNode(pwu.armor[2], 0, 0.5)
        end
    end)

    self:onEvent("hit", function ()
        if not pwu:isSafe() then return end
        
        pwu:emitEvent("collected")
        pwu:collected()
        pwu:getScene().turret:powerUpReceived(pwu)
    end)

    --== Icon ==--
    self.icon = Sprite:new()
    self.icon.colorMode = "set"
    self.icon:loadTextureFromFile(iconDir .. pwu.iconImage .. ".png")
    self.icon.enableShadow = false
    self:addChild(pwu.icon)

    --== Armor ==--

    self.armor = {
        Sprite:new(),
        Sprite:new()
    }

    local as = 1.5

    local la = self.armor[1]
    la.colorMode = "set"
    la:loadTextureFromFile(armorTexture)
    la:setScaleAll(as)
    self:addChild(la)

    local ra = pwu.armor[2]
    ra.colorMode = "set"
    ra:loadTextureFromFile(armorTexture)
    ra:setScaleAll(as)
    ra.rotation = 180
    self:addChild(ra)

    return pwu
end

function PowerUp:ready()
    self.icon.rotation = -self.rotation
end

function PowerUp:update(delta)
    Projectile.update(self, delta)

    local extraDistance = math.abs(math.sin(self:getTime()) * 0.05)
    self.armorDistance = math.lerp(self.armorDistance, self.targetArmorDistance + extraDistance, 2 * delta)
    self:setArmorDistance(self.armorDistance)
end

---@return boolean
function PowerUp:isSafe()
    return self.hp < self.maxHp - self.armorHp
end

---@param distance number
function PowerUp:setArmorDistance(distance)
    local la = self.armor[1]
    la.x = -distance

    local ra = self.armor[2]
    ra.x = distance
end

function PowerUp:collected() end

return PowerUp