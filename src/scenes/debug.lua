local Scene = require("src.lib.Scene")
local utils = require("lib.utils")
local data = require("data")

---@class DebugScene: Scene
local DebugScene = Scene:new()
DebugScene:_appendClass("DebugScene")

local console = require("src.lib.Console"):new()

function DebugScene:load()
    console:print("Debug scene")
    console:print("Game version:", data.version)
    console:print("Platform:", utils.system.getPlatform())
end

function DebugScene:draw(screen)
    console:draw()
end

function DebugScene:update(delta)
    
end



return DebugScene