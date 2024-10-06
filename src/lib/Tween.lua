local Node = require("lib.Node")
local Color = require("lib.Color")

---@class Tween: Node
local Tween = Node:new()

---@enum EASING_STYLE
Tween.EASING_STYLE = {
    LINEAR = 0
}

---@enum EASING_DIRECTION
Tween.EASING_DIRECTION = {
    IN_OUT = 0,
    IN = 1,
    OUT = 2
}

Tween.isPlaying = false     ---@type boolean
Tween.paused = false        ---@type boolean
Tween.removeOnFinish = true ---@type boolean
Tween.keyframes = {}        ---@type {}[]
Tween.currentKeyframe = 1   ---@type integer

Tween:_appendClass("Tween")
Tween:_registerEvent("started", "finished")

function Tween:new(o)
    o = Node.new(self, o)
    setmetatable(o, self)
    self.__index = self
    
    o.keyframes = {}

    o:onEvent("finished", function ()
        if self.removeOnFinish then
            self:destroy()
        end
    end)

    return o
end


---@param target Node|table
---@param properties {string: number|Color}
---@param easingStyle? EASING_STYLE
---@param easingDirection? EASING_DIRECTION
---@return Tween
function Tween:addKeyframe(target, properties, duration, easingStyle, easingDirection)
    assert(type(target) == "table", "Only tables can be tweened")
    
    for k, v in ipairs(properties) do
        assert(Tween.isTweenable(v), "Value '" .. tostring(k) .. "' is not tweenable.")
    end

    table.insert(self.keyframes, {
        target = target,
        properties = properties,
        duration = duration,
        easingStyle = easingStyle or Tween.EASING_STYLE.LINEAR,
        easingDirection = easingDirection or Tween.EASING_DIRECTION.IN_OUT,

        playing = false,
        startTime = 0
    })

    return self

end

function Tween:update(delta)
    if self.paused or not self.isPlaying then return end

    local keyframe = self.keyframes[self.currentKeyframe]

    if not keyframe then
        self.isPlaying = false
        return
    end

    if not keyframe.isPlaying then
        keyframe.startTime = love.timer.getTime()
        keyframe.isPlaying = true
    end

    local time = love.timer.getTime()
    local timePassed = time - keyframe.startTime

    for k, v in pairs(keyframe.properties) do
        keyframe.target[k] = Tween.interpolateValue(
            keyframe.target[k], v,
            keyframe.startTime, time,
            keyframe.duration,
            keyframe.easingStyle, keyframe.easingDirection
        )
    end

    if timePassed >= keyframe.duration then
        if self.currentKeyframe >= #self.keyframes then
            self:emitEvent("finished")
            keyframe.isPlaying = false
        else
            self.currentKeyframe = self.currentKeyframe + 1
        end
    end

end

function Tween:play()
    self.isPlaying = true
end

function Tween:stop()
    self.currentKeyframe = 1
    self.isPlaying = false

    if self.removeOnFinish then
        self:destroy()
    end
end

--== Static functions ==--

---@param value any
---@return boolean
function Tween.isTweenable(value)
    return type(value) == "number" or Color.isColor(value)
end

---@param num number
---@param targetNum number
---@param startTime number
---@param currentTime number
---@param duration number
---@param easingStyle? EASING_STYLE
---@param easingDirection? EASING_DIRECTION
---@return number
function Tween.interpolateNumber(num, targetNum, startTime, currentTime, duration, easingStyle, easingDirection)
    easingStyle = easingStyle or Tween.EASING_STYLE.LINEAR
    easingDirection = easingDirection or Tween.EASING_DIRECTION.IN_OUT

    local timeProgress = (currentTime - startTime) / duration

    if easingStyle == Tween.EASING_STYLE.LINEAR then
        return num + (targetNum - num) * timeProgress
    end

    error("Easing style '" .. tostring(easingStyle) .. "' not supported")
end

---@param color Color
---@param targetColor Color
---@param startTime number
---@param currentTime number
---@param duration number
---@param easingStyle? EASING_STYLE
---@param easingDirection? EASING_DIRECTION
---@return Color
function Tween.interpolateColor(color, targetColor, startTime, currentTime, duration, easingStyle, easingDirection)
    local function interp(a, b)
        return Tween.interpolateNumber(a, b, startTime, currentTime, duration, easingStyle, easingDirection)
    end

    return Color:new(
        interp(color.r, targetColor.r),
        interp(color.g, targetColor.g),
        interp(color.b, targetColor.b),
        interp(color.a, targetColor.a)
    )
end

---@param value any
---@param targetValue any
---@param startTime number
---@param currentTime number
---@param duration number
---@param easingStyle? EASING_STYLE
---@param easingDirection? EASING_DIRECTION
---@return number|Color
function Tween.interpolateValue(value, targetValue, startTime, currentTime, duration, easingStyle, easingDirection)
    assert(type(value) == type(targetValue), "Current and target value types don't match")

    if type(value) == "number" then
        return Tween.interpolateNumber(value, targetValue, startTime, currentTime, duration, easingStyle, easingDirection)
    end

    if Color.isColor(value) then
        return Tween.interpolateColor(value, targetValue, startTime, currentTime, duration, easingStyle, easingDirection)
    end

    error("Unsupported type: '" .. type(value) .. "'")
end

-- Quick tweens --

---@param node Node2D
---@param targetColor Color
---@param time number
---@return Tween
function Tween.fadeNodeColor(node, targetColor, time)
    local t = Tween:new()

    t:addKeyframe(node, {
        color = targetColor
    }, time)

    node:addChild(t)
    t:play()

    return t
end

---@param node Node2D
---@param targetAlpha number
---@param time number
---@return Tween
function Tween.fadeNode(node, targetAlpha, time)
    local c = node.color:clone()
    c.a = targetAlpha

    return Tween.fadeNodeColor(node, c, time)
end

return Tween