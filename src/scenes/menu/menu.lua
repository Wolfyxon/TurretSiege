local Color = require("lib.Color")
local Button = require("lib.2d.gui.Button")
local Label = require("lib.2d.gui.Label")
local Sprite = require("lib.2d.Sprite")
local Audio = require("lib.Audio")
local ListContainer = require("lib.2d.gui.container.ListContainer")
local Scene = require("lib.2d.Scene")
local gameData = require("gameData")

---@class MenuScene: Scene
local MenuScene = Scene:new()
MenuScene.music = nil ---@type Audio


function MenuScene:load()
    main.musicPos = 0
    
    self.music = Audio:new():loadFromFile("scenes/menu/music.ogg"):setLoop(true):play()
    self:addChild(self.music)

    --== Gears ==--
    
    for i, gear in ipairs(main.addGears(self)) do
        local dir = (-1) ^ i
        local time = 0
        local targetRot = 0

        function gear:update(delta)
            gear.rotation = math.lerpAngle(gear.rotation, targetRot, delta * 3)
            time = time + delta
            
            -- 167 is the BPM of the menu soundtrack
            -- 120 is kinda close to the length but it's somehow perfect lol
            if time % (120 / 167) <= 0.05 then
                targetRot = targetRot + 5 * dir
            end
        end
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
    version:setText("v. " .. gameData.version)
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
        main.loadSceneByName("game")
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
end

function MenuScene:draw(screen)
    love.graphics.clear(0.2, 0.1, 0.1)
end

return MenuScene