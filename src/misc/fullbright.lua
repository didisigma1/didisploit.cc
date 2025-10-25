-- Fullbright Module
local Fullbright = {}

local Lighting = game:GetService("Lighting")
local OriginalSettings = {}

function Fullbright:Enable()
    -- Save original settings
    OriginalSettings = {
        GlobalShadows = Lighting.GlobalShadows,
        Ambient = Lighting.Ambient,
        Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        FogEnd = Lighting.FogEnd
    }
    
    -- Apply fullbright
    Lighting.GlobalShadows = false
    Lighting.Ambient = Color3.new(1, 1, 1)
    Lighting.Brightness = 2
    Lighting.ClockTime = 12
    Lighting.FogEnd = 100000
    
    return true
end

function Fullbright:Disable()
    -- Restore original settings
    if OriginalSettings.GlobalShadows ~= nil then
        Lighting.GlobalShadows = OriginalSettings.GlobalShadows
        Lighting.Ambient = OriginalSettings.Ambient
        Lighting.Brightness = OriginalSettings.Brightness
        Lighting.ClockTime = OriginalSettings.ClockTime
        Lighting.FogEnd = OriginalSettings.FogEnd or 10000
    end
    
    return true
end

function Fullbright:Toggle()
    if Lighting.GlobalShadows == false then
        return self:Disable()
    else
        return self:Enable()
    end
end

function Fullbright:IsEnabled()
    return Lighting.GlobalShadows == false
end

return Fullbright