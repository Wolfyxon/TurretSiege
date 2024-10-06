local Node = require("lib.Node")

---@class Audio: Node
local Audio = Node:new()
Audio:_appendClass("Audio")
Audio:_registerEvent("finished")

Audio._wasPlaying = false
Audio.source = nil
Audio.removeOnFinish = false

function Audio:new(o)
    o = Node.new(self, o)
    setmetatable(o, self)
    self.__index = self
    
    o:onEvent("finished", function ()
        if self.removeOnFinish then
            self:destroy()
        end
    end)

    o:onEvent("removed", function ()
        self:stop()
    end)
    
    return o
end

function Audio:update(delta)
    if not self:isPlaying() and self._wasPlaying then
        self._wasPlaying = false
        self:stop()
    end
end

---@param path string
---@param sourceType "stream" | "static"
function Audio:loadFromFile(path, sourceType)
    sourceType = sourceType or "stream"

    self.source = love.audio.newSource(path, sourceType)
end

---@param volume number
function Audio:setVolume(volume)
    if not self.source then 
        warn("Volume cannot be applied when no source is loaded.")
        return
    end

    self.source:setVolume(volume)
end

---@param state boolean
function Audio:setLoop(state)
    if not self.source then
        warn("Loop mode cannot be applied when no source is loaded.")
        return
    end

    self.source:setLooping(state)
end

---@return boolean
function Audio:isPlaying()
    return self.source ~= nil and self.source:isPlaying()
end

function Audio:play()
    if not self.source then return end

    self._wasPlaying = true

    self.source:seek(0)
    self.source:play()
end

function Audio:stop()
    if not self.source then return end

    self.source:stop()
    self:emitEvent("finished")
end

function Audio:pause()
    if not self.source then return end
    self.source:pause()
end

function Audio:resume()
    if not self.source then return end
    self.source:play()
end