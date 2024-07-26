local utils = require("lib.utils")

local Color = require("lib.color")
local Sprite = require("lib.2d.sprite")
local Turret = require("scenes.game.turret.turret")
local Scene = require("lib.scene")

---@class GameScene: Scene
local GameScene = Scene:new()
GameScene:_appendClass("GameScene")

GameScene.turret = nil                ---@type Turret
GameScene.projectileSpawnDelay = 1    ---@type number
GameScene.lastProjectileSpawnTime = 2 ---@type number
GameScene.projectilesDestroyed = 0    ---@type integer
GameScene.level = 1                   ---@type integer

local music = love.audio.newSource("scenes/game/music.ogg", "stream")

local gears = {} ---@type Sprite[]

local projectiles = {
    {
        require("scenes.game.projectiles.axe.axe"),
        require("scenes.game.projectiles.cannonBall.cannonBall")
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
    local gearCount = 20
    for i = 1,gearCount do
        local gear = Sprite:new({}, "scenes/game/gear.png")
        local dir = (-1) ^ i
        local s = ((gearCount - i) / gearCount) * 5
        
        local c = i / gearCount
        if dir == -1 then
            c = c * 0.8
        end
        
        gear.shadowOpaticy = 0.25
        gear.x = 0.5
        gear.y = 0.5
        gear.scaleX = s
        gear.scaleY = s
        
        gear.color = Color:new(0.6 * c, 0.5 * c, 0)
        

        table.insert(gears, gear)
        self:addChild(gear)
    end

    self.turret = Turret:new()
    self:addChild(self.turret)

    --music:play()
end

function GameScene:unload()
    self.turret = nil
    music:stop()
end

function GameScene:draw(screen)
    love.graphics.clear(0.2, 0.1, 0.1)
end

function GameScene:update(delta)
    for i, v in ipairs(gears) do
        local dir = (-1) ^ i

        v.rotation = v.rotation + dir * delta * 4
    end

    local now = love.timer.getTime()
    if now > self.lastProjectileSpawnTime + self.projectileSpawnDelay then
        self.lastProjectileSpawnTime = now
        
        local proj = utils.table.random(projectiles[self.level]):new()

        proj:onEvent("died", function ()
            self.projectilesDestroyed = self.projectilesDestroyed + 1
            print(self.projectilesDestroyed)
        end)
        
        self:spawnProjectile(proj)
    end
end

return GameScene