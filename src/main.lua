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

-- Bezpieczne ładowanie ShadowLib
local ShadowLib
local success, err = pcall(function()
    local shadowLibCode = game:HttpGet("https://raw.githubusercontent.com/didisigma1/didisploit.cc/main/src/libs/shadowlib.lua")
    ShadowLib = loadstring(shadowLibCode)()
end)

if not success then
    print("Failed to load ShadowLib: " .. err)
    print("Using fallback UI...")
    
    -- Fallback: prosty UI
    local ScreenGui = Instance.new("ScreenGui")
    local TextLabel = Instance.new("TextLabel")
    
    ScreenGui.Parent = game.CoreGui
    ScreenGui.Name = "FallbackUI"
    
    TextLabel.Parent = ScreenGui
    TextLabel.Size = UDim2.new(0, 200, 0, 50)
    TextLabel.Position = UDim2.new(0, 10, 0, 10)
    TextLabel.BackgroundColor3 = Color3.new(0, 0, 0)
    TextLabel.TextColor3 = Color3.new(1, 1, 1)
    TextLabel.Text = "didisploit.cc v2.1\nShadowLib not loaded"
    TextLabel.TextSize = 14
    
    print("didisploit.cc v2.1 loaded with fallback UI!")
    return
end

-- Bezpieczne ładowanie modułów
local TeamCheck, Fullbright, FOVChanger, RatioChanger, GlowManager, LoopUtils

local function loadModule(url, name)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    
    if success then
        print("Loaded " .. name)
        return result
    else
        print("Failed to load " .. name .. ": " .. result)
        return nil
    end
end

-- Ładowanie modułów
TeamCheck = loadModule("https://raw.githubusercontent.com/didisigma1/didisploit.cc/main/src/utils/visual/teamcheck.lua", "TeamCheck")
Fullbright = loadModule("https://raw.githubusercontent.com/didisigma1/didisploit.cc/main/src/utils/misc/fullbright.lua", "Fullbright")
FOVChanger = loadModule("https://raw.githubusercontent.com/didisigma1/didisploit.cc/main/src/utils/misc/fovchanger.lua", "FOVChanger") -- Poprawiona nazwa
RatioChanger = loadModule("https://raw.githubusercontent.com/didisigma1/didisploit.cc/main/src/utils/misc/ratiochanger.lua", "RatioChanger")
GlowManager = loadModule("https://raw.githubusercontent.com/didisigma1/didisploit.cc/main/src/utils/visual/glowmanager.lua", "GlowManager")
LoopUtils = loadModule("https://raw.githubusercontent.com/didisigma1/didisploit.cc/main/src/utils/loop_utils.lua", "LoopUtils")

-- Fallback functions dla brakujących modułów
if not TeamCheck then
    TeamCheck = {
        Enabled = true,
        IsTeammate = function() return false end,
        IsEnemy = function() return true end
    }
end

if not Fullbright then
    Fullbright = {
        Enable = function() print("Fullbright not available") end,
        Disable = function() print("Fullbright not available") end
    }
end

if not FOVChanger then
    FOVChanger = {
        SetFOV = function() print("FOVChanger not available") end,
        ResetFOV = function() print("FOVChanger not available") end
    }
end

if not RatioChanger then
    RatioChanger = {
        Set4by3 = function() print("RatioChanger not available") end,
        Set16by9 = function() print("RatioChanger not available") end,
        ResetScreen = function() print("RatioChanger not available") end
    }
end

if not GlowManager then
    GlowManager = {
        CreatePlayerGlow = function() return nil end,
        RemovePlayerGlow = function() end,
        Cleanup = function() end,
        ToggleSelfGlow = function() return nil end
    }
end

if not LoopUtils then
    LoopUtils = {
        CreateManagedLoop = function(name, callback, interval)
            return {
                Start = function() 
                    spawn(function()
                        while true do
                            pcall(callback)
                            wait(interval or 0.1)
                        end
                    end)
                end,
                Stop = function() end
            }
        end
    }
end

-- Tworzenie głównego okna
local Window = ShadowLib:CreateWindow(Config.Name, "Normal")

-- Tworzenie zakładek
local VisualTab = Window:CreateTab("Visuals")
local CombatTab = Window:CreateTab("Combat")
local MovementTab = Window:CreateTab("Movement")
local MiscTab = Window:CreateTab("Misc")

