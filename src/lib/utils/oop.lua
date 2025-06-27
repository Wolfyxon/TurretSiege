local utils = require("lib.utils")

---@class Object
Object = {
    classList = {"Object"}, ---@type string[]
    super = nil             ---@type Object?
}

---@return self
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
---@param baseTable Object?
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
---@param body {} | nil
function initClass(classTable, body)
    body = body or {}

    local ins = setmetatable(table.copy(body), {
        __index = classTable,
        __add = classTable.__add,
        __sub = classTable.__sub,
        __mul = classTable.__mul,
        __div = classTable.__div
    })

    local super = classTable.super

    while super do
        super.init(ins)

        super = super.super
    end

    ins:init()
    
    return ins
end
