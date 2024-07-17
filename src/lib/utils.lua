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

return utils