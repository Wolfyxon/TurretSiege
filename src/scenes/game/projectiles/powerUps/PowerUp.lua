local utils = require("lib.utils")
local Projectile = require("scenes.game.Projectile")
local Sprite = require("lib.2d.Sprite")
local Tween = require("lib.Tween")

---@class PowerUp: Projectile
local PowerUp = Projectile:new()
PowerUp:_appendClass("PowerUp")
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

function PowerUp:new(o)
    o = Projectile.new(self, o)
    setmetatable(o, self)
    self.__index = self

    o.ignoredClasses = {"TurretShieldSegment"}
    o.color = o.color:clone()
    o.originalColor = o.color:clone()
    o:initHp(o.armorHp + o.powerUpHp)
    o:loadTextureFromFile("scenes/game/projectiles/powerUps/img/powerUp.png")

    o:onEvent("damaged", function ()
        o.targetArmorDistance = o.targetArmorDistance + 0.05

        if o:isSafe() then
            o.damage = 0
            
            Tween.fadeNode(o.armor[1], 0, 0.5)
            Tween.fadeNode(o.armor[2], 0, 0.5)
        end
    end)

    o:onEvent("hit", function ()
        if not o:isSafe() then return end
        o:emitEvent("collected")
        o:collected()
        o:getScene().turret:powerUpReceived(o)
    end)

    --== Icon ==--
    o.icon = Sprite:new()
    o.icon.colorMode = "set"
    o.icon:loadTextureFromFile(iconDir .. o.iconImage .. ".png")
    o.icon.enableShadow = false
    o:addChild(o.icon)

    --== Armor ==--

    o.armor = {
        Sprite:new(),
        Sprite:new()
    }

    local as = 1.5

    local la = o.armor[1]
    la.colorMode = "set"
    la:loadTextureFromFile(armorTexture)
    la:setScaleAll(as)
    o:addChild(la)

    local ra = o.armor[2]
    ra.colorMode = "set"
    ra:loadTextureFromFile(armorTexture)
    ra:setScaleAll(as)
    ra.rotation = 180
    o:addChild(ra)

    return o
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