local utils = {
    table = {},
    string = {},
    math = {},
    system = {},
    config = {}
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

function utils.table.erase(tab, value)
    for i, v in ipairs(tab) do
        if v == value then
            table.remove(tab, i)
            return
        end
    end
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
---@param value any
---@return boolean
function utils.table.has(table, value)
    return utils.table.find(table, value) ~= nil
end

---@param table table
---@return table
function utils.table.copy(table)
    local res = {}
    
    for k, v in pairs(table) do
        if type(v) == "table" then
            v = utils.table.copy(v)
        end
        
        res[k] = v
    end

    return res
end

---@param table any[]
---@return any
function utils.table.random(table)
    return table[math.random(1, #table)]
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

---@param value any
---@param comminity number
---@return {value: any, comminity: number}
function utils.table.occurenceWrap(value, comminity)
    return {
        value = value,
        comminity = comminity
    }
end

--== String ==--

---@param str string
---@param search string
---@return boolean
function utils.string.startsWith(str, search)
    return string.sub(str, 1, #search) == search
end

---@param str string
---@param search string
---@return boolean
function utils.string.endsWith(str, search)
    if #search > #str then
        return false
    end

    return string.sub(str, #str - #search + 1, #str) == search
end

---@param str string
---@param separator string
---@return string[]
function utils.string.split(str, separator)
    separator = separator or "%s"
    
    local res = {}

    for v in string.gmatch(str, "([^"..separator.."]+)") do
      table.insert(res, v)
    end

    return res
  end

---@param str string
---@return string
function utils.string.regexEscape(str)
    local s, _ = str:gsub("[%(%)%.%%%+%-%*%?%[%^%$%]]", "%%%1")
    return s
end

---@param str string
---@param search string
---@param replacement string
---@return string
function utils.string.replace(str, search, replacement)
    search = utils.string.regexEscape(search)
    replacement = replacement:gsub("%%", "%%%%")
    
    local s, _ = str:gsub(search, replacement)
    return s
end

---@return string
function utils.string.genUniqueId()
    local t = love.timer.getTime()
    local fps = love.timer.getFPS()
    local dt = love.timer.getDelta()
    local adt = love.timer.getAverageDelta()

    return 
           tostring(t) .. ":" 
        .. tostring(fps) .. ":" 
        .. tostring(dt) .. ":"
        .. tostring(adt) .. 
        "-" 
        .. tostring(t * fps * dt * adt) .. ":"
        .. tostring(t + fps + dt + adt) ..
        "-"
        .. tostring(math.randomf(0, 4096))
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

---@param x number
---@param y number
---@param deg number
function utils.math.rotateDirection(x, y, deg)
    local ang = math.rad(deg)
    local rx = x * math.cos(ang) - y * math.sin(ang)
    local ry = x * math.sin(ang) + y * math.cos(ang)
    
    return rx, ry
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
function utils.math.randomf(min, max)
    return min + max * (math.random(0, 100) / 100)
end

---@param value number
---@param min number
---@param max number
function utils.math.clamp(value, min, max)
    if value < min then
        return min
    end

    if value > max then
        return max
    end

    return value
end

--== System ==--

---@param screen nil|"left"|"bottom"
---@return number, number
function utils.system.getMousePos(screen)
    local w, h = love.graphics.getDimensions(screen)
    
    local mX, mY = 0, 0

    if love.mouse and love.mouse.isCursorSupported() then
        mX, mY = love.mouse.getPosition()
    else
        if love.touch then
            local touches = love.touch.getTouches()

            if touches and #touches ~= 0 then
                mX, mY = love.touch.getPosition(touches[1])
            end
        end
    end

    local x = mX / w
    local y = mY / h

    return x, y
end

---@return boolean
function utils.system.isMousePressed()
    if love.mouse then
        return love.mouse.isDown(1)
    end

    if love.touch then
        local touches = love.touch.getTouches()

        if touches and #touches ~= 0 then
            return love.touch.getPressure(touches[1]) ~= 0
        end
    end

    return false
end

---@return boolean
function utils.system.has2screens()
    local console = love._console
    if not console then return false end

    return console == "3DS" or console == "Wii U"
end

function utils.system.getPlatform()
    return love._console or love.system.getOS()
end

--== Config ==--

---@return string[]
function utils.config.getCommandLineFlags()
    local res = {}
    local prefix = "--"

    for i, v in ipairs(arg) do
        if utils.string.startsWith(v, prefix) then
            table.insert(res, utils.string.replace(v, prefix, ""))
        end
    end

    return res
end

---@return string[]
function utils.config.getFlags()
    local res = utils.table.copy(data.flags)

    for i, v in ipairs(utils.config.getCommandLineFlags()) do
        table.insert(res, v)
    end

    return res
end

---@return table
function utils.config.getFlagDictionary()
    local res = {}
    
    for i, v in ipairs(utils.config.getFlags()) do
        local split = utils.string.split(v, "=")
        local name = split[1]
        local value = split[2]

        res[name] = value
    end

    return res
end

---@return boolean
function utils.config.hasFlag(flag)
    for k, v in pairs(utils.config.getFlagDictionary()) do
        if k == flag then
            return true
        end 
    end
    
    return false
end

return utils