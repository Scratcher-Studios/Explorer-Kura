local module = {}

local ServerStorage = game:GetService("ServerStorage")

module.FriendlyName = "Teleport All To Spawns"

module.DefaultState = false

module.Image = "rbxassetid://8188132256"

module.ClientFunction = function()
    print("teleporting everyone to their spawns")
    return nil, true
end

module.ServerEvent = function(_, ExplorerArgs)
    local TeleportTargets = ExplorerArgs.TeleportTargets
    for player, obj in pairs(TeleportTargets) do
        obj:TeleportTo()
    end
end

return module