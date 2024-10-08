local Color = require("lib.Color")
local Node2D = require("lib.2d.Node2d")
local Entity = require("scenes.game.Entity")

---@class Turret: Entity
local TurretShield = Node2D:new()

TurretShield.segments = 32   ---@type integer
TurretShield.distance = 0.15 ---@type number

function TurretShield:ready()
    local step = (2 * math.pi) / self.segments

    for i = 1, self.segments do
        local seg = Entity:new()

        seg:initHp(2)
        seg:setScaleAll(0.2)
        
        seg.enableShadow = false
        seg:loadTextureFromFile("scenes/game/projectiles/bullet/bullet.png")

        local angle = step * (i - 1)

        seg.x = self.distance * math.cos(angle)
        seg.y = self.distance * math.sin(angle) * 1.7
        seg.rotation = seg:rotationTo(0, 0)

        function seg:update(delta)
            seg:rotate(100 * delta)
        end

        self:addChild(seg)
    end
end

function TurretShield:update(delta)
    self:rotate(100 * delta)
end

return TurretShield