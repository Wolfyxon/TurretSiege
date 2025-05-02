local Node = require("lib.Node")

---@class Audio: Node
local Audio = Node:new()
Audio:_appendClass("Audio")
Audio:_registerEvent("finished")

Audio._wasPlaying = false    ---@type boolean
Audio.source = nil           ---@type Source
Audio.removeOnFinish = false ---@type boolean
Audio.stopOnRemove = true    ---@type boolean

function Audio:new(o)
    o = Node.new(self, o)
    setmetatable(o, self)
    self.__index = self
    
    o:onEvent("finished", function ()
        if o.removeOnFinish then
            o:destroy()
        end
    end)

    o:onEvent("removed", function ()
        if o.stopOnRemove then
            o:stop()
        end
    end)

    return o
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
---@return Audio?
function Audio:setVolume(volume)
    if not self.source then 
        warn("Volume cannot be applied when no source is loaded.")
        return
    end

    self.source:setVolume(volume)
    return self
end

---@param pitch number
---@return Audio?
function Audio:setPitch(pitch)
    if not self.source then 
        warn("Pitch cannot be applied when no source is loaded.")
        return
    end

    self.source:setPitch(pitch)
    return self
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
function Audio:getPlaybackPosition()
    if not self.source then return end

    return self.source:tell()
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