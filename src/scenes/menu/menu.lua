local Color = require("lib.Color")
local Button = require("lib.2d.gui.Button")
local Label = require("lib.2d.gui.Label")
local Sprite = require("lib.2d.Sprite")
local ListContainer = require("lib.2d.gui.container.ListContainer")
local Scene = require("lib.Scene")
local data = require("data")

---@class MenuScene: Scene
local MenuScene = Scene:new()

local music = love.audio.newSource("scenes/menu/music.ogg", "stream")

function MenuScene:load()
    --== Gears ==--

    local gearCount = 40
    for i = 1, gearCount do
        local g = Sprite:new()
        
        g:loadTextureFromFile("scenes/game/gear.png")
        g:setScaleAll(math.randomf(0.1, 0.3))

        local c = math.randomf(0.5, 0.9)
        local rot = math.randomf(-50, 50)

        g.color = Color:new(0.8 * c, 0.6 * c, 0)

        g.x = math.randomf(0, 1)
        g.y = math.randomf(0, 1)
        
        function g:update(delta)
            g:rotate(rot * delta)
        end

        self:addChild(g)
    end

    --== Title ==--

    local titleContainer = ListContainer:new()
    titleContainer.x = 0.5
    titleContainer.y = 0.3

    local title = Label:new()
    title:setText("Turret Siege")
    title:setFontSize(64)
    titleContainer:addChild(title)

    local version = Label:new()
    version.textAlign = "right"
    version:setText("v. " .. data.version)
    version:setFontSize(14)
    titleContainer:addChild(version)

    local author = Label:new()
    author:setText("by Wolfyxon")
    titleContainer:addChild(author)
    
    titleContainer:arrangeChildren()

    --== Buttons ==--

    local w = 0.5
    local h = 0.05
    local fontSize = 24

    local buttonContainer = ListContainer:new()
    buttonContainer.spacing = 0.01
    buttonContainer.x = 0.5
    buttonContainer.y = 0.5

    local btnPlay = Button:new()
    btnPlay.width = w
    btnPlay.height = h
    btnPlay:setFontSize(fontSize)
    btnPlay:setText("Play")
    buttonContainer:addChild(btnPlay)
    btnPlay:onEvent("pressed", function ()
        self.main.loadSceneByName("game")
    end)

    local btnQuit = Button:new()
    btnQuit.width = w
    btnQuit.height = h
    btnQuit:setFontSize(fontSize)
    btnQuit:setText("Quit")
    btnQuit:onEvent("pressed", function ()
        love.event.quit()
    end)
    buttonContainer:addChild(btnQuit)

    buttonContainer:arrangeChildren()

    self:addChild(titleContainer)
    self:addChild(buttonContainer)
    
    music:play()
end

function MenuScene:draw(screen)
    love.graphics.clear(0.2, 0.1, 0.1)
end

return MenuScene