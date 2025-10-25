-- didisploit.cc - Main Script v2.1
-- Educational purposes only

local Config = {
    Name = "didisploit.cc",
    Version = "2.1",
    Author = "didisigma1"
}

print("Loading " .. Config.Name .. " v" .. Config.Version)

-- Load Shadow Library from GitHub
local ShadowLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/didisigma1/didisploit.cc/main/src/libs/shadowlib.lua"))()

-- Create main window
local Window = ShadowLib:CreateWindow(Config.Name, "Normal")

-- Create tabs
local VisualTab = Window:CreateTab("Visuals")
local CombatTab = Window:CreateTab("Combat")
local MovementTab = Window:CreateTab("Movement")
local MiscTab = Window:CreateTab("Misc")

-- Load misc modules
local FOVChanger = loadstring(game:HttpGet("https://raw.githubusercontent.com/didisigma1/didisploit.cc/main/modules/misc/fovchanger.lua"))()
local Fullbright = loadstring(game:HttpGet("https://raw.githubusercontent.com/didisigma1/didisploit.cc/main/modules/misc/fullbright.lua"))()
local RatioChanger = loadstring(game:HttpGet("https://raw.githubusercontent.com/didisigma1/didisploit.cc/main/modules/misc/ratiochanger.lua"))()

-- Visuals settings
local VisualsSettings = {
    -- Players
    EnemyOnly = false,
    BoxESP = false,
    NameESP = false,
    GlowESP = false,
    TeamCheck = true,
    
    -- Self
    SelfGlow = false,
    
    -- Misc
    RefreshRate = 0.1,
    FOV = 80,
    GlowIntensity = 0.7
}

-- Misc settings
local MiscSettings = {
    FullbrightEnabled = false,
    CurrentRatio = "16:9"
}

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ESP Objects
local ESPObjects = {}
local SelfGlowObject = nil
local ESPLoop = nil

-- Colors
local TeamColors = {
    Enemy = Color3.fromRGB(255, 0, 0),    -- Red
    Friendly = Color3.fromRGB(0, 255, 0), -- Green
    Neutral = Color3.fromRGB(255, 255, 0) -- Yellow
}

-- Get player color based on team check
local function getPlayerColor(player)
    if VisualsSettings.EnemyOnly and player.Team == LocalPlayer.Team then
        return nil -- Don't show teammates if EnemyOnly enabled
    end
    
    if not VisualsSettings.TeamCheck then
        return TeamColors.Enemy
    end
    
    if player.Team == LocalPlayer.Team then
        return TeamColors.Friendly
    else
        return TeamColors.Enemy
    end
end

-- Create ESP for player
local function createESP(player)
    if player == LocalPlayer then return end
    if not player.Character then return end
    
    local character = player.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- Remove existing ESP
    if ESPObjects[player] then
        ESPObjects[player]:Destroy()
    end
    
    -- Create ESP folder
    local espFolder = Instance.new("Folder")
    espFolder.Name = player.Name .. "_ESP"
    espFolder.Parent = game.CoreGui
    ESPObjects[player] = espFolder
    
    -- Box ESP
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "Box"
    box.Adornee = humanoidRootPart
    box.AlwaysOnTop = true
    box.ZIndex = 1
    box.Size = Vector3.new(4, 6, 1)
    box.Transparency = 0.5
    box.Color3 = getPlayerColor(player) or TeamColors.Enemy
    box.Visible = VisualsSettings.BoxESP and getPlayerColor(player) ~= nil
    box.Parent = espFolder
    
    -- Name ESP
    local billboard = Instance.new("BillboardGui")
    local nameLabel = Instance.new("TextLabel")
    
    billboard.Name = "Name"
    billboard.Adornee = humanoidRootPart
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3.5, 0)
    billboard.AlwaysOnTop = true
    
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = getPlayerColor(player) or TeamColors.Enemy
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.Visible = VisualsSettings.NameESP and getPlayerColor(player) ~= nil
    nameLabel.Parent = billboard
    billboard.Parent = espFolder
    
    -- Glow ESP
    local glow = Instance.new("Highlight")
    glow.Name = "Glow"
    glow.Adornee = character
    glow.FillColor = getPlayerColor(player) or TeamColors.Enemy
    glow.FillTransparency = VisualsSettings.GlowIntensity
    glow.OutlineColor = getPlayerColor(player) or TeamColors.Enemy
    glow.OutlineTransparency = 0
    glow.Enabled = VisualsSettings.GlowESP and getPlayerColor(player) ~= nil
    glow.Parent = espFolder
end

-- Remove ESP for player
local function removeESP(player)
    if ESPObjects[player] then
        ESPObjects[player]:Destroy()
        ESPObjects[player] = nil
    end
end

-- Create Self Glow
local function createSelfGlow()
    if SelfGlowObject then
        SelfGlowObject:Destroy()
    end
    
    if not LocalPlayer.Character then return end
    
    SelfGlowObject = Instance.new("Highlight")
    SelfGlowObject.Name = "SelfGlow"
    SelfGlowObject.Adornee = LocalPlayer.Character
    SelfGlowObject.FillColor = Color3.new(1, 1, 1) -- White
    SelfGlowObject.FillTransparency = VisualsSettings.GlowIntensity
    SelfGlowObject.OutlineColor = Color3.new(1, 1, 1) -- White
    SelfGlowObject.OutlineTransparency = 0
    SelfGlowObject.Enabled = VisualsSettings.SelfGlow
    SelfGlowObject.Parent = game.CoreGui
end

-- Remove Self Glow
local function removeSelfGlow()
    if SelfGlowObject then
        SelfGlowObject:Destroy()
        SelfGlowObject = nil
    end
