-- didisploit.cc - Main Script v2.1 FIXED
-- Educational purposes only

local Config = {
    Name = "didisploit.cc",
    Version = "2.1",
    Author = "didisigma1"
}

print("Loading " .. Config.Name .. " v" .. Config.Version)

-- Load Shadow Library from GitHub
local shadowLibCode = game:HttpGet("https://raw.githubusercontent.com/didisigma1/didisploit.cc/main/src/libs/shadowlib.lua")
local ShadowLib = loadstring(shadowLibCode)

-- FIX: Shadow Lib returns the library table directly, not a Window object
local Window = ShadowLib:CreateWindow(Config.Name, "Normal")
print("Theme selected: Normal")

-- DEBUG: Check what Window actually contains
print("Window type: " .. type(Window))
if type(Window) == "table" then
    print("Window methods:")
    for k,v in pairs(Window) do
        if type(v) == "function" then
            print("  " .. k)
        end
    end
end

-- FIX: Try different method names that Shadow Lib might use
local VisualTab
if Window.CreateTab then
    VisualTab = Window:CreateTab("Visuals")
elseif Window.AddTab then
    VisualTab = Window:AddTab("Visuals")
elseif Window.NewTab then
    VisualTab = Window:NewTab("Visuals")
else
    -- Last resort: assume Window IS the tab system
    VisualTab = Window
end

print("Visuals tab ready")

-- Create simple test button
if VisualTab.CreateButton then
    VisualTab:CreateButton("Test ESP", function()
        print("ESP Test clicked!")
        
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
                
                print("Added highlight to: " .. player.Name)
            end
        end
    end)
end

-- Add more tabs if possible
local CombatTab, MovementTab, MiscTab
if Window.CreateTab then
    CombatTab = Window:CreateTab("Combat")
    MovementTab = Window:CreateTab("Movement") 
    MiscTab = Window:CreateTab("Misc")
    print("All tabs created")
end

print("didisploit.cc v2.1 loaded successfully!")

-- Return simple ESP function for external use
return {
    Config = Config,
    TestESP = function()
        print("ESP Test function called")
    end
}
