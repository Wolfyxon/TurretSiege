---@class Assets
assets = {
    cache = {}
}

---@param path string
function assets.unload(path)
    assets.cache[path] = nil
end

function assets.unloadAll()
    assets.cache = {}
end

---@param path string
---@return ImageData?
function assets.loadImage(path)
    local cached = assets.cache[path]
    
    if cached then
        return cached
    end

    local img = love.graphics.newImage(path)
    assets.cache[path] = img
    
    return img 
end

return assets