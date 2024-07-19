local utils = {
    table = {},
    math = {}
}
local data = require("data")

--== Table ==--
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

function utils.table.keys(table)
    local res = {}

    for k, v in pairs(table) do
        table.insert(res, k)
    end

    return res
end

function utils.table.find(table, value)
    for i,v in ipairs(table) do
        if v == value then
            return i
        end
    end
end

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

function utils.math.lerp(start, target, speed)
    if speed >= 1 then return target end;
    return (1 - speed) * start + speed * target;
end

function utils.math.lerpAngle(start, target, speed)
    if speed >= 1 then return target end;

    start = math.rad(start);
    target = math.rad(target);

    local TAU = math.pi * 2;
    local diff = math.fmod(target - start, TAU);
    local shortest = math.fmod(2 * diff, TAU) - diff;
    return math.deg(start + shortest * speed);
end

function utils.math.rotationTo(x1, y1, x2, y2)
    local dX = x2 - x1
    local dY = y2 - y1
    return math.deg(math.atan2(dY, dX)) -- NOTE: Docs claim that atan2 can be replaced with atan, but it doesn't work properly
                                        -- TODO: Find a solution
end

--== Other ==--

function utils.getMousePos(screen)
    local w, h = love.graphics.getDimensions(screen)
    
    local mX, mY = love.mouse.getPosition()

    local x = mX / w
    local y = mY / h

    return x, y
end


return utils