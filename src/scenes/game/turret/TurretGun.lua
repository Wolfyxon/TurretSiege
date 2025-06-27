local Sprite = require("lib.2d.Sprite")

---@class TurretGun: Sprite
local TurretGun = class("TurretGun", Sprite)

TurretGun:_registerEvent("overheat", "fire")

TurretGun.name = "Gun"       ---@type string
TurretGun.turret = nil       ---@type Turret
TurretGun.lastFire = 0       ---@type number
TurretGun.cooldown = 0.1     ---@type number
TurretGun.heatCapacity = 100 ---@type number
TurretGun.cooling = 1        ---@type number
TurretGun.heat = 0           ---@type number
TurretGun.overheat = false   ---@type boolean

---@param name string
---@param texture string?
---@return self
function TurretGun:new(name, texture)
    local ins = initClass(self, {
        name = name
    })

    if texture then
        ins:loadTextureFromFile(texture)
    end

    return ins
end

---@return boolean
function TurretGun:canFire()
    return not self.overheat and self:getTime() > self.lastFire + self.cooldown
end

---@param cooldown number
---@return self
function TurretGun:setCooldown(cooldown)
    self.cooldown = cooldown
    return self
end

---@param cooling number
---@return self
function TurretGun:setCooling(cooling)
    self.cooling = cooling
    return self
end

---@param cap number
---@return self
function TurretGun:setHeatCapacity(cap)
    self.heatCapacity = cap
    return self
end

function TurretGun:update(delta)
    self.heat = math.max(self.heat - self.cooling, 0)
    self.color.r = math.lerp(self.color.r, self.heat / self.heatCapacity, 5 * delta)

    self:updateCallback(delta)
end

function TurretGun:fire()
    if not self:canFire() then
        return
    end

    self:fireCallback()

    self.lastFire = self:getTime()
    self.heat = math.min(self.heat + 1, self.heatCapacity)

    if self.heat >= self.heatCapacity then
        self.overheat = true
        self:emitEvent("overheat")
    end
end

---@param callback function
function TurretGun:onFire(callback)
   self.updateCallback = callback
end

---@param callback function
function TurretGun:onUpdate(callback)
    self.updateCallback = callback
end

function TurretGun:updateCallback(delta) end
function TurretGun:fireCallback() end

return TurretGun
