local data = require("data")

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

---@type Scene|nil
local currentScene = nil

--== Main functions ==--

---@param scene Scene
function main.loadScene(scene)
    assert(scene, "Scene is nil")

    local tp = type(scene)
    assert(tp == "table", "Not a table. Type: " .. tp)

    scene.main = main
    currentScene = scene
    scene:load()
end

--== Love2D function overrides ==--

function love.load()
    love.window.setTitle("Turret Siege")
    love.window.setMode(data.width, data.height, {resizable = true})

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