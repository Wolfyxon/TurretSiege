local utils = require("lib.utils")

local Turret = require("scenes.game.turret.turret")
local Scene = require("lib.scene")

---@class GameScene: Scene
local GameScene = Scene:new()
GameScene:_appendClass("GameScene")

GameScene.turret = nil          ---@type Turret
GameScene.spawnFrameDelay = 100 ---@type number
GameScene.level = 1             ---@type integer

local circles = 10
local circleRot = 0

local projectiles = {
    {
        require("scenes.game.projectiles.axe.axe")
    }
}


---@param projectile Projectile
function GameScene:spawnProjectile(projectile)
    local min = 0
    local max = 1

    local x = 0
    local y = 0

    local side = math.random(1, 4)

    local function r()
        return utils.math.random(min, max)
    end

    if side == 1 then
        x = r()
        y = 0
    end

    if side == 2 then
        x = r()
        y = 1
    end

    if side == 3 then
        x = 0
        y = r()
    end

    if side == 4 then
        x = 1
        y = r()
    end

    projectile.x = x
    projectile.y = y
    
    projectile.rotation = projectile:rotationTo(0.5, 0.5)

    self:addChild(projectile)
end

function GameScene:load()
    self.turret = Turret:new()
    self:addChild(self.turret)
end

function GameScene:unload()
    self.turret = nil
end

function GameScene:draw(screen)
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

function GameScene:update(delta)
    circleRot = circleRot + delta * 0.2

    if self.main.frameCount % self.spawnFrameDelay == 0 then
        local proj = utils.table.random(projectiles[self.level]):new()
        self:spawnProjectile(proj)
    end
end

return GameScene