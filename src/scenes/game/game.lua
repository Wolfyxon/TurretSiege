local utils = require("lib.utils")
local scene = require("lib.scene"):new()
local turret = nil

local circles = 10
local circleRot = 0

---@param projectile Projectile
local function spawnProjectile(projectile)
    local min = 0.8
    local max = 1.5

    projectile.x = utils.math.random(min, max)
    projectile.y = utils.math.random(min, max)
    
    projectile.rotation = projectile:rotationTo(0.5, 0.5)
end

function scene:load()
    turret = require("scenes.game.turret.turret"):new()
    scene:addChild(turret)
end

function scene:unload()
    turret = nil
end

function scene:draw(screen)
    local sW, sH = love.graphics.getDimensions(screen)
    local ratio = math.min(sW, sH)

    if not screen or screen == "left" then
        
    end

    if not screen or screen == "bottom" then
        --love.graphics.setBackgroundColor(0.6, 0.5, 0)


        for i = 1, circles do
            love.graphics.push()
            love.graphics.origin()
            love.graphics.translate(sW / 2, sH / 2)
            local dir = (-1) ^ i
            
            love.graphics.rotate(circleRot * dir)

            local c = i / circles
            if dir == -1 then
                c = c * 0.8
            end
            love.graphics.setColor(0.6 * c, 0.5 * c, 0, 1)
            love.graphics.circle("fill", 0 , 0, (circles - i) * 0.25 * ratio, 6)

            love.graphics.pop()
        end
        
    end 
end

function scene:update(delta)
    circleRot = circleRot + delta * 0.2
end

return scene