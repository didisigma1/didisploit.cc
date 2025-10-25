-- didisploit.cc - Main Script v2.1
-- Educational purposes only

local Config = {
    Name = "didisploit.cc",
    Version = "2.1",
    Author = "didisigma1"
}

print("Loading " .. Config.Name .. " v" .. Config.Version)

-- Load Shadow Library from GitHub with debugging
print("Loading Shadow Lib...")
local shadowLibCode = game:HttpGet("https://raw.githubusercontent.com/didisigma1/didisploit.cc/main/src/libs/shadowlib.lua")
print("Shadow Lib code downloaded, length: " .. #shadowLibCode)

local ShadowLib = loadstring(shadowLibCode)
print("Shadow Lib loaded")

local Window = ShadowLib:CreateWindow(Config.Name, "Normal")
print("Window created")

-- DEBUG: Check what methods Window has
print("Window methods:")
for k,v in pairs(Window) do
    print("  " .. k .. ": " .. type(v))
end

-- Try to create tab
print("Creating Visuals tab...")
local VisualTab = Window:CreateTab("Visuals")
print("Visuals tab created")

print("Creating Combat tab...")
local CombatTab = Window:CreateTab("Combat")
print("Combat tab created")

print("Creating Movement tab...")
local MovementTab = Window:CreateTab("Movement")
print("Movement tab created")

print("Creating Misc tab...")
local MiscTab = Window:CreateTab("Misc")
print("Misc tab created")

-- Simple test button
VisualTab:CreateButton("Test Button", function()
    print("Test button clicked!")
end)

print("didisploit.cc v2.1 loaded successfully!")

return Config