end

-- Update all ESP
local function updateAllESP()
    for player, espFolder in pairs(ESPObjects) do
        if espFolder and espFolder.Parent then
            local color = getPlayerColor(player)
            local shouldShow = color ~= nil
            
            -- Update box
            local box = espFolder:FindFirstChild("Box")
            if box then
                box.Color3 = color or TeamColors.Enemy
                box.Visible = VisualsSettings.BoxESP and shouldShow
            end
            
            -- Update name
            local nameBillboard = espFolder:FindFirstChild("Name")
            if nameBillboard then
                local nameLabel = nameBillboard:FindFirstChild("TextLabel")
                if nameLabel then
                    nameLabel.TextColor3 = color or TeamColors.Enemy
                    nameLabel.Visible = VisualsSettings.NameESP and shouldShow
                end
            end
            
            -- Update glow
            local glow = espFolder:FindFirstChild("Glow")
            if glow then
                glow.FillColor = color or TeamColors.Enemy
                glow.OutlineColor = color or TeamColors.Enemy
                glow.FillTransparency = VisualsSettings.GlowIntensity
                glow.Enabled = VisualsSettings.GlowESP and shouldShow
            end
        else
            ESPObjects[player] = nil
        end
    end
    
    -- Update self glow
    if SelfGlowObject then
        SelfGlowObject.FillTransparency = VisualsSettings.GlowIntensity
        SelfGlowObject.Enabled = VisualsSettings.SelfGlow
    end
end

-- Update FOV
local function updateFOV()
    FOVChanger:SetFOV(VisualsSettings.FOV)
end

-- ESP Loop
local function startESPLoop()
    if ESPLoop then
        ESPLoop:Disconnect()
    end
    
    ESPLoop = RunService.Heartbeat:Connect(function()
        -- Clean up dead players and respawned players
        for player, espFolder in pairs(ESPObjects) do
            if not Players:FindFirstChild(player.Name) or not player.Character or not player.Character:FindFirstChild("Humanoid") or player.Character.Humanoid.Health <= 0 then
                removeESP(player)
            end
        end
        
        -- Add new players and respawned players
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                if not ESPObjects[player] then
                    createESP(player)
                end
            end
        end
        
        -- Update self glow if character respawned
        if VisualsSettings.SelfGlow and LocalPlayer.Character and not SelfGlowObject then
            createSelfGlow()
        end
        
        updateAllESP()
        wait(VisualsSettings.RefreshRate)
    end)
end

-- Create Visuals subtabs
local PlayersSubTab = VisualTab:CreateTab("Players")
local SelfSubTab = VisualTab:CreateTab("Self")
local MiscVisualsSubTab = VisualTab:CreateTab("Misc")

-- Players Tab Controls
PlayersSubTab:CreateToggle("Enemy Only", function(state)
    VisualsSettings.EnemyOnly = state
    updateAllESP()
end)

PlayersSubTab:CreateToggle("Box ESP", function(state)
    VisualsSettings.BoxESP = state
    updateAllESP()
end)

PlayersSubTab:CreateToggle("Name ESP", function(state)
    VisualsSettings.NameESP = state
    updateAllESP()
end)

PlayersSubTab:CreateToggle("Glow ESP", function(state)
    VisualsSettings.GlowESP = state
    updateAllESP()
end)

PlayersSubTab:CreateToggle("Team Check", function(state)
    VisualsSettings.TeamCheck = state
    updateAllESP()
end)

-- Self Tab Controls
SelfSubTab:CreateToggle("Self Glow", function(state)
    VisualsSettings.SelfGlow = state
    if state then
        createSelfGlow()
    else
        removeSelfGlow()
    end
end)

-- Misc Visuals Tab Controls
MiscVisualsSubTab:CreateSlider("Refresh Rate", 0.1, 5, function(value)
    VisualsSettings.RefreshRate = value
    startESPLoop()
end)

MiscVisualsSubTab:CreateSlider("FOV", 70, 120, function(value)
    VisualsSettings.FOV = value
    updateFOV()
end)

MiscVisualsSubTab:CreateSlider("Glow Intensity", 0.1, 0.9, function(value)
    VisualsSettings.GlowIntensity = value
    updateAllESP()
end)

-- Main Misc Tab Controls
MiscTab:CreateToggle("Fullbright", function(state)
    MiscSettings.FullbrightEnabled = state
    if state then
        Fullbright:Enable()
    else
        Fullbright:Disable()
    end
end)

MiscTab:CreateDropdown("Aspect Ratio", {"16:9", "4:3", "16:10", "21:9"}, function(ratio)
    MiscSettings.CurrentRatio = ratio
    if ratio == "16:9" then
        RatioChanger:ResetScreen()
    elseif ratio == "4:3" then
        RatioChanger:Set4by3()
    elseif ratio == "16:10" then
        RatioChanger:Set16by10()
    elseif ratio == "21:9" then
        RatioChanger:Set21by9()
    end
end)

-- Set default FOV
updateFOV()

-- Initialize ESP for existing players
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createESP(player)
    end
end

-- Start ESP loop
startESPLoop()

-- Player connections with proper respawn handling
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        wait(2) -- Wait for character to fully load
        if player ~= LocalPlayer then
            createESP(player)
        else
            if VisualsSettings.SelfGlow then
                createSelfGlow()
            end
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

-- Handle local player respawn
LocalPlayer.CharacterAdded:Connect(function(character)
    wait(1)
    if VisualsSettings.SelfGlow then
        createSelfGlow()
    end
end)

print("didisploit.cc v2.1 loaded successfully!")
return Config
