local utils = require("lib.utils")

local tests = {}

function tests.replace()
    assert(utils.string.replace("Hello World", "Hello", "") == " World")
    assert(utils.string.replace("a%b", "%", "") == "ab")
    
end

function RunUnitTests()
    print("------ Running unit tests ------")

    for name, func in pairs(tests) do
        local start = os.clock()
        local suc, res = pcall(func)
        local finish = os.clock()

        local timeStr = tostring(finish - start) .. " CPU s"

        if suc then
            print(name, "Ok", timeStr)
        else
            print(name, "FAIL: " .. res, timeStr)
        end

    end

    print("-------------------------------")
    os.exit()
end
