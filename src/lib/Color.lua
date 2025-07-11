---@class Color
local Color = class("Color")

Color.r = 1 ---@type number
Color.g = 1 ---@type number
Color.b = 1 ---@type number
Color.a = 1  ---@type number

---@param r? number
---@param g? number
---@param b? number
---@param a? number
---@return self
function Color:new(r, g, b, a)
    return initClass(Color, {
        r = math.clamp(r  or 1, 0, 1),
        g = math.clamp(g  or 1, 0, 1),
        b = math.clamp(b  or 1, 0, 1),
        a = math.clamp(a  or 1, 0, 1)
    })
end

---@param r? number
---@param g? number
---@param b? number
---@param a? number
function Color:new255(r, g, b, a)
    r = r or 255
    g = g or 255
    b = b or 255
    a = a or 255

    return Color:new(r / 255, g / 255, b / 255, a / 255)
end

--== Dynamic functions ==--

---@param color Color
function Color:lerp(color, speed)
    self:lerpRGBA(color.r, color.g, color.b, color.a, speed)
end

---@param r number
---@param g number
---@param b number
---@param a number
---@param speed number
function Color:lerpRGBA(r, g, b, a, speed)
    self.r = math.lerp(self.r, r, speed)
    self.g = math.lerp(self.g, g, speed)
    self.b = math.lerp(self.b, b, speed)
    self.a = math.lerp(self.a, a, speed)
end

function Color:lerpRGB(r, g, b, speed)
    self:lerpRGBA(r, g, b, self.a, speed)
end

---@param color Color
function Color:mul(color)
    local function clamp(val)
        return math.clamp(val, 0, 1)
    end

    self.r = clamp(self.r * color.r)
    self.g = clamp(self.g * color.g)
    self.b = clamp(self.b * color.b)
    self.a = clamp(self.a * color.a)
end

---@return Color
function Color:clone()
    return Color:new(self.r, self.g, self.b, self.a)
end

---@return number, number, number, number
function Color:getRGBA()
    return self.r, self.g, self.b, self.a
end

function Color:toGraphics()
    love.graphics.setColor(self.r, self.g, self.b, self.a)
end

---@return string
function Color:__tostring()
    return "(" .. table.concat({self.r, self.g, self.b, self.a}, ", ") .. ")"
end

---@param color Color
---@return Color
function Color:__add(color)
    return Color:new(
        self.r + color.r,
        self.g + color.g,
        self.b + color.b,
        self.a + color.a
    )
end

---@param color Color
---@return Color
function Color:__sub(color)
    return Color:new(
        self.r - color.r,
        self.g - color.g,
        self.b - color.b,
        self.a - color.a
    )
end

---@param color Color
---@return Color
function Color:__mul(color)
    return Color:new(
        self.r * color.r,
        self.g * color.g,
        self.b * color.b,
        self.a * color.a
    )
end

--== Static functions ==--

---@param instance any|Color
---@return boolean
function Color.isColor(instance)
    return (
        type(instance) == "table" and

        instance.r ~= nil and
        instance.g ~= nil and
        instance.b ~= nil and
        instance.a ~= nil
    )
end

--== Predefined colors ==--

Color.RED = Color:new(1, 0, 0)
Color.GREEN = Color:new(0, 1, 0)
Color.BLUE = Color:new(0, 0, 1)
Color.WHITE = Color:new(1, 1, 1)
Color.BLACK = Color:new(0, 0, 0)
Color.TRANSPARENT = Color:new(1, 1, 1, 0)

return Color