-- didisploit.cc - Main Script v2.1 FINAL FIX
-- Educational purposes only

local Config = {
    Name = "didisploit.cc",
    Version = "2.1",
    Author = "didisigma1"
}

print("Loading " .. Config.Name .. " v" .. Config.Version)

-- Load Shadow Library
local shadowLibCode = game:HttpGet("https://raw.githubusercontent.com/didisigma1/didisploit.cc/main/src/libs/shadowlib.lua")

-- FIX: Shadow Lib returns a FUNCTION that needs to be CALLED
local ShadowLibFunction = loadstring(shadowLibCode)
print("ShadowLib type: " .. type(ShadowLibFunction))

-- CALL the function to get the actual library
local ShadowLib = ShadowLibFunction()
print("After calling, type: " .. type(ShadowLib))

-- NOW create window (ShadowLib should be a table)
local Window = ShadowLib:CreateWindow(Config.Name, "Normal")
print("Theme selected: Normal")

-- Create tabs
local VisualTab = Window:CreateTab("Visuals")
local CombatTab = Window:CreateTab("Combat") 
local MovementTab = Window:CreateTab("Movement")
local MiscTab = Window:CreateTab("Misc")

print("All tabs created successfully!")

-- Simple test button
VisualTab:CreateButton("Test ESP", function()
    print("ESP Test started!")
    
    -- Simple ESP test
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.new(1, 0, 0)
            highlight.OutlineColor = Color3.new(1, 0, 0)
            highlight.FillTransparency = 0.5
            highlight.Adornee = player.Character
            highlight.Parent = player.Character
            
            print("✅ Highlight added to: " .. player.Name)
        end
    end
end)

print("🎉 didisploit.cc v2.1 loaded successfully!")
return Config
