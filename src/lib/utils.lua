local utils = {
    table = {},
    math = {}
}
local data = require("data")

--== Table ==--
---@return table
function utils.table.merge(...)
    local current = {}

    for i, tbl in ipairs({...}) do
        for k, v in pairs(tbl) do
            if not current[k] then
                current[k] = v
            end
        end
    end

    return current
end

---@return any[]
function utils.table.keys(table)
    local res = {}

    for k, v in pairs(table) do
        table.insert(res, k)
    end

    return res
end

---@param table any[]
---@param value any
---@return integer|nil
function utils.table.find(table, value)
    for i,v in ipairs(table) do
        if v == value then
            return i
        end
    end
end

---@param table table
---@return string
function utils.table.tostring(table)
    if type(table) ~= "table" then
        return tostring(table)
    end

    local res = "{"

    for k, v in pairs(table) do
        res = res .. " " .. utils.table.tostring(k) .. " = " .. utils.table.tostring(v) .. " "
    end

    return res .. "}"
end

--== Math ==--

---@param start number
---@param target number
---@param speed number
---@return number
function utils.math.lerp(start, target, speed)
    if speed >= 1 then return target end;
    return (1 - speed) * start + speed * target;
end

---@param start number
---@param target number
---@param speed number
---@return number
function utils.math.lerpAngle(start, target, speed)
    if speed >= 1 then return target end;

    start = math.rad(start);
    target = math.rad(target);

    local TAU = math.pi * 2;
    local diff = math.fmod(target - start, TAU);
    local shortest = math.fmod(2 * diff, TAU) - diff;
    return math.deg(start + shortest * speed);
end

---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number
function utils.math.rotationTo(x1, y1, x2, y2)
    local dX = x2 - x1
    local dY = y2 - y1
    return math.deg(math.atan2(dY, dX)) -- NOTE: Docs claim that atan2 can be replaced with atan, but it doesn't work properly
                                        -- TODO: Find a solution
end

---@param px number
---@param py number
---@param cx number
---@param cy number
---@param angle number
---@return number, number
function utils.math.rotatePoint(px, py, cx, cy, angle)
    angle = math.rad(angle)

    local cosTheta = math.cos(angle)
    local sinTheta = math.sin(angle)
    local dx = px - cx
    local dy = py - cy

    local x = cosTheta * dx - sinTheta * dy + cx
    local y = sinTheta * dx + cosTheta * dy + cy
    
    return x, y
end

---@param min number
---@param max number
---@return number
function utils.math.random(min, max)
    return min + max * (math.random(0, 100) / 100)
end

--== Other ==--

---@param screen nil|"left"|"bottom"
---@return number, number
function utils.getMousePos(screen)
    local w, h = love.graphics.getDimensions(screen)
    
    local mX, mY = love.mouse.getPosition()

    local x = mX / w
    local y = mY / h

    return x, y
end


return utils