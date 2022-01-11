local module = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

module.FriendlyName = "Teleport All To Me"

module.DefaultState = false

module.Image = "rbxassetid://8188132383"

module.ClientFunction = function()
    print("teleporting everyone to self")
    return nil, Players.LocalPlayer
end

module.ServerEvent = function(player)
    local TeleportTargets = ServerScriptService.ExplorerKuraServer.GetMutedPlayers:Invoke()
    local EducatorTeleportTarget = TeleportTargets[player]
    for _, obj in ipairs(TeleportTargets) do
        obj:TeleportTo(EducatorTeleportTarget)
    end
end

return module