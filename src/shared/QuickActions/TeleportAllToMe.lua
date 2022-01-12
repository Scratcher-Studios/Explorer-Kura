local module = {}

local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

module.FriendlyName = "Teleport All To Me"

module.DefaultState = false

module.Image = "rbxassetid://8188132383"

module.ClientFunction = function()
    print("teleporting everyone to self")
    return nil, Players.LocalPlayer
end

module.ServerEvent = function(player, ExplorerArgs)
    local TeleportTargets = ExplorerArgs.TeleportTargets
    local EducatorTeleportTarget = TeleportTargets[player]
    for _, obj in ipairs(TeleportTargets) do
        obj:TeleportTo(EducatorTeleportTarget)
    end
end

return module