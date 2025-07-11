local gameData = require("gameData")
local utils = require("lib.utils")
local assets = require("assets")

local Color = require("lib.Color")
local Sprite = require("lib.2d.Sprite")
local DebugMenu = require("debugMenu")

---@class Main
main = {
    frameCount = 0,
    activeTime = 0,
    pausedTime = 0,
    musicPos = 0
}

local currentScene = nil ---@type Scene?
local debugMenu = DebugMenu:new()
local paused = false

local events = {
    -- Input --
    mousepressed = {},
    keypressed = {},
    -- Pause --
    pauseChanged = {},
    paused = {},
    unpaused = {}
}

--== Private main functions ==--

local function emitEvent(name, ...)
    local callbacks = events[name]
    assert(callbacks, "Unknown event: " .. name)

    for i, v in ipairs(callbacks) do
        v(...)
    end
end

--== Main functions ==--

---@param state boolean
function main.setPause(state)
    if paused ~= state then
        emitEvent("pauseChanged", state)

        if paused then
            emitEvent("paused")
        else
            emitEvent("unpaused")
        end
    end
    
    paused = state
end

---@return boolean
function main.isPaused()
    return paused
end

---@param name string
---@param callback function
---@return integer
function main.onEvent(name, callback)
    local callbacks = events[name]
    assert(callbacks, "Unknown event: " .. name)

    table.insert(callbacks, callback)
    return #callbacks
end

---@param name string
---@param index integer
function main.disconnectEvent(name, index)
    local callbacks = events[name]
    assert(callbacks, "Unknown event: " .. name)

    table.remove(callbacks, index)
end

---@param scene Scene
function main.loadScene(scene)
    assert(scene, "Scene is nil")

    local tp = type(scene)
    assert(tp == "table", "Not a table. Type: " .. tp)

    if currentScene then
        currentScene:unload()
        currentScene:destroy()
    end

    scene = scene:new()

    currentScene = scene
    scene:load()
end

---@return Scene?
function main.getCurrentScene()
    return currentScene
end

---@param sceneName string
function main.loadSceneByName(sceneName)
    local path = "scenes/" .. sceneName .. "/" .. sceneName .. ".lua"

    print("-> Loading scene: ", sceneName)    
    local moduleFunc, err = love.filesystem.load(path)
    
    main.loadScene(moduleFunc())
end

function main.addGears(parent)
    local gearCount = 20
    local res = {}

    for i = 1, gearCount do
        if i > 11 then
         local gear = Sprite:new("assets/img/gear.png")
         local dir = (-1) ^ i
         local s = ((gearCount - i) / gearCount) * 5
         
         local c = i / gearCount
         if dir == -1 then
             c = c * 0.8
         end
         
         gear.color = Color:new(0.8 * c, 0.6 * c, 0)
         gear.enableShadow = true
         gear.shadowOpaticy = 0.25
         gear.x = 0.5
         gear.y = 0.5
         gear.scaleX = s
         gear.scaleY = s
         
         parent:addChild(gear)
         table.insert(res, gear)
        end
     end

     return res
end

--== Love2D function overrides ==--

function love.load()
    print("==================================================================")
    print("TurretSiege by Wolfyxon")
    print("Licensed under GPL-2.0")
    print("Made with Love2D")
    print("https://github.com/Wolfyxon/TurretSiege/")
    print(" ")
    print("Platform:", utils.system.getPlatform())
    print("Game version:", utils.version.getTuple())
    print("Love2D version:", love.getVersion())
    print("==================================================================")

    love.window.setTitle("Turret Siege")
    
    love.window.setFullscreen(true)

    local sw, sh = love.graphics.getDimensions()

    love.window.setFullscreen(false)
    

    love.window.setMode(
        math.min(gameData.width * gameData.windowSizeMultiplier, sw),
        math.min(gameData.height * gameData.windowSizeMultiplier, sh),
        
        {
            resizable = true
        }
    )
    
    debugMenu:ready()
    main.loadSceneByName(utils.config.getFlagDictionary().scene)
end

function love.draw(screen)
    local w, h = love.graphics.getDimensions(screen)

    local sX = w / gameData.width
    local sY = h / gameData.height
    
    love.graphics.scale(sX, sY)

    if currentScene then
        currentScene:drawRequest()
    end

    debugMenu:drawRequest()
end

function love.update(delta)
    main.frameCount = main.frameCount + 1
    
    if paused then
        main.pausedTime = main.pausedTime + delta
    else
        main.activeTime = main.activeTime + delta
    end

    if currentScene then
        currentScene:updateRequest(delta)
    end

    debugMenu:updateRequest(delta)
end

function love.mousepressed(x, y, button, isTouch, presses)
    emitEvent("mousepressed", x, y, button, isTouch, presses)
end

function love.keypressed(key, scanCode, isRepeat)
    emitEvent("keypressed", key, scanCode, isRepeat)

    if key == "f11" then
        love.window.setFullscreen(not love.window.getFullscreen())
    end
end