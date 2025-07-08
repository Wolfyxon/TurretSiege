local utils = require("lib.utils")

local Node = require("lib.Node")
local Node2D = require("lib.2d.Node2d")
local Color = require("lib.Color")
local Sprite = require("lib.2d.Sprite")
local Audio = require("lib.Audio")
local Turret = require("scenes.game.turret.turret")
local GameGui = require("scenes.game.gui.GameGui")
local DeathGui = require("scenes.game.gui.DeathGui")
local PauseGui = require("scenes.game.gui.PauseGui")
local Scene = require("lib.2d.Scene")

---@class GameScene: Scene
local GameScene = class("GameScene", Scene)

GameScene.music = nil                 ---@type Audio
GameScene.gears = {}                  ---@type Sprite[]
GameScene.projectiles = {}            ---@type table
GameScene.currentProjectiles = {}     ---@type table
GameScene.arena = nil                 ---@type Node2D
GameScene.gui = nil                   ---@type GameGui
GameScene.deathGui = nil              ---@type DeathGui
GameScene.pauseGui = nil              ---@type PauseGui
GameScene.turret = nil                ---@type Turret
GameScene.projectileSpawnDelay = 1    ---@type number
GameScene.lastProjectileSpawnTime = 2 ---@type number
GameScene.projectilesDestroyed = 0    ---@type integer
GameScene.level = 1                   ---@type integer

---@param projectile Projectile
function GameScene:registerProjectile(projectile)
    assert(projectile, "Projectile nil")
    assert(Node.isNode(projectile), "Projectile is not a Node")
    assert(projectile:isA("Projectile"), "Projecile is not of the Projectile class")

    self.projectiles[projectile.level] = self.projectiles[projectile.level] or {}

    table.insert(self.projectiles[projectile.level], utils.table.occurrenceWrap(projectile, projectile.commonity))
end

---@param projectile Projectile
function GameScene:spawnProjectile(projectile)
    local min = 0
    local max = 1

    local x = 0
    local y = 0

    local side = math.random(1, 4)

    local function r()
        return math.randomf(min, max)
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
    
    projectile.rotation = projectile:rotationTo(0.5, 0.5) + projectile.rotationOffset
    projectile.originalRotation = projectile.rotation

    self.arena:addChild(projectile)
end

function GameScene:load()
    self.lastProjectileSpawnTime = self:getTime()

    local projectileList = {
        require("scenes.game.projectiles.powerUps.health"),
        
        require("scenes.game.projectiles.level1.axe.axe"),
        require("scenes.game.projectiles.level1.cannonBall.cannonBall"),

        require("scenes.game.projectiles.level2.smallRocket.smallRocket"),
        require("scenes.game.projectiles.level2.shuriken.shuriken"),
    }

    for i, v in ipairs(projectileList) do
        self:registerProjectile(v)
    end
    

    self.arena = Node2D:new()

    self.music = Audio:new():loadFromFile("scenes/game/music.ogg"):setLoop(true):play()
    self.music:setPlayTime(main.musicPos)
    self:addChild(self.music)

    for i, v in ipairs(main.addGears(self)) do
        local dir = (-1) ^ i

        function v:update(delta)
            v:rotate(dir * delta * 4)
        end
    end

    self.turret = Turret:new()
    self.turret:onEvent("died", function ()
        self:gameOver()
    end)
    self.arena:addChild(self.turret)
    
    self.arena.screen = "bottom"
    self:addChild(self.arena)

    self.gui = GameGui:new()
    self:addChild(self.gui)

    self.deathGui = DeathGui:new()
    self:addChild(self.deathGui)
    
    self.pauseGui = PauseGui:new()
    self:addChild(self.pauseGui)

    self:updateProjectileList()
end

function GameScene:unload()
    self.turret = nil
    self.gui = nil
end

function GameScene:draw()
    love.graphics.clear(0.2, 0.1, 0.1)
end

function GameScene:update(delta)
    local now = self:getTime()
    
    if self.turret:isAlive() and now > self.lastProjectileSpawnTime + self.projectileSpawnDelay then
        self.lastProjectileSpawnTime = now
        
        local proj = utils.table.randomByOccurrence(self.currentProjectiles)

        if not proj then
            warn("nil projectile selected!") 
            return 
        end

        if not Node.isNode(proj) then
            warn("Projectile is not a Node! \n", table.tostring(proj, 3))
            return
        end

        proj = proj:new()
        
        proj:onEvent("died", function ()
            self.projectilesDestroyed = self.projectilesDestroyed + 1

            if self.projectilesDestroyed % (8 * self.level) == 0 then
                self:levelUp()
            end
        end)
        
        self:spawnProjectile(proj)
    end
end

function GameScene:updateProjectileList()
    local projectiles = {}

    for i = 1, self.level do
        local projs = self.projectiles[i]

        if projs then
            for ii, v in ipairs(projs) do
                table.insert(projectiles, v)
            end
        end
    end

    self.currentProjectiles = projectiles
end

function GameScene:levelUp()
    self.level = self.level + 1
    
    if self.level % 2 == 0 then
        self.projectileSpawnDelay = self.projectileSpawnDelay - 0.025
    end

    if self.level % 4 == 0 then
        self.turret.fireCooldown = self.turret.fireCooldown * 0.9
    end

    self.gui.levelLabel:setText("Level " .. tostring(self.level))
    self.gui.levelLabel.color = Color.GREEN:clone()

    self:updateProjectileList()
end

function GameScene:gameOver()
    for i, v in ipairs(self.arena:getChildrenOfClass("Projectile")) do
        v:destroy()
    end

    self.gui.healthDisplay.visible = false
    self.deathGui:show()

    main.musicPos = self.music:getPlayTime()
    self.music:stop()
end

return GameScene