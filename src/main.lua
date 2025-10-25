-- SIMPLE FIX - jeśli powyższe nie działa
local Config = {
    Name = "didisploit.cc",
    Version = "2.1", 
    Author = "didisigma1"
}

print("Loading " .. Config.Name .. " v" .. Config.Version)

-- Load and IMMEDIATELY call Shadow Lib
local ShadowLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/didisigma1/didisploit.cc/main/src/libs/shadowlib.lua"))()

-- Now create window
local Window = ShadowLib:CreateWindow(Config.Name, "Normal")
print("Theme selected: Normal")

-- Rest of your code...
local VisualTab = Window:CreateTab("Visuals")
VisualTab:CreateButton("Test", function()
    print("Working! 🎉")
end)

print("didisploit.cc loaded!")
