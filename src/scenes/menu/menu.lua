local Color = require("lib.Color")
local Button = require("lib.2d.gui.Button")
local Label = require("lib.2d.gui.Label")
local Sprite = require("lib.2d.Sprite")
local Audio = require("lib.Audio")
local ListContainer = require("lib.2d.gui.container.ListContainer")
local Scene = require("lib.2d.Scene")
local data = require("data")

---@class MenuScene: Scene
local MenuScene = Scene:new()
MenuScene.music = nil ---@type Audio


function MenuScene:load()
    self.music = Audio:new():loadFromFile("scenes/menu/music.ogg"):play()
    self:addChild(self.music)

    --== Gears ==--
    
    local gearCount = 20
    for i = 1, gearCount do
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
        
        local targetRot = 0
        local time = 0

        function gear:update(delta)
            gear.rotation = math.lerpAngle(gear.rotation, targetRot, delta * 3)
            time = time + delta
            
            -- 167 is the BPM of the menu soundtrack
            -- 120 is kinda close to the length but it's somehow perfect lol
            if time % (120 / 167) <= 0.05 then
                targetRot = targetRot + 5 * dir
            end
        end
        
        self:addChild(gear)
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