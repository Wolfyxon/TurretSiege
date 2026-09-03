local utils = require("lib.utils")
local DeathGui = require("scenes.game.gui.DeathGui")

local tests = {}

function tests.replace()
    assert(utils.string.replace("Hello World", "Hello", "") == " World")
    assert(utils.string.replace("a%b", "%", "") == "ab")
    
end

function tests.gameOverTextDuplicates()
    local list = DeathGui.randomTexts
    
    for i, v in ipairs(list) do
        for ii, vv in ipairs(list) do
            if i ~= ii and string.lower(v) == string.lower(vv) then
                error(("Duplicate %i %i: %s"):format(i, ii, v))
            end
        end
    end

end

function RunUnitTests()
    print("------ Running unit tests ------")

    for name, func in pairs(tests) do
        local start = os.clock()
        local suc, res = pcall(func)
        local finish = os.clock()

        local timeStr = tostring(finish - start) .. " CPU s"

        if suc then
            print(name, "Ok:", timeStr)
        else
            print(name, "FAIL:", timeStr)
            print(res)
        end
    end

    print("-------------------------------")
    os.exit()
end
