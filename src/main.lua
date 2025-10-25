-- didisploit.cc - Main Script v2.1 FIXED
-- Educational purposes only

local Config = {
    Name = "didisploit.cc",
    Version = "2.1",
    Author = "didisigma1"
}

print("Loading " .. Config.Name .. " v" .. Config.Version)

-- Settings
local VisualsSettings = {
    BoxESP = false,
    NameESP = false,
    SkeletonESP = false,
    GlowESP = false,
    TeamCheck = true,
    RefreshRate = 0.1
}

-- Load Shadow Library
local shadowLibCode = game:HttpGet("https://raw.githubusercontent.com/didisigma1/didisploit.cc/main/src/libs/shadowlib.lua")
local ShadowLib = loadstring(shadowLibCode)()

-- Load modules
local TeamCheck = loadstring(game:HttpGet("https://raw.githubusercontent.com/didisigma1/didisploit.cc/main/src/utils/visual/teamcheck.lua"))()
local Fullbright = loadstring(game:HttpGet("https://raw.githubusercontent.com/didisigma1/didisploit.cc/main/src/utils/misc/fullbright.lua"))()
local FOVChanger = loadstring(game:HttpGet("https://raw.githubusercontent.com/didisigma1/didisploit.cc/main/src/utils/misc/foxchanger.lua"))()
local RatioChanger = loadstring(game:HttpGet("https://raw.githubusercontent.com/didisigma1/didisploit.cc/main/src/utils/misc/ratiochanger.lua"))()
local GlowManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/didisigma1/didisploit.cc/main/src/utils/visual/glowmanager.lua"))()
local LoopUtils = loadstring(game:HttpGet("https://raw.githubusercontent.com/didisigma1/didisploit.cc/main/src/utils/loop_utils.lua"))()

-- Create main window
local Window = ShadowLib:CreateWindow(Config.Name, "Normal")

-- Create tabs
local VisualTab = Window:CreateTab("Visuals")
local CombatTab = Window:CreateTab("Combat")
local MovementTab = Window:CreateTab("Movement")
local MiscTab = Window:CreateTab("Misc")

-- Visuals Tab
do
    -- ESP Section
    VisualTab:CreateLabel("ESP Settings")
    
    local BoxToggle = VisualTab:CreateToggle("Box ESP", function(state)
        VisualsSettings.BoxESP = state
    end)
    
    local NameToggle = VisualTab:CreateToggle("Name ESP", function(state)
        VisualsSettings.NameESP = state
    end)
    
    local SkeletonToggle = VisualTab:CreateToggle("Skeleton ESP", function(state)
        VisualsSettings.SkeletonESP = state
    end)
    
    local GlowToggle = VisualTab:CreateToggle("Glow ESP", function(state)
        VisualsSettings.GlowESP = state
    end)
    
    local TeamCheckToggle = VisualTab:CreateToggle("Team Check", function(state)
        VisualsSettings.TeamCheck = state
        TeamCheck.Enabled = state
    end)
    
    -- ESP Color Settings
    VisualTab:CreateLabel("ESP Colors")
    
    local EnemyColor = {255, 0, 0} -- Red
    local FriendlyColor = {0, 255, 0} -- Green
    
    VisualTab:CreateButton("Set Enemy Color (Red)", function()
        EnemyColor = {255, 0, 0}
        print("Enemy color set to Red")
    end)
    
    VisualTab:CreateButton("Set Friendly Color (Green)", function()
        FriendlyColor = {0, 255, 0}
        print("Friendly color set to Green")
    end)
    
    -- Glow Settings
    VisualTab:CreateLabel("Glow Settings")
    
    VisualTab:CreateButton("Enable All Glow", function()
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            if player ~= game:GetService("Players").LocalPlayer then
                local color = Color3.fromRGB(unpack(TeamCheck:IsEnemy(player) and EnemyColor or FriendlyColor))
                GlowManager:CreatePlayerGlow(player, color, 0.7)
            end
        end
    end)
    
    VisualTab:CreateButton("Disable All Glow", function()
        GlowManager:Cleanup()
    end)
    
    VisualTab:CreateButton("Self Glow", function()
        GlowManager:ToggleSelfGlow(true, Color3.new(1, 1, 1), 0.5)
    end)