-- Zakładka Visuals
do
    VisualTab:CreateLabel("ESP Settings")
    
    local BoxToggle = VisualTab:CreateToggle("Box ESP", function(state)
        VisualsSettings.BoxESP = state
        print("Box ESP: " .. tostring(state))
    end)
    
    local NameToggle = VisualTab:CreateToggle("Name ESP", function(state)
        VisualsSettings.NameESP = state
        print("Name ESP: " .. tostring(state))
    end)
    
    local SkeletonToggle = VisualTab:CreateToggle("Skeleton ESP", function(state)
        VisualsSettings.SkeletonESP = state
        print("Skeleton ESP: " .. tostring(state))
    end)
    
    local GlowToggle = VisualTab:CreateToggle("Glow ESP", function(state)
        VisualsSettings.GlowESP = state
        print("Glow ESP: " .. tostring(state))
    end)
    
    local TeamCheckToggle = VisualTab:CreateToggle("Team Check", function(state)
        VisualsSettings.TeamCheck = state
        TeamCheck.Enabled = state
        print("Team Check: " .. tostring(state))
    end)
    
    -- Ustawienia kolorów ESP
    VisualTab:CreateLabel("ESP Colors")
    
    VisualTab:CreateButton("Set Enemy Color (Red)", function()
        print("Enemy color set to Red")
    end)
    
    VisualTab:CreateButton("Set Friendly Color (Green)", function()
        print("Friendly color set to Green")
    end)
    
    -- Ustawienia Glow
    VisualTab:CreateLabel("Glow Settings")
    
    VisualTab:CreateButton("Enable All Glow", function()
        print("Enabling all glow...")
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            if player ~= game:GetService("Players").LocalPlayer then
                local color = Color3.new(1, 0, 0) -- Czerwony
                GlowManager:CreatePlayerGlow(player, color, 0.7)
            end
        end
    end)
    
    VisualTab:CreateButton("Disable All Glow", function()
        print("Disabling all glow...")
        GlowManager:Cleanup()
    end)
    
    VisualTab:CreateButton("Self Glow", function()
        print("Toggling self glow...")
        GlowManager:ToggleSelfGlow(true, Color3.new(1, 1, 1), 0.5)
    end)
end

-- Zakładka Combat
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

-- Zakładka Movement
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

-- Zakładka Misc
do
    MiscTab:CreateLabel("Miscellaneous Features")
    
    -- Fullbright
    local FullbrightToggle = MiscTab:CreateToggle("Fullbright", function(state)
        if state then
            Fullbright:Enable()
            print("Fullbright enabled")
        else
            Fullbright:Disable()
            print("Fullbright disabled")
        end
    end)
    
    -- FOV Changer
    MiscTab:CreateLabel("FOV Changer")
    
    MiscTab:CreateButton("FOV 90", function()
        FOVChanger:SetFOV(90)
        print("FOV set to 90")
    end)
    
    MiscTab:CreateButton("FOV 120", function()
        FOVChanger:SetFOV(120)
        print("FOV set to 120")
    end)
    
    MiscTab:CreateButton("Reset FOV", function()
        FOVChanger:ResetFOV()
        print("FOV reset")
    end)
    
    -- Ratio Changer
    MiscTab:CreateLabel("Ratio Changer")
    
    MiscTab:CreateButton("4:3 Ratio", function()
        RatioChanger:Set4by3()
        print("Ratio set to 4:3")
    end)
    
    MiscTab:CreateButton("16:9 Ratio", function()
        RatioChanger:Set16by9()
        print("Ratio set to 16:9")
    end)
    
    MiscTab:CreateButton("Reset Ratio", function()
        RatioChanger:ResetScreen()
        print("Ratio reset")
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

-- Prosta implementacja ESP
local function setupSimpleESP()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    local ESPLoop = LoopUtils:CreateManagedLoop("SimpleESP", function()
        if not VisualsSettings.GlowESP then
            return
        end
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    -- Prosty efekt glow
                    local color = TeamCheck:IsEnemy(player) and Color3.new(1, 0, 0) or Color3.new(0, 1, 0)
                    GlowManager:CreatePlayerGlow(player, color, 0.7)
                end
            end
        end
    end, 0.1)
    
    ESPLoop:Start()
end

-- Inicjalizacja funkcji
setupSimpleESP()

print("didisploit.cc v2.1 loaded successfully!")

-- Zwracanie biblioteki do użytku zewnętrznego
return {
    Config = Config,
    Window = Window,
    TeamCheck = TeamCheck,
    Fullbright = Fullbright,
    FOVChanger = FOVChanger,
    RatioChanger = RatioChanger,
    GlowManager = GlowManager
}
