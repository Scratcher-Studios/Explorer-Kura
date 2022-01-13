--[[
    Example Quick Actions module for demonstration purposes. Licensed with Apache Version 2.0. See LICENSE for details. (c) 2022 Explorers of the Metaverse
    Asterisks denote mandatory key/value pairs for the module to work. Omitting others still work but will spit out a warning.
]]

local module = {}

-- Specify services here

local ReplicatedStorage = game:GetService("ReplicatedStorage")


-- * FriendlyName can either be a fixed string or can vary depending on state, where a table with boolean keys is used.
module.FriendlyName = {[true] = "On"; [false] = "Off"}

-- Specifies default state of the Quick Action module.
module.DefaultState = false

-- Add an image to the button. If not specified, a default specified in ExplorerKuraClient(/init.client.lua) is used instead.
module.Image = nil

-- * Function that is run on the client. Return a boolean to change state (or nil if you don't) and add arguments to pass onto ServerEvent.
module.ClientFunction = function(onState: boolean) -- onState basically is the current value of the state of the button.
    if onState then
        return false, nil -- OnStateResult, FireServer
    else
        return true, nil -- OnStateResult, FireServer
    end
end

-- Function that runs on the server.
module.ServerEvent = function(player: Player, ExplorerArgs, ClientArgs) -- player is the player requesting the function (which is only the educator currently), ExplorerArgs are tables that ExplorerKuraServer stores whilst ClientArgs are arguments passed over by the ClientFunction.

end

return module