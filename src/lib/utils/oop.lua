local utils = require("lib.utils")

---@class Object
Object = {
    classList = {"Object"}, ---@type string[]
    super = nil              ---@type {}
}

function Object:new()
    return initClass(self)
end

---@return string
function Object:getClass()
    return self.classList[#self.classList]
end

function Object:init() end

-------------------------------------------------

---@param name string
---@param baseTable? {}
function class(name, baseTable)
    baseTable = baseTable or Object

    local ins = {}
    setmetatable(ins, { __index = baseTable })

    ins.__index = ins
    ins.classList = utils.table.copy(ins.classList)
    table.insert(ins.classList, name)

    if baseTable ~= Object then
        ins.super = baseTable
    end

    return ins
end

---@param classTable {}
---@param body {}
function initClass(classTable, body)
    local ins = setmetatable(body or {}, {
        __index = classTable,
        __add = classTable.__add,
        __sub = classTable.__sub,
        __mul = classTable.__mul,
        __div = classTable.__div
    })

    ins:init()
    
    return ins
end
