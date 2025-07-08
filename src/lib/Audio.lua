local Node = require("lib.Node")

---@class Audio: Node
local Audio = class("Audio", Node)

Audio:_registerEvent("finished")

Audio._wasPlaying = false    ---@type boolean
Audio.source = nil           ---@type Source
Audio.removeOnFinish = false ---@type boolean
Audio.stopOnRemove = true    ---@type boolean

function Audio:init()
    self:onEvent("finished", function ()
        if self.removeOnFinish then
            self:destroy()
        end
    end)

    self:onEvent("removed", function ()
        if self.stopOnRemove then
            self:stop()
        end
    end)
end

function Audio:update(delta)
    if not self:isPlaying() and self._wasPlaying then
        self._wasPlaying = false
        self:stop()
    end
end

---@param name string
---@param settings {}
---@return boolean
function Audio:setEffect(name, settings)
    if not self.source then
        warn("Failed to set audio effect, source not loaded")
        print(debug.traceback())
        return false
    end

    if not love.audio.isEffectsSupported() then
        return false
    end

    return self.source:setEffect(name, settings)
end

---@param path string
---@param sourceType "stream" | "static"
---@return Audio
function Audio:loadFromFile(path, sourceType)
    return self:setSource(love.audio.newSource(path, sourceType or "stream"))
end

---@param source Source
function Audio:setSource(source)
    self:stop()
    self.source = source

    return self
end

---@param volume number
---@return Audio
function Audio:setVolume(volume)
    if not self.source then 
        warn("Volume cannot be applied when no source is loaded.")
        return self
    end

    self.source:setVolume(volume)
    return self
end

---@param pitch number
---@return Audio
function Audio:setPitch(pitch)
    if not self.source then 
        warn("Pitch cannot be applied when no source is loaded.")
        return self
    end

    self.source:setPitch(pitch)
    return self
end

---@return number?
function Audio:getVolume()
    if not self.source then
        return
    end

    return self.source:getVolume()
end

---@param state boolean
---@return Audio?
function Audio:setLoop(state)
    if not self.source then
        warn("Loop mode cannot be applied when no source is loaded.")
        return
    end

    self.source:setLooping(state)
    return self
end

---@return boolean
function Audio:isPlaying()
    return self.source ~= nil and self.source:isPlaying()
end

---@return number?
function Audio:getPlayTime()
    if not self.source then return end

    return self.source:tell()
end

---@param time number
function Audio:setPlayTime(time)
    if not self.source then return end
    
    self.source:seek(time)
end

---@return Audio?
function Audio:play()
    if not self.source then return end

    self._wasPlaying = true

    self.source:seek(0)
    self.source:play()

    return self
end

---@return Audio?
function Audio:stop()
    if not self.source then return end

    self.source:stop()
    self:emitEvent("finished")

    return self
end

---@return Audio?
function Audio:pause()
    if not self.source then return end
    self.source:pause()

    return self
end

---@return Audio?
function Audio:resume()
    if not self.source then return end
    self.source:play()

    return
end

return Audio