end

-- Combat Tab
do
    CombatTab:CreateLabel("Combat Features")
    
    CombatTab:CreateButton("Aimbot (Test)", function()
        print("Aimbot test clicked!")
    end)
    
    CombatTab:CreateButton("Triggerbot (Test)", function()
        print("Triggerbot test clicked!")
    end)
    
    CombatTab:CreateButton("Silent Aim (Test)", function()
        print("Silent Aim test clicked!")
    end)
end

-- Movement Tab
do
    MovementTab:CreateLabel("Movement Features")
    
    MovementTab:CreateButton("Speed Hack", function()
        local player = game:GetService("Players").LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 50
            print("Speed set to 50")
        end
    end)
    
    MovementTab:CreateButton("Jump Power", function()
        local player = game:GetService("Players").LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = 100
            print("Jump power set to 100")
        end
    end)
    
    MovementTab:CreateButton("Reset Movement", function()
        local player = game:GetService("Players").LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 16
            player.Character.Humanoid.JumpPower = 50
            print("Movement reset to default")
        end
    end)
    
    MovementTab:CreateButton("Fly (N)", function()
        print("Fly activated! Press N to toggle")
    end)
end

-- Misc Tab
do
    MiscTab:CreateLabel("Miscellaneous Features")
    
    -- Fullbright
    local FullbrightToggle = MiscTab:CreateToggle("Fullbright", function(state)
        if state then
            Fullbright:Enable()
        else
            Fullbright:Disable()
        end
    end)
    
    -- FOV Changer
    MiscTab:CreateLabel("FOV Changer")
    
    MiscTab:CreateButton("FOV 90", function()
        FOVChanger:SetFOV(90)
    end)
    
    MiscTab:CreateButton("FOV 120", function()
        FOVChanger:SetFOV(120)
    end)
    
    MiscTab:CreateButton("Reset FOV", function()
        FOVChanger:ResetFOV()
    end)
    
    -- Ratio Changer
    MiscTab:CreateLabel("Ratio Changer")
    
    MiscTab:CreateButton("4:3 Ratio", function()
        RatioChanger:Set4by3()
    end)
    
    MiscTab:CreateButton("16:9 Ratio", function()
        RatioChanger:Set16by9()
    end)
    
    MiscTab:CreateButton("Reset Ratio", function()
        RatioChanger:ResetScreen()
    end)
    
    -- Server Info
    MiscTab:CreateLabel("Server Info")
    
    MiscTab:CreateButton("Show Players", function()
        local players = game:GetService("Players"):GetPlayers()
        print("Players in server (" .. #players .. "):")
        for _, player in pairs(players) do
            print(" - " .. player.Name)
        end
    end)
    
    MiscTab:CreateButton("Server Info", function()
        print("Place: " .. game.PlaceId)
        print("Job ID: " .. game.JobId)
        print("Players: " .. #game:GetService("Players"):GetPlayers())
    end)
end

-- Simple ESP Implementation
local function setupSimpleESP()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer
    
    local ESPLoop = LoopUtils:CreateManagedLoop("SimpleESP", function()
        if not VisualsSettings.BoxESP and not VisualsSettings.NameESP and not VisualsSettings.GlowESP then
            return
        end
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    -- Simple highlight effect
                    if VisualsSettings.GlowESP then
                        local color = TeamCheck:IsEnemy(player) and Color3.new(1, 0, 0) or Color3.new(0, 1, 0)
                        if not GlowObjects then GlowObjects = {} end
                        if not GlowObjects[player] then
                            GlowObjects[player] = GlowManager:CreatePlayerGlow(player, color, 0.7)
                        end
                    else
                        GlowManager:RemovePlayerGlow(player)
                        if GlowObjects then
                            GlowObjects[player] = nil
                        end
                    end
                end
            end
        end
    end, 0.1)
    
    ESPLoop:Start()
end

-- Initialize features
setupSimpleESP()

print("didisploit.cc v2.1 loaded successfully!")

-- Return library for external use
return {
    Config = Config,
    Window = Window,
    TeamCheck = TeamCheck,
    Fullbright = Fullbright,
    FOVChanger = FOVChanger,
    RatioChanger = RatioChanger,
    GlowManager = GlowManager
}
