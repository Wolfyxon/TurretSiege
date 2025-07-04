local Node2D = require("lib.2d.Node2d")
local Label = require("lib.2d.gui.Label")

---@class DebugMenu: Node2D
local DebugMenu = class("DebugMenu", Node2D)

DebugMenu.label = nil ---@type Label

local mem = 0

function DebugMenu:ready()
    local dm = self
    
    main.onEvent("keypressed", function(key)
        if key == "f3" then
            dm.visible = not dm.visible
        end
    end)

    self:createTimer()
        :setWait(0.5)
        :setLoop(true)
        :onEnd(function()
            mem = collectgarbage("count")
        end)
        :start()

    self.visible = false
    self.label = self:addChild(
        Label:new()
        :setPosition(0.5, 0.9)
        :setText("loading info...")
    )
end

function DebugMenu:update(delta)
    if not self.visible then
        return
    end

    local info = {}
    
    local function add(label, value)
         table.insert(info, label .. ": " .. tostring(value))
    end

    add("FPS", love.timer.getFPS())
    add("Mem", string.format("%.2f MB", mem / 1024))
    
    self.label:setText(table.concat(info, " | "))
end

return DebugMenu