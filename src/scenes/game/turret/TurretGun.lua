local Sprite = require("lib.2d.Sprite")

---@class TurretGun: Sprite
local TurretGun = class("TurretGun", Sprite)

TurretGun:_registerEvent("overheat", "fire")

TurretGun.name = "Gun"       ---@type string
TurretGun.turret = nil       ---@type Turret
TurretGun.lastFire = 0       ---@type number
TurretGun.cooldown = 0.1     ---@type number
TurretGun.heatCapacity = 100 ---@type number
TurretGun.cooling = 4        ---@type number
TurretGun.recoil = 0.15      ---@type number
TurretGun.recoilRecover = 5  ---@type number
TurretGun.heat = 0           ---@type number
TurretGun.overheat = false   ---@type boolean
TurretGun.fireSound = love.audio.newSource("scenes/game/turret/audio/firing/small.ogg", "static") ---@type Source

---@generic Self: self
---@param name string
---@param texture string?
---@return Self
function TurretGun:new(name, texture)
    local ins = initClass(self, {
        name = name,
        enableShadow = true
    })

    if texture then
        ins:loadTextureFromFile(texture)
    end

    ins:loadShader("shaders/colorBoost.glsl")

    return ins
end

---@param path string
---@return self
function TurretGun:setFireSound(path)
    self.sound = love.sound.newSource(path, "static")
    return self
end

---@return boolean
function TurretGun:canFire()
    if self.overheat then
        return false
    end

    local cooldown = self.cooldown - math.min(self.cooldown * 0.4, self.heat / self.heatCapacity)

    return self:getTime() > self.lastFire + cooldown 
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

---@param distance number?
---@param recovering number?
---@return self
function TurretGun:setRecoil(distance, recovering)
    self.recoil = distance or self.recoil
    self.recoilRecover = recovering or self.recoilRecover

    return self
end

---@param cap number
---@return self
function TurretGun:setHeatCapacity(cap)
    self.heatCapacity = cap
    return self
end

function TurretGun:update(delta)
    local coolingMultiplier = 1

    if self.overheat then
        coolingMultiplier = 5
    end

    self.heat = math.max(self.heat - self.cooling * delta * coolingMultiplier, 0)
    
    local heatMul = (self.heat / self.heatCapacity) * 0.5

    self.shader:send("color", {
        heatMul * 2,
        heatMul * 0.2,
        heatMul * 0.1,
        0
    })

    self.x = math.lerp(self.x, 0.2, self.recoilRecover * delta)
    
    if self.heat == 0 then
        self.overheat = false
    end

    self:updateCallback(delta)
end

function TurretGun:fire()
    if not self:canFire() then
        return
    end

    self.x = self.recoil
    self.fireSound:stop()
    self.fireSound:play()

    self:fireCallback()

    self.lastFire = self:getTime()
    self.heat = math.min(self.heat + 1, self.heatCapacity)

    if self.heat >= self.heatCapacity then
        self.overheat = true
        self.turret.overheatSound:stop()
        self.turret.overheatSound:play()
        self:emitEvent("overheat")
    end
end

---@param callback function
---@return self
function TurretGun:onFire(callback)
   self.fireCallback = callback
   return self
end

---@param callback function
---@return self
function TurretGun:onUpdate(callback)
    self.updateCallback = callback
    return self
end

function TurretGun:updateCallback(delta) end
function TurretGun:fireCallback() end

return TurretGun
