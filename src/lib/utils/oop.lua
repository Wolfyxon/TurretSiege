local utils = require("lib.utils")

---@class Object
Object = {
    _classList = {"Object"}, ---@type string[]
    super = nil              ---@type {}
}

function Object:new()
    local ins = setmetatable({}, self)
    ins:init()
    
    return ins
end

---@return string
function Object:getClass()
    return self._classList[#self._classList]
end

function Object:init() end

-------------------------------------------------

---@param name string
---@param table {}
---@param baseTable? {}
function class(name, baseTable)
    baseTable = baseTable or Object

    local ins = {}
    setmetatable(ins, { __index = baseTable })

    ins.__index = ins
    ins._classList = utils.table.copy(ins._classList)
    table.insert(ins._classList, name)

    if baseTable ~= Object then
        ins.super = baseTable
    end

    return ins
end

function initClass(table)
    local ins = setmetatable({}, table)

    ins:init()

    return ins
end

local TestClass = class("Test")

function TestClass:new()
    print("new test")
    return initClass(self)
end

function TestClass:init()
    print("THE INIT")
end

function TestClass:hi()
    print("hello", self.a)
    self.a = "b"
end

---@class Test: Object
local test1 = TestClass:new()
test1:hi()

---@class Test: Object
local test2 = TestClass:new()

test2:hi()


--os.exit()