-- Loop Utilities for didisploit.cc

local LoopUtils = {}

-- Creates a managed loop that can be easily stopped/restarted
function LoopUtils:CreateManagedLoop(name, callback, interval)
    local loop = {
        Name = name,
        Running = false,
        Connection = nil
    }
    
    function loop:Start()
        if self.Running then return end
        self.Running = true
        
        self.Connection = game:GetService("RunService").Heartbeat:Connect(function()
            local success, err = pcall(callback)
            if not success then
                warn("Loop " .. self.Name .. " error: " .. err)
            end
            if interval and interval > 0 then
                wait(interval)
            end
        end)
    end
    
    function loop:Stop()
        if self.Connection then
            self.Connection:Disconnect()
            self.Connection = nil
        end
        self.Running = false
    end
    
    function loop:Restart()
        self:Stop()
        self:Start()
    end
    
    return loop
end

-- Fast loop for ESP updates
function LoopUtils:CreateFastESPUpdate(callback, refreshRate)
    refreshRate = refreshRate or 0.1
    
    return self:CreateManagedLoop("ESPUpdate", function()
        callback()
    end, refreshRate)
end

-- Cleanup loop for removing old ESP objects
function LoopUtils:CreateCleanupLoop(callback)
    return self:CreateManagedLoop("ESPCleanup", function()
        callback()
    end, 5) -- Clean every 5 seconds
end

return LoopUtils