local Sprite = require("lib.2d.Sprite")

---@class TurretGun: Sprite
local TurretGun = class("TurretGun", Sprite)

TurretGun:_registerEvent("overheat")

TurretGun.turret = nil       ---@type Turret
TurretGun.lastFire = 0       ---@type number
TurretGun.cooldown = 0.1     ---@type number
TurretGun.heatCapacity = 100 ---@type number
TurretGun.cooling = 1        ---@type number
TurretGun.heat = 0           ---@type number
TurretGun.overheat = false   ---@type boolean

---@return boolean
function TurretGun:canFire()
    return not self.overheat and self:getTime() > self.lastFire + self.cooldown
end

function TurretGun:update(delta)
    self.heat = math.max(self.heat - self.cooling, 0)
    self.color.r = math.lerp(self.color.r, self.heat / self.heatCapacity, 5 * delta)
end

function TurretGun:fire()
    if not self:canFire() then
        return
    end

    self.lastFire = self:getTime()
    self.heat = math.min(self.heat + 1, self.heatCapacity)

    if self.heat >= self.heatCapacity then
        self.overheat = true
        self:emitEvent("overheat")
    end
end

return TurretGun
