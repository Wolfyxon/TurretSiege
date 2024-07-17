local scene = require("lib.scene"):new()

local circles = 10
local circleRot = 0

function scene:draw(screen)
    local sW, sH = love.graphics.getDimensions(screen)
    local ratio = math.min(sW, sH)

    if not screen or screen == "left" then
        
    end

    if not screen or screen == "bottom" then
        --love.graphics.setBackgroundColor(0.6, 0.5, 0)


        for i = 1, circles do
            love.graphics.push()
            love.graphics.origin()
            love.graphics.translate(sW / 2, sH / 2)
            local dir = (-1) ^ i
            
            love.graphics.rotate(circleRot * dir)

            local c = i / circles
            love.graphics.setColor(0.6 * c, 0.5 * c, 0, 1)
            love.graphics.circle("fill", 0 , 0, (circles - i) * 0.25 * ratio, 6)

            love.graphics.pop()
        end
        
    end 
end

function scene:update(delta)
    circleRot = circleRot + delta * 0.2
end

return scene