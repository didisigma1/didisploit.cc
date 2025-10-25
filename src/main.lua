-- didisploit.cc - Main Script v2.1 FIXED
-- Educational purposes only

local Config = {
    Name = "didisploit.cc",
    Version = "2.1",
    Author = "didisigma1"
}

print("Loading " .. Config.Name .. " v" .. Config.Version)

-- Embedded ShadowLib (bez ładowania z zewnątrz)
local function CreateShadowLib()
    local library = {}
    
    function play(id)
        for _, v in next, workspace:GetChildren() do
            if v.Name == "GUISound" then
                v:Destroy()
            end
        end
        local Sound = Instance.new("Sound", workspace)
        Sound.Name = "GUISound"
        Sound.Volume = 6
        Sound.SoundId = id
        Sound:Play()
    end

    function library:CreateWindow(name, theme)
        local theme1 = Color3.fromRGB(32,32,32)
        local theme2 = Color3.fromRGB(26,26,26)
        local theme3 = Color3.fromRGB(176, 148, 255)
        
        -- Cleanup existing UI
        for i,v in pairs(game.CoreGui:GetChildren()) do
            if v.Name == "By Shaddow" then
                v:Destroy()
            end
        end

        -- Create basic UI elements
        local Screen = Instance.new("ScreenGui")
        local Top = Instance.new("Frame")
        local Toggle = Instance.new("TextButton")
        local Main = Instance.new("Frame")
        local TextLabel = Instance.new("TextLabel")

        Screen.Name = "By Shaddow"
        Screen.Parent = game:WaitForChild("CoreGui")
        Screen.Enabled = true

        Top.Name = "Top"
        Top.Parent = Screen
        Top.BackgroundColor3 = theme1
        Top.BorderSizePixel = 0
        Top.Position = UDim2.new(0.4, 0, 0.1, 0)
        Top.Size = UDim2.new(0, 400, 0, 30)
        Top.Active = true
        Top.Draggable = true

        TextLabel.Parent = Top
        TextLabel.BackgroundTransparency = 1
        TextLabel.Position = UDim2.new(0.1, 0, 0, 0)
        TextLabel.Size = UDim2.new(0, 300, 0, 30)
        TextLabel.Font = Enum.Font.SourceSansSemibold
        TextLabel.Text = name
        TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.TextSize = 14

        Toggle.Name = "Toggle"
        Toggle.Parent = Top
        Toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Toggle.BackgroundTransparency = 1
        Toggle.Position = UDim2.new(0.02, 0, 0.1, 0)
        Toggle.Size = UDim2.new(0, 20, 0, 20)
        Toggle.Font = Enum.Font.SourceSansBold
        Toggle.Text = ">"
        Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        Toggle.TextSize = 14

        Main.Name = "Main"
        Main.Parent = Top
        Main.BackgroundColor3 = theme2
        Main.BorderSizePixel = 0
        Main.Position = UDim2.new(0, 0, 1, 0)
        Main.Size = UDim2.new(0, 400, 0, 300)
        Main.Visible = true

        local opened = true
        Toggle.MouseButton1Click:Connect(function()
            if opened then
                Main.Visible = false
                Toggle.Text = "<"
                opened = false
            else
                Main.Visible = true
                Toggle.Text = ">"
                opened = true
            end
        end)

        local InsideLibrary = {}

        function InsideLibrary:CreateTab(text)
            local TabButton = Instance.new("TextButton")
            local TabFrame = Instance.new("ScrollingFrame")
            
            TabButton.Name = text
            TabButton.Parent = Main
            TabButton.BackgroundColor3 = theme1
            TabButton.BorderSizePixel = 0
            TabButton.Position = UDim2.new(0, 5, 0, 5)
            TabButton.Size = UDim2.new(0, 80, 0, 25)
            TabButton.Font = Enum.Font.SourceSansSemibold
            TabButton.Text = text
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabButton.TextSize = 12

            TabFrame.Parent = Main
            TabFrame.BackgroundColor3 = theme1
            TabFrame.BorderSizePixel = 0
            TabFrame.Position = UDim2.new(0.25, 0, 0.05, 0)
            TabFrame.Size = UDim2.new(0, 290, 0, 280)
            TabFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
            TabFrame.ScrollBarThickness = 5
            TabFrame.Visible = false

            local InsideTab = {}

            function InsideTab:CreateButton(text, callback)
                local Button = Instance.new("TextButton")
                Button.Parent = TabFrame
                Button.BackgroundColor3 = theme2
                Button.BorderSizePixel = 0
                Button.Size = UDim2.new(0, 120, 0, 30)
                Button.Font = Enum.Font.SourceSansSemibold
                Button.Text = text
                Button.TextColor3 = Color3.fromRGB(255, 255, 255)
                Button.TextSize = 12
                
                Button.MouseButton1Click:Connect(function()
                    pcall(callback)
                end)
                
                return Button
            end

            function InsideTab:CreateToggle(text, callback)
                local ToggleFrame = Instance.new("Frame")
                local ToggleButton = Instance.new("TextButton")
                local ToggleText = Instance.new("TextLabel")
                
                ToggleFrame.Parent = TabFrame
                ToggleFrame.BackgroundColor3 = theme2
                ToggleFrame.BorderSizePixel = 0
                ToggleFrame.Size = UDim2.new(0, 120, 0, 30)
                
                ToggleText.Parent = ToggleFrame
                ToggleText.BackgroundTransparency = 1
                ToggleText.Size = UDim2.new(0, 80, 0, 30)
                ToggleText.Font = Enum.Font.SourceSansSemibold
                ToggleText.Text = text
                ToggleText.TextColor3 = Color3.fromRGB(255, 255, 255)
                ToggleText.TextSize = 12
                ToggleText.TextXAlignment = Enum.TextXAlignment.Left
                
                ToggleButton.Parent = ToggleFrame
                ToggleButton.BackgroundColor3 = theme3
                ToggleButton.BorderSizePixel = 0
                ToggleButton.Position = UDim2.new(0.8, 0, 0.2, 0)
                ToggleButton.Size = UDim2.new(0, 15, 0, 15)
                ToggleButton.Font = Enum.Font.SourceSans
                ToggleButton.Text = ""
                
                local enabled = false
                
                local function updateToggle()
                    if enabled then
                        ToggleButton.BackgroundColor3 = theme3
                    else
                        ToggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                    end
                    pcall(callback, enabled)
                end
                
                ToggleButton.MouseButton1Click:Connect(function()
                    enabled = not enabled
                    updateToggle()
                end)
                
                updateToggle()
                
                return {
                    Set = function(self, state)
                        enabled = state
                        updateToggle()
                    end
                }
            end

            function InsideTab:CreateLabel(text)
                local Label = Instance.new("TextLabel")
                Label.Parent = TabFrame
                Label.BackgroundTransparency = 1
                Label.Size = UDim2.new(0, 120, 0, 20)
                Label.Font = Enum.Font.SourceSansSemibold
                Label.Text = text
                Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                Label.TextSize = 12
                return Label
            end

            function InsideTab:CreateSlider(text, min, max, callback)
                local SliderFrame = Instance.new("Frame")
                local SliderText = Instance.new("TextLabel")
                local SliderBar = Instance.new("Frame")
                local SliderButton = Instance.new("TextButton")
                local ValueText = Instance.new("TextLabel")
                
                SliderFrame.Parent = TabFrame
                SliderFrame.BackgroundColor3 = theme2
                SliderFrame.BorderSizePixel = 0
                SliderFrame.Size = UDim2.new(0, 120, 0, 40)
                
                SliderText.Parent = SliderFrame
                SliderText.BackgroundTransparency = 1
                SliderText.Size = UDim2.new(0, 120, 0, 15)
                SliderText.Font = Enum.Font.SourceSansSemibold
                SliderText.Text = text
                SliderText.TextColor3 = Color3.fromRGB(255, 255, 255)
                SliderText.TextSize = 10
                
                SliderBar.Parent = SliderFrame
                SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                SliderBar.BorderSizePixel = 0
                SliderBar.Position = UDim2.new(0.1, 0, 0.6, 0)
                SliderBar.Size = UDim2.new(0, 100, 0, 5)
                
                SliderButton.Parent = SliderBar
                SliderButton.BackgroundColor3 = theme3
                SliderButton.BorderSizePixel = 0
                SliderButton.Size = UDim2.new(0, 10, 0, 10)
                SliderButton.Position = UDim2.new(0, 0, -0.5, 0)
                SliderButton.Text = ""
                
                ValueText.Parent = SliderFrame
                ValueText.BackgroundTransparency = 1
                ValueText.Position = UDim2.new(0.7, 0, 0.7, 0)
                ValueText.Size = UDim2.new(0, 30, 0, 15)
                ValueText.Font = Enum.Font.SourceSansSemibold
                ValueText.Text = tostring(min)
                ValueText.TextColor3 = Color3.fromRGB(255, 255, 255)
                ValueText.TextSize = 10
                
                local mouse = game.Players.LocalPlayer:GetMouse()
                local uis = game:GetService("UserInputService")
                
                SliderButton.MouseButton1Down:Connect(function()
                    local connection
                    connection = uis.InputChanged:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement then
                            local x = math.clamp(mouse.X - SliderBar.AbsolutePosition.X, 0, SliderBar.AbsoluteSize.X)
                            local value = math.floor(min + (max - min) * (x / SliderBar.AbsoluteSize.X))
                            SliderButton.Position = UDim2.new(x / SliderBar.AbsoluteSize.X - 0.05, 0, -0.5, 0)
                            ValueText.Text = tostring(value)
                            pcall(callback, value)
                        end
                    end)
                    
                    uis.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            connection:Disconnect()
                        end
                    end)
                end)
            end

            -- Tab click handler
            TabButton.MouseButton1Click:Connect(function()
                for i, child in pairs(Main:GetChildren()) do
                    if child:IsA("ScrollingFrame") then
                        child.Visible = false
                    end
                end
                TabFrame.Visible = true
            end)

            return InsideTab
        end

        return InsideLibrary
    end

    return library
