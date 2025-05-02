local Color = require("lib.Color")
local Node2D = require("lib.2d.Node2d")
local Entity = require("scenes.game.Entity")

---@class Turret: Entity
local TurretShield = Node2D:new()
TurretShield:_appendClass("TurretShield")

TurretShield.segments = 25   ---@type integer
TurretShield.distance = 0.15 ---@type number

local segmentColor = Color:new(0.5, 0.8, 1)

function TurretShield:ready()
    local step = (2 * math.pi) / self.segments

    for i = 1, self.segments do
        local seg = Entity:new()
        seg:_appendClass("TurretShieldSegment")

        seg:initHp(2)
        seg:setScaleAll(0.2)
        
        seg.enableShadow = false
        seg:loadTextureFromFile("scenes/game/projectiles/bullet/bullet.png")

        local angle = step * (i - 1)

        seg.rotation = seg:rotationTo(0, 0)
        seg.color = segmentColor


        local time = 0
        local distance = self.distance

        function seg:update(delta)
            self.rotation = math.rotationTo(self.x, self.y, 0, 0) + 90

            local distanceScale = math.abs(math.sin(time)) + 0.1
            seg.x = distance * distanceScale * math.cos(angle)
            seg.y = distance * distanceScale * math.sin(angle) * 1.7

            time = time + delta

            if time >= 30 then
                seg:destroy()
            end
        end

        self:addChild(seg)
    end
end

function TurretShield:update(delta)
    self:rotate(100 * delta)
end

return TurretShield