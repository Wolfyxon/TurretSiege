local main = {
    version = "1.0",
    frameCount = 0,

    width = 400,
    height = 240
}

local scenes = {
    game = require("scenes.game.game"),
    menu = require("scenes.menu.menu"),
    debug = require("scenes.debug")
}
main.scenes = scenes

local currentScene = nil

--== Main functions ==--

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
    love.window.setMode(main.width, main.height, {resizable = true})

    main.loadScene(scenes.game)
end

function love.draw(screen)
    local w, h = love.graphics.getDimensions(screen)
    local ratio = math.min(w / main.width, h / main.height)

    local data = {
        w = main.width,
        h = main.height,
        scaleX = ratio,
        scaleY = ratio,
    }

    love.graphics.scale(ratio, ratio)

    if currentScene then
        currentScene:drawRequest(screen, data)
    end
end

function love.update(delta)
    main.frameCount = main.frameCount + 1

    if currentScene then
        currentScene:updateRequest(delta)
    end
end