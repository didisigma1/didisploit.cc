-- didisploit.cc - ULTIMATE FIX
local Config = {Name = "didisploit.cc", Version = "2.1"}

print("Loading " .. Config.Name)

-- Try direct execution
local success, lib = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/didisigma1/didisploit.cc/main/src/libs/shadowlib.lua"))()
end)

if success then
    print("ShadowLib loaded, type: " .. type(lib))
    
    -- If it's a function, call it
    if type(lib) == "function" then
        lib = lib()
    end
    
    -- If it's a table, create window
    if type(lib) == "table" then
        local window = lib:CreateWindow(Config.Name, "Normal")
        window:CreateTab("Test"):CreateButton("Click", function()
            print("DZIAŁA! 🎉")
        end)
    end
else
    print("ERROR: " .. lib)
end
