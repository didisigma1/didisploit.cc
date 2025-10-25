-- Ratio Changer / Screen Stretch Module
local RatioChanger = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local OriginalViewportSize = nil
local IsStretched = false

function RatioChanger:StretchScreen(ratio)
    ratio = ratio or 1.3333 -- 4:3 ratio
    
    if not OriginalViewportSize then
        OriginalViewportSize = Camera.ViewportSize
    end
    
    local newSize = Vector2.new(
        math.floor(OriginalViewportSize.X * ratio),
        OriginalViewportSize.Y
    )
    
    Camera.ViewportSize = newSize
    IsStretched = true
    
    return true
end

function RatioChanger:ResetScreen()
    if OriginalViewportSize then
        Camera.ViewportSize = OriginalViewportSize
        IsStretched = false
        return true
    end
    return false
end

function RatioChanger:Set4by3()
    return self:StretchScreen(1.3333)
end

function RatioChanger:Set16by9()
    return self:ResetScreen() -- 16:9 is default
end

function RatioChanger:Set16by10()
    return self:StretchScreen(1.6)
end

function RatioChanger:Set21by9()
    return self:StretchScreen(2.3333)
end

function RatioChanger:IsStretched()
    return IsStretched
end

-- Auto-reset on player leaving
game:GetService("Players").PlayerRemoving:Connect(function(player)
    if player == LocalPlayer then
        RatioChanger:ResetScreen()
    end
end)

return RatioChanger