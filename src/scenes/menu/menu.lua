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

---@param x number
---@param y number
---@param size number
---@param rotDir number
function MenuScene:addGear(x, y, size, rotDir)
    local g = Sprite:new()

    g:loadTextureFromFile("scenes/game/gear.png")
    g:setScaleAll(size)

    g.x = x
    g.y = y

    local c = math.randomf(0.7, 0.9)

    g.color = Color:new(0.8 * c, 0.6 * c, 0)

    function g:update(delta)
        g:rotate(rotDir * 10 * delta)
    end

    self:addChild(g)
end

function MenuScene:load()
    --== Gears ==--
    
    self:addGear(0, 0, 1, 1)
    self:addGear(0.2, 1, 0.7, -1)
    self:addGear(0.7, 0.1, 0.5, 1)
    self:addGear(1, 1, 1.2, -1)
    
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

function MenuScene:unload()
    music:stop()
end

function MenuScene:draw(screen)
    love.graphics.clear(0.2, 0.1, 0.1)
end

return MenuScene