-- Muted players module. Licensed with Apache Version 2.0. See LICENSE for details. (c) 2022 Explorers of the Metaverse

--[=[
    @class MutedPlayers
    Handles muting and unmuting of players server-side.
    :::note
    This module relies on Kura Remote Events.
    :::
]=]

local obj = {}
obj.__index = obj

local Maid = require(script.Parent.Maid)

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RE

task.spawn(function()
    RE = ReplicatedStorage:WaitForChild("KuraRE")
end)

--[=[
    @within MutedPlayers
    Creates a new MutedPlayer object associated with the specific player
    @param Target Player -- Player which the MutedPlayer object is associated with
    @return MutedPlayer
]=]

function obj.New(Target)
    local self = {}
    self.Target = Target
    self.__Maid = Maid.new()

    self.Muted = false

    setmetatable(self, obj)
    return self
end

--[=[
    @within MutedPlayers
    Mutes player. This is handled by the client.
    :::caution
    No manual server-side checks are being performed for the muted player currently when they chat, although this may change in future releases of Kura.
    :::
]=]

function obj:Mute()
    RE:FireClient(self.Target, {"Mute"})
    self.Muted = true
end

--[=[
    @within MutedPlayers
    Unmutes player. This is handled by the client.
]=]

function obj:Unmute()
    self.Muted = false
    RE:FireClient(self.Target, {"Unmute"})
end
--[=[
    @within MutedPlayers
    Destroys object.
]=]

function obj:Destroy()
    self.__Maid = nil
    obj = nil
end

return obj