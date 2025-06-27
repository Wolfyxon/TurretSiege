local Node = require("lib.Node")

---@class Timer: Node
local Timer = class("Timer", Node)
Timer:_registerEvent("end")

Timer.startedAt = nil ---@type number?
Timer.waitTime = 0.5  ---@type number
Timer.temp = false    ---@type boolean
Timer.loop = false    ---@type boolean
Timer.thing = "hi"

---@return boolean
function Timer:isRunning()
    return self.startedAt ~= nil
end

---@return self
function Timer:start()
    self.startedAt = self:getTime()
    
    return self
end

function Timer:stop()
    self.startedAt = nil

    if self.temp then
        self:destroy()
    end
end

---@param func function
---@return self
function Timer:onEnd(func)
    self:onEvent("end", func)

    return self
end

---@param enabled boolean
---@return self
function Timer:setLoop(enabled)
    self.loop = enabled

    return self
end

---@param time number
---@return self
function Timer:setWait(time)
    self.waitTime = time

    return self
end

function Timer:update(delta)
    if self:isRunning() and self:getTime() > self.startedAt + self.waitTime then

        self:emitEvent("end")
        self:stop()

        if self.loop then
            self:start()
        end
    end
end

return Timer