local data = require("data")
local utils = require("lib.utils")

---@class Main
local main = {
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

--== Main functions ==--

---@param scene Scene
function main.loadScene(scene)
    assert(scene, "Scene is nil")

    local tp = type(scene)
    assert(tp == "table", "Not a table. Type: " .. tp)

    scene = scene:new()

    scene.main = main
    currentScene = scene
    scene:load()
end

---@param sceneName string
function main.loadSceneByName(sceneName)
    local s = main.scenes[sceneName]
    assert(s, "Scene '" .. tostring(sceneName) .. "' does not exist")
    main.loadScene(s)
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
    print(utils.table.tostring(utils.config.getFlagDictionary()))
    main.loadScene(scenes.game)
end

function love.draw(screen)
    local w, h = love.graphics.getDimensions(screen)
    --local ratio = math.min(w / data.width, h / data.height)

    local sX = w / data.width
    local sY = h / data.height

    local drawData = {
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