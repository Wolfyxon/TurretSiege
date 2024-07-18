local utils = {}

function utils.merge(...)
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

function utils.keys(table)
    local res = {}

    for k, v in pairs(table) do
        table.insert(res, k)
    end

    return res
end

function utils.strTable(table)
    if type(table) ~= "table" then
        return tostring(table)
    end

    local res = "{"

    for k, v in pairs(table) do
        res = res .. " " .. utils.strTable(k) .. " = " .. utils.strTable(v) .. " "
    end

    return res .. "}"
end

function utils.lerp(start, target, speed)
    if speed >= 1 then return target end;
    return (1 - speed) * start + speed * target;
end

function utils.rotationTo(x1, y1, x2, y2)
    local dX = x2 - x1
    local dY = y2 - y1
    return math.deg(math.atan(dX, dY))
end

return utils