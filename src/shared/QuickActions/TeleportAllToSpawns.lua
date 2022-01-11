local module = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

module.FriendlyName = "Teleport All To Me"

module.DefaultState = false

module.Image = "rbxassetid://8188132256"

module.ClientFunction = function()
    print("teleporting everyone to their spawns")
    return nil, true
end

module.ServerEvent = function()
    local TeleportTargets = ServerScriptService.ExplorerKuraServer.GetMutedPlayers:Invoke()
    for _, obj in ipairs(TeleportTargets) do
        obj:TeleportTo()
    end
end

return module