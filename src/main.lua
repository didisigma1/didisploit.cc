-- didisploit.cc - Main Script
-- Educational purposes only

local Config = {
    Name = "didisploit.cc",
    Version = "1.0",
    Author = "didisigma1"
}

print("Loading " .. Config.Name .. " v" .. Config.Version)

-- Load Shadow Library
local ShadowLib = loadstring(readfile("src/libs/shadowlib.lua"))()

-- Create main window
local Window = ShadowLib:CreateWindow(Config.Name, "Normal")

-- Create tabs
local VisualTab = Window:CreateTab("Visuals")
local CombatTab = Window:CreateTab("Combat")
local MovementTab = Window:CreateTab("Movement")

-- Load utility modules
local LoopUtils = dofile("src/modules/utils/loop_utils.lua")

-- Visuals settings
local VisualsSettings = {
    BoxESP = false,
    NameESP = false,
    SkeletonESP = false,
    GlowESP = false,
    TeamCheck = true,
    RefreshRate = 0.1 -- seconds
}

-- Load modules
dofile("src/modules/visual/esp.lua")
dofile("src/modules/visual/teamcheck.lua")

-- ESP Loop instance
local ESPLoop

-- Function to restart ESP loop with new refresh rate
local function restartESPLoop()
    if ESPLoop then
        ESPLoop:Stop()
    end
    
    ESPLoop = LoopUtils:CreateFastESPUpdate(function()
        updateESP()
    end, VisualsSettings.RefreshRate)
    
    ESPLoop:Start()
end

-- Visuals toggles
VisualTab:CreateToggle("Box ESP", function(state)
    VisualsSettings.BoxESP = state
    updateESP()
end)

VisualTab:CreateToggle("Name ESP", function(state)
    VisualsSettings.NameESP = state
    updateESP()
end)

VisualTab:CreateToggle("Skeleton ESP", function(state)
    VisualsSettings.SkeletonESP = state
    updateESP()
end)

VisualTab:CreateToggle("Glow ESP", function(state)
    VisualsSettings.GlowESP = state
    updateESP()
end)

VisualTab:CreateToggle("Team Check", function(state)
    VisualsSettings.TeamCheck = state
    updateESP()
end)

VisualTab:CreateSlider("Refresh Rate", 0.1, 5, function(value)
    VisualsSettings.RefreshRate = value
    restartESPLoop()
end)

-- Initialize ESP
restartESPLoop()

return {
    Config = Config,
    Window = Window,
    Settings = VisualsSettings,
    Utils = LoopUtils
}