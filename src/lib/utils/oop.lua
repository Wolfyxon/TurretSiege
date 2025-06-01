local utils = require("lib.utils")

---@class Object
Object = {
    classList = {"Object"}, ---@type string[]
    super = nil              ---@type {}
}

function Object:new()
    local ins = setmetatable({}, self)
    ins:init()
    
    return ins
end

---@return string
function Object:getClass()
    return self.classList[#self.classList]
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
    ins.classList = utils.table.copy(ins.classList)
    table.insert(ins.classList, name)

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
