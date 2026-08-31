-- NOTE: conf.lua runs before main.lua


------========== Util imports ==============-----
-- (I would use a for loop but Intelisense is too stupid)

local utils = require("lib.utils")
local gameData = require("gameData")

require("lib.utils.oop")

function warn(...)
    print("[Warning] " .. table.concat({...}, " "))

    local traceback = debug.traceback():split("\n")
    local rmStart = 3
    local rmEnd = 6

    for i = 1, rmStart do
        table.remove(traceback, 1)
    end

    for i = 1, rmEnd do
        table.remove(traceback, #traceback)
    end
    
    print(table.concat(traceback, "\n"))
end

--== Table ==--
table.keys = utils.table.keys
table.find = utils.table.find
table.has = utils.table.has
table.random = utils.table.random
table.tostring = utils.table.tostring
table.copy = utils.table.copy
table.erase = utils.table.erase
table.merge = utils.table.merge

--== String ==--
string.multiSplit = utils.string.multiSplit
string.startsWith = utils.string.startsWith
string.endsWith = utils.string.startsWith
string.split = utils.string.split
string.replace = utils.string.replace

--== Math ==--
math.randomf = utils.math.randomf
math.clamp = utils.math.clamp
math.lerp = utils.math.lerp
math.lerpAngle = utils.math.lerpAngle
math.rotationTo = utils.math.rotationTo
math.distanceTo = utils.math.distanceTo
math.rotateDirection = utils.math.rotateDirection

-------=========== Other setup ===============---------

local function printHelp()
    print("Usage: TurretSiege [OPTIONS...]")
    print("")
    print("Options")
    print(" --help:                 Show this help")
    print(" --version:              Show game version")
    print(" --scene=<scene name>:   Start game in a specific scene")
    
    print("")
end

local function handleArgs()
    local flags = utils.config.getFlagDictionary()

    if flags.help then
        printHelp()
        os.exit()
    end

    if flags.version then
        print("TurretSiege " .. gameData.version)
        os.exit()
    end
end

math.randomseed(-os.clock(), os.clock())
handleArgs()
