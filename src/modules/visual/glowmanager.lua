-- Glow Manager Module
local GlowManager = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local GlowObjects = {}
local SelfGlowObject = nil

function GlowManager:CreatePlayerGlow(player, color, intensity)
    if not player or not player.Character then return nil end
    
    -- Remove existing glow
    self:RemovePlayerGlow(player)
    
    local glow = Instance.new("Highlight")
    glow.Name = player.Name .. "_Glow"
    glow.Adornee = player.Character
    glow.FillColor = color or Color3.new(1, 0, 0)
    glow.FillTransparency = intensity or 0.7
    glow.OutlineColor = color or Color3.new(1, 0, 0)
    glow.OutlineTransparency = 0
    glow.Enabled = true
    glow.Parent = game.CoreGui
    
    GlowObjects[player] = glow
    
    -- Auto-update when character changes
    player.CharacterAdded:Connect(function(character)
        wait(1)
        if GlowObjects[player] then
            GlowObjects[player].Adornee = character
        end
    end)
    
    return glow
end

function GlowManager:RemovePlayerGlow(player)
    if GlowObjects[player] then
        GlowObjects[player]:Destroy()
        GlowObjects[player] = nil
    end
end

function GlowManager:UpdatePlayerGlowColor(player, color)
    if GlowObjects[player] then
        GlowObjects[player].FillColor = color
        GlowObjects[player].OutlineColor = color
    end
end

function GlowManager:UpdatePlayerGlowIntensity(player, intensity)
    if GlowObjects[player] then
        GlowObjects[player].FillTransparency = intensity
    end
end

function GlowManager:SetAllGlowIntensity(intensity)
    for player, glow in pairs(GlowObjects) do
        glow.FillTransparency = intensity
    end
    
    if SelfGlowObject then
        SelfGlowObject.FillTransparency = intensity
    end
end

function GlowManager:CreateSelfGlow(color, intensity)
    if not LocalPlayer.Character then return nil end
    
    self:RemoveSelfGlow()
    
    local glow = Instance.new("Highlight")
    glow.Name = "SelfGlow"
    glow.Adornee = LocalPlayer.Character
    glow.FillColor = color or Color3.new(1, 1, 1) -- White default
    glow.FillTransparency = intensity or 0.7
    glow.OutlineColor = color or Color3.new(1, 1, 1)
    glow.OutlineTransparency = 0
    glow.Enabled = true
    glow.Parent = game.CoreGui
    
    SelfGlowObject = glow
    
    -- Auto-update when character respawns
    LocalPlayer.CharacterAdded:Connect(function(character)
        wait(1)
        if SelfGlowObject then
            SelfGlowObject.Adornee = character
        end
    end)
    
    return glow
end

function GlowManager:RemoveSelfGlow()
    if SelfGlowObject then
        SelfGlowObject:Destroy()
        SelfGlowObject = nil
    end
end

function GlowManager:UpdateSelfGlowColor(color)
    if SelfGlowObject then
        SelfGlowObject.FillColor = color
        SelfGlowObject.OutlineColor = color
    end
end

function GlowManager:UpdateSelfGlowIntensity(intensity)
    if SelfGlowObject then
        SelfGlowObject.FillTransparency = intensity
    end
end

function GlowManager:ToggleSelfGlow(enabled, color, intensity)
    if enabled then
        return self:CreateSelfGlow(color, intensity)
    else
        self:RemoveSelfGlow()
        return nil
    end
end

function GlowManager:Cleanup()
    -- Remove all glows
    for player, glow in pairs(GlowObjects) do
        glow:Destroy()
    end
    GlowObjects = {}
    
    self:RemoveSelfGlow()
end

function GlowManager:GetGlowCount()
    local count = 0
    for _ in pairs(GlowObjects) do
        count = count + 1
    end
    return count
end

-- Auto-cleanup when player leaves
Players.PlayerRemoving:Connect(function(player)
    GlowManager:RemovePlayerGlow(player)
end)

return GlowManager