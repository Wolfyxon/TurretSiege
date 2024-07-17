local Console = {}

Console.text = ""

function Console.print(...)
    local str = ""

    for i, v in ipairs({...}) do
        str = str .. tostring(v) .. " "
    end

    Console.text = Console.text .. str .. "\n"
end

function Console.draw()
    love.graphics.print(Console.text, 0, 0)
end

return Console