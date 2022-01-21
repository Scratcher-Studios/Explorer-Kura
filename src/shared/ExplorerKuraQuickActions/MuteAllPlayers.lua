-- Mutes everyone. Licensed with Apache Version 2.0. See LICENSE for details. (c) 2022 Explorers of the Metaverse

local module = {}

local KuraRE = game:GetService("ReplicatedStorage"):WaitForChild("KuraRE")

module.FriendlyName = "Mute All"

module.DefaultState = false

module.Image = "rbxassetid://8127902088"

module.ClientFunction = function(_)
    return nil, true
end

module.ServerEvent = function(player, ExplorerArgs)
    for k, v in pairs(ExplorerArgs.MutedPlayers) do
        v:Mute()
        KuraRE:FireClient(player, {"UpdateMutedState", k, true})
    end
end

return module