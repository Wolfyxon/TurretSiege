-- NOTE: conf.lua runs before main.lua


------========== Util imports ==============-----
-- (I would use a for loop but Intelisense is too stupid)

local utils = require("lib.utils")
require("lib.utils.oop")

function warn(...)
    print("Warning:", ...)
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

math.randomseed(-os.clock(), os.clock()) -- this fixes random generator creating the same results on each run