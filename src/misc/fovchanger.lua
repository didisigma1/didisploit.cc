-- FOV Changer Module
local FOVChanger = {}

local Camera = workspace.CurrentCamera
local DefaultFOV = 70

function FOVChanger:SetFOV(value)
    if value and type(value) == "number" then
        Camera.FieldOfView = value
        return true
    end
    return false
end

function FOVChanger:ResetFOV()
    Camera.FieldOfView = DefaultFOV
end

function FOVChanger:GetCurrentFOV()
    return Camera.FieldOfView
end

function FOVChanger:GetDefaultFOV()
    return DefaultFOV
end

return FOVChanger