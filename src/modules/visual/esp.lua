-- ESP Module for didisploit.cc

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ESPObjects = {}
local ESPLoop

-- Colors
local TeamColors = {
    Enemy = Color3.fromRGB(255, 0, 0),    -- Red
    Friendly = Color3.fromRGB(0, 255, 0), -- Green
    Neutral = Color3.fromRGB(255, 255, 0) -- Yellow
}

-- Get player color based on team check
local function getPlayerColor(player)
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
    local humanoid = character:FindFirstChild("Humanoid")
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not humanoidRootPart then return end
    
    -- Create ESP folder for player
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
    
    -- Skeleton ESP
    local skeletonFolder = Instance.new("Folder")
    skeletonFolder.Name = "Skeleton"
    skeletonFolder.Parent = espFolder
    
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
    
    -- Create skeleton connections
    local function updateSkeleton()
        -- Clear existing skeleton
        for _, part in pairs(skeletonFolder:GetChildren()) do
            if part:IsA("LineHandleAdornment") then
                part:Destroy()
            end
        end
        
        if not VisualsSettings.SkeletonESP then return end
        
        -- Skeleton connections (simplified)
        local connections = {
            -- Torso connections
            {"Head", "UpperTorso"},
            {"UpperTorso", "LowerTorso"},
            {"LowerTorso", "LeftUpperLeg"},
            {"LowerTorso", "RightUpperLeg"},
            {"UpperTorso", "LeftUpperArm"},
            {"UpperTorso", "RightUpperArm"},
            
            -- Arms
            {"LeftUpperArm", "LeftLowerArm"},
            {"LeftLowerArm", "LeftHand"},
            {"RightUpperArm", "RightLowerArm"},
            {"RightLowerArm", "RightHand"},
            
            -- Legs
            {"LeftUpperLeg", "LeftLowerLeg"},
            {"LeftLowerLeg", "LeftFoot"},
            {"RightUpperLeg", "RightLowerLeg"},
            {"RightLowerLeg", "RightFoot"}
        }
        
        for _, connection in pairs(connections) do
            local part1 = character:FindFirstChild(connection[1])
            local part2 = character:FindFirstChild(connection[2])
            
            if part1 and part2 then
                local line = Instance.new("LineHandleAdornment")
                line.Name = connection[1] .. "_" .. connection[2]
                line.Adornee = humanoidRootPart
                line.AlwaysOnTop = true
                line.ZIndex = 2
                line.Color3 = getPlayerColor(player)
                line.Thickness = 1
                line.Length = (part1.Position - part2.Position).Magnitude
                line.CFrame = CFrame.lookAt(part1.Position, part2.Position)
                line.Visible = true
                line.Parent = skeletonFolder
            end
        end
    end
    
    -- Connect character updates
    character.ChildAdded:Connect(updateSkeleton)
    character.ChildRemoved:Connect(updateSkeleton)
    
    updateSkeleton()
end

-- Remove ESP for player
local function removeESP(player)
    if ESPObjects[player] then
        ESPObjects[player]:Destroy()
        ESPObjects[player] = nil
    end
end

-- Update all ESP
function updateESP()
    for player, espFolder in pairs(ESPObjects) do
        if espFolder and espFolder.Parent then
            -- Update colors
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
            
            -- Update skeleton
            local skeletonFolder = espFolder:FindFirstChild("Skeleton")
            if skeletonFolder then
                for _, line in pairs(skeletonFolder:GetChildren()) do
                    if line:IsA("LineHandleAdornment") then
                        line.Color3 = color
                        line.Visible = VisualsSettings.SkeletonESP
                    end
                end
            end
            
            -- Update glow
            local glow = espFolder:FindFirstChild("Glow")
            if glow then
                glow.FillColor = color
                glow.OutlineColor = color
                glow.Enabled = VisualsSettings.GlowESP
            end
        else
            ESPObjects[player] = nil
        end
    end
end

-- Main ESP loop
function startESPLoop()
    ESPLoop = RunService.Heartbeat:Connect(function()
        -- Clean up dead players
        for player, espFolder in pairs(ESPObjects) do
            if not Players:FindFirstChild(player.Name) or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
                removeESP(player)
            end
        end
        
        -- Add ESP for new players
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and not ESPObjects[player] and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                createESP(player)
            end
        end
        
        -- Update existing ESP
        updateESP()
        
        wait(VisualsSettings.RefreshRate)
    end)
end

-- Player connection handlers
Players.PlayerAdded:Connect(function(player)
    wait(2) -- Wait for character to load
    if player.Character then
        createESP(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

-- Initialize ESP for existing players
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createESP(player)
    end
end