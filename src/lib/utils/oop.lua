local utils = require("lib.utils")

---@class Object
Object = {
    classList = {"Object"}, ---@type string[]
    super = nil             ---@type Object?
}


---@generic T: Object
---@param self T
---@return T
function Object:new()
    return initClass(self)
end

---@return string
function Object:getClass()
    return self.classList[#self.classList]
end

---@generic T: Object
---@param property string
---@param value any
---@return T
function Object:set(property, value)
    self[property] = value
    return self
end

---@param class string
---@param exact? boolean
---@return boolean
function Object:isA(class, exact)
    if exact then
        return self:getClass() == class
    end

    return table.has(self.classList, class)
end

function Object:init() end

function Object:__tostring()
    local temp = {}
    setmetatable(temp, {
        index = self,
        __tostring = nil
    })

    return string.format("[%s %s]", self:getClass(), temp)
end

---@return boolean
function Object.isObject(val)
    return (
        type(val) == "table" and
        type(val.classList) == "table" and
        table.find(val, "Object") ~= nil
    )
end

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
        __tostring = classTable.__tostring or classTable.toString,
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
