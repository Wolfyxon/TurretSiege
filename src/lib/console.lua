local Console = {}

function Console.new()
    local this = {}
    this.text = ""

    function this.print(...)
        local str = ""
    
        for i, v in ipairs({...}) do
            str = str .. tostring(v) .. " "
        end
    
        this.text = this.text .. str .. "\n"
    end
    
    function this.draw()
        love.graphics.print(this.text, 0, 0)
    end

    return this
end

return Console