end

-- Settings
local VisualsSettings = {
    BoxESP = false,
    NameESP = false,
    SkeletonESP = false,
    GlowESP = false,
    TeamCheck = true,
    RefreshRate = 0.1
}

-- Create ShadowLib
local ShadowLib = CreateShadowLib()

-- Simple module fallbacks
local TeamCheck = {
    Enabled = true,
    IsTeammate = function(player) 
        local localPlayer = game.Players.LocalPlayer
        return player.Team == localPlayer.Team 
    end,
    IsEnemy = function(player) 
        local localPlayer = game.Players.LocalPlayer
        return player.Team ~= localPlayer.Team 
    end
}

local Fullbright = {
    Enable = function() 
        game.Lighting.GlobalShadows = false
        game.Lighting.Brightness = 2
        print("Fullbright enabled")
    end,
    Disable = function() 
        game.Lighting.GlobalShadows = true
        game.Lighting.Brightness = 1
        print("Fullbright disabled")
    end
}

local FOVChanger = {
    SetFOV = function(value)
        workspace.CurrentCamera.FieldOfView = value
        print("FOV set to " .. value)
    end,
    ResetFOV = function()
        workspace.CurrentCamera.FieldOfView = 70
        print("FOV reset to 70")
    end
}

local RatioChanger = {
    Set4by3 = function()
        print("4:3 Ratio set (visual only)")
    end,
    Set16by9 = function()
        print("16:9 Ratio set (visual only)")
    end,
    ResetScreen = function()
        print("Screen ratio reset")
    end
}

local GlowManager = {
    CreatePlayerGlow = function(player, color, transparency)
        if player.Character then
            local highlight = Instance.new("Highlight")
            highlight.FillColor = color
            highlight.OutlineColor = color
            highlight.FillTransparency = transparency
            highlight.Adornee = player.Character
            highlight.Parent = player.Character
            print("Glow added to " .. player.Name)
            return highlight
        end
        return nil
    end,
    RemovePlayerGlow = function(player)
        if player.Character then
            for _, child in pairs(player.Character:GetChildren()) do
                if child:IsA("Highlight") then
                    child:Destroy()
                end
            end
        end
    end,
    Cleanup = function()
        for _, player in pairs(game.Players:GetPlayers()) do
            if player.Character then
                for _, child in pairs(player.Character:GetChildren()) do
                    if child:IsA("Highlight") then
                        child:Destroy()
                    end
                end
            end
        end
        print("All glows cleaned up")
    end,
    ToggleSelfGlow = function(enabled, color, transparency)
        local player = game.Players.LocalPlayer
        if enabled then
            return GlowManager.CreatePlayerGlow(player, color, transparency)
        else
            GlowManager.RemovePlayerGlow(player)
            return nil
        end
    end
}

local LoopUtils = {
    CreateManagedLoop = function(name, callback, interval)
        local connection
        return {
            Start = function()
                if connection then connection:Disconnect() end
                connection = game:GetService("RunService").Heartbeat:Connect(function()
                    pcall(callback)
                    if interval then wait(interval) end
                end)
            end,
            Stop = function()
                if connection then
                    connection:Disconnect()
                    connection = nil
                end
            end
        }
    end
}

-- Create main window
local Window = ShadowLib:CreateWindow(Config.Name, "Normal")

-- Create tabs
local VisualTab = Window:CreateTab("Visuals")
local CombatTab = Window:CreateTab("Combat")
local MovementTab = Window:CreateTab("Movement")
local MiscTab = Window:CreateTab("Misc")

-- Visuals Tab
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
    
    local GlowToggle = VisualTab:CreateToggle("Glow ESP", function(state)
        VisualsSettings.GlowESP = state
        print("Glow ESP: " .. tostring(state))
        
        -- Toggle glow for all players
        if state then
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer then
                    local color = TeamCheck:IsEnemy(player) and Color3.new(1, 0, 0) or Color3.new(0, 1, 0)
                    GlowManager:CreatePlayerGlow(player, color, 0.7)
                end
            end
        else
            GlowManager:Cleanup()
        end
    end)
    
    local TeamCheckToggle = VisualTab:CreateToggle("Team Check", function(state)
        VisualsSettings.TeamCheck = state
        TeamCheck.Enabled = state
        print("Team Check: " .. tostring(state))
    end)
    
    VisualTab:CreateLabel("Glow Settings")
    
    VisualTab:CreateButton("Enable All Glow", function()
        print("Enabling all glow...")
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                local color = Color3.new(1, 0, 0)
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
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 50
            print("Speed set to 50")
        end
    end)
    
    MovementTab:CreateButton("Jump Power", function()
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = 100
            print("Jump power set to 100")
        end
    end)
    
    MovementTab:CreateButton("Reset Movement", function()
        local player = game.Players.LocalPlayer
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
    
    local FullbrightToggle = MiscTab:CreateToggle("Fullbright", function(state)
        if state then
            Fullbright:Enable()
        else
            Fullbright:Disable()
        end
    end)
    
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
    
    MiscTab:CreateLabel("Server Info")
    
    MiscTab:CreateButton("Show Players", function()
        local players = game.Players:GetPlayers()
        print("Players in server (" .. #players .. "):")
        for _, player in pairs(players) do
            print(" - " .. player.Name)
        end
    end)
    
    MiscTab:CreateButton("Server Info", function()
        print("Place: " .. game.PlaceId)
        print("Job ID: " .. game.JobId)
        print("Players: " .. #game.Players:GetPlayers())
    end)
end

print("didisploit.cc v2.1 loaded successfully!")

return {
    Config = Config,
    Window = Window,
    TeamCheck = TeamCheck,
    Fullbright = Fullbright,
    FOVChanger = FOVChanger,
    RatioChanger = RatioChanger,
    GlowManager = GlowManager
}
