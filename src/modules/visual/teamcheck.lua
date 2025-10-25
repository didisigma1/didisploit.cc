-- Team Check Module for didisploit.cc

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local TeamCheck = {
    Enabled = true
}

function TeamCheck:IsTeammate(player)
    if not self.Enabled then
        return false
    end
    
    -- Check if teams exist in the game
    if not LocalPlayer.Team or not player.Team then
        return false
    end
    
    return LocalPlayer.Team == player.Team
end

function TeamCheck:IsEnemy(player)
    if not self.Enabled then
        return true
    end
    
    return not self:IsTeammate(player)
end

return TeamCheck