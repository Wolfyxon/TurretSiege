---@class Assets
assets = {
    cache = {}
}

---@param path string
function assets.unload(path)
    assets.cache[path] = nil
end

function assets.unloadAll(path)
    assets.cache = {}
end

---@param path string
---@return ImageData?
function assets.getImage(path)
    return assets.cache[path] or love.graphics.newImage(path)
end

return assets