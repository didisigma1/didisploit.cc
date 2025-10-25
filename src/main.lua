-- didisploit.cc - Main Script (FIXED GITHUB LINKS)
-- Educational purposes only

local Config = {
    Name = "didisploit.cc",
    Version = "1.0",
    Author = "didisigma1"
}

print("Loading " .. Config.Name .. " v" .. Config.Version)

-- Load Shadow Library from GitHub (RAW LINK)
local ShadowLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/didisigma1/didisploit.cc/main/src/libs/shadowlib.lua"))()

-- Create main window
local Window = ShadowLib:CreateWindow(Config.Name, "Normal")

-- Create tabs
local VisualTab = Window:CreateTab("Visuals")
local CombatTab = Window:CreateTab("Combat")
local MovementTab = Window:CreateTab("Movement")

-- Visuals settings
local VisualsSettings = {
    BoxESP = false,
    NameESP = false,
    SkeletonESP = false,
    GlowESP = false,
    TeamCheck = true,
    RefreshRate = 0.1
}

-- Simple ESP system
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local ESPObjects = {}

local function getPlayerColor(player)
    if not VisualsSettings.TeamCheck or player.Team ~= LocalPlayer.Team then
        return Color3.fromRGB(255, 0, 0) -- Red for enemies
    else
        return Color3.fromRGB(0, 255, 0) -- Green for teammates
    end
end

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
    box.Color3 = getPlayerColor(player)
    box.Visible = VisualsSettings.BoxESP
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
    nameLabel.TextColor3 = getPlayerColor(player)
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.Visible = VisualsSettings.NameESP
    nameLabel.Parent = billboard
    billboard.Parent = espFolder
    
    -- Glow ESP
    local glow = Instance.new("Highlight")
    glow.Name = "Glow"
    glow.Adornee = character
    glow.FillColor = getPlayerColor(player)
    glow.FillTransparency = 0.7
    glow.OutlineColor = getPlayerColor(player)
    glow.OutlineTransparency = 0
    glow.Enabled = VisualsSettings.GlowESP
    glow.Parent = espFolder
end

local function removeESP(player)
    if ESPObjects[player] then
        ESPObjects[player]:Destroy()
        ESPObjects[player] = nil
    end
end

local function updateAllESP()
    for player, espFolder in pairs(ESPObjects) do
        if espFolder and espFolder.Parent then
            local color = getPlayerColor(player)
            
            -- Update box
            local box = espFolder:FindFirstChild("Box")
            if box then
                box.Color3 = color
                box.Visible = VisualsSettings.BoxESP
            end
            
            -- Update name
            local nameBillboard = espFolder:FindFirstChild("Name")
            if nameBillboard then
                local nameLabel = nameBillboard:FindFirstChild("TextLabel")
                if nameLabel then
                    nameLabel.TextColor3 = color
                    nameLabel.Visible = VisualsSettings.NameESP
                end
            end
            
            -- Update glow
            local glow = espFolder:FindFirstChild("Glow")
            if glow then
                glow.FillColor = color
                glow.OutlineColor = color
                glow.Enabled = VisualsSettings.GlowESP
            end
        end
    end
end

-- ESP Loop
local ESPLoop
local function startESPLoop()
    if ESPLoop then
        ESPLoop:Disconnect()
    end
    
    ESPLoop = RunService.Heartbeat:Connect(function()
        -- Clean up
        for player, espFolder in pairs(ESPObjects) do
            if not Players:FindFirstChild(player.Name) or not player.Character then
                removeESP(player)
            end
        end
        
        -- Add new players
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and not ESPObjects[player] and player.Character then
                createESP(player)
            end
        end
        
        updateAllESP()
        wait(VisualsSettings.RefreshRate)
    end)
end

-- GUI Controls
VisualTab:CreateToggle("Box ESP", function(state)
    VisualsSettings.BoxESP = state
    updateAllESP()
end)

VisualTab:CreateToggle("Name ESP", function(state)
    VisualsSettings.NameESP = state
    updateAllESP()
end)

VisualTab:CreateToggle("Glow ESP", function(state)
    VisualsSettings.GlowESP = state
    updateAllESP()
end)

VisualTab:CreateToggle("Team Check", function(state)
    VisualsSettings.TeamCheck = state
    updateAllESP()
end)

VisualTab:CreateSlider("Refresh Rate", 0.1, 5, function(value)
    VisualsSettings.RefreshRate = value
    startESPLoop()
end)

-- Initialize
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createESP(player)
    end
end

startESPLoop()

-- Player connections
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(1)
        createESP(player)
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

print("didisploit.cc loaded successfully!")
return Config
