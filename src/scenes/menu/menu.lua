local Button = require("lib.2d.gui.Button")
local ListContainer = require("lib.2d.gui.container.ListContainer")
local Scene = require("lib.Scene")

---@class MenuScene: Scene
local MenuScene = Scene:new()

function MenuScene:load()
    local buttonContainer = ListContainer:new()
    buttonContainer.spacing = 0.01
    buttonContainer.x = 0.5
    buttonContainer.y = 0.5

    local btnPlay = Button:new()
    btnPlay:setText("Play")
    buttonContainer:addChild(btnPlay)
    btnPlay:onEvent("pressed", function ()
        self.main.loadSceneByName("game")
    end)

    local btnQuit = Button:new()
    btnQuit:setText("Quit")
    btnQuit:onEvent("pressed", function ()
        love.event.quit()
    end)
    buttonContainer:addChild(btnQuit)

    buttonContainer:arrangeChildren()
    self:addChild(buttonContainer)
end

return MenuScene