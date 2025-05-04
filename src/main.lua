local data = require("data")
local utils = require("lib.utils")

local Color = require("lib.Color")
local Sprite = require("lib.2d.Sprite")

---@class Main
main = {
    frameCount = 0,
    activeTime = 0,
    pausedTime = 0
}


---@type {string: Scene}
local scenes = {
    game = require("scenes.game.game"),
    menu = require("scenes.menu.menu"),
    debug = require("scenes.debug")
}
main.scenes = scenes

local currentScene = nil ---@type Scene?
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
        currentScene:clearChildren()
        currentScene:unload()
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
    local s = main.scenes[sceneName]
    assert(s, "Scene '" .. tostring(sceneName) .. "' does not exist")

    print("-> Loading scene: ", sceneName)
    main.loadScene(s)
end

function main.addGears(parent)
    local gearCount = 20
    local res = {}

    for i = 1, gearCount do
        if i > 11 then
         local gear = Sprite:new({}, "scenes/game/gear.png")
         local dir = (-1) ^ i
         local s = ((gearCount - i) / gearCount) * 5
         
         local c = i / gearCount
         if dir == -1 then
             c = c * 0.8
         end
         
         gear.color = Color:new(0.8 * c, 0.6 * c, 0)
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
    print("Made with Love2D and LovePotion on Nintendo consoles")
    print("https://github.com/Wolfyxon/TurretSiege/")
    print(" ")
    print("Platform:", utils.system.getPlatform())
    print("Game version:", utils.version.getTuple())
    print("Love2D version:", love.getVersion())
    print("==================================================================")

    love.window.setTitle("Turret Siege")
    love.window.setMode(data.width * data.windowSizeMultiplier, data.height * data.windowSizeMultiplier, {resizable = true})
    
    main.loadSceneByName(utils.config.getFlagDictionary().scene)
end

function love.draw(screen)
    local drawData = utils.system.getDrawData(screen)
    
    love.graphics.scale(drawData.scaleX, drawData.scaleY)
    --love.graphics.translate(drawData.offsetX, drawData.offsetY)

    if currentScene then
        currentScene:drawRequest(screen, drawData)
    end
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