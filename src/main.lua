local data = require("data")
local utils = require("lib.utils")

---@class Main
main = {
    frameCount = 0,
}


---@type {string: Scene}
local scenes = {
    game = require("scenes.game.game"),
    menu = require("scenes.menu.menu"),
    debug = require("scenes.debug")
}
main.scenes = scenes

local currentScene = nil ---@type Scene|nil

local events = {
    mousepressed = {},
    keypressed = {}
}

--== Main functions ==--

---@param name string
---@param callback function
function main.onEvent(name, callback)
    local callbacks = events[name]
    assert(callbacks, "Unknown event: " .. name)

    table.insert(callbacks, callback)
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

---@param sceneName string
function main.loadSceneByName(sceneName)
    local s = main.scenes[sceneName]
    assert(s, "Scene '" .. tostring(sceneName) .. "' does not exist")
    main.loadScene(s)
end

--== Private main functions ==--

local function emitEvent(name, ...)
    local callbacks = events[name]
    assert(callbacks, "Unknown event: " .. name)

    for i, v in ipairs(callbacks) do
        v(...)
    end
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
    print("Game version:", data.version)
    print("Love2D version:", love.getVersion())
    print("LovePotion version:", love.__potion_version)
    print("==================================================================")

    love.window.setTitle("Turret Siege")
    love.window.setMode(data.width, data.height, {resizable = true})
    
    main.loadSceneByName(utils.config.getFlagDictionary().scene)
end

function love.draw(screen)
    local w, h = love.graphics.getDimensions(screen)
    --local ratio = math.min(w / data.width, h / data.height)

    local sX = w / data.width
    local sY = h / data.height

    local drawData = {
        wW = w,
        wH = h,
        w = data.width,
        h = data.height,
        scaleX = sX,
        scaleY = sY,
    }

    love.graphics.scale(sX, sY)

    if currentScene then
        currentScene:drawRequest(screen, drawData)
    end
end

function love.update(delta)
    main.frameCount = main.frameCount + 1

    if currentScene then
        currentScene:updateRequest(delta)
    end
end

function love.mousepressed(x, y, button, isTouch, presses)
    emitEvent("mousepressed", x, y, button, isTouch, presses)
end

function love.keypressed(key, scanCode, isRepeat)
    emitEvent("keypressed", key, scanCode, isRepeat)
end