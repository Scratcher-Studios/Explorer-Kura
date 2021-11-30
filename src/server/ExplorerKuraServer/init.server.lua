--[[

Copyright 2022 Explorers of the Metaverse

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       [redacted]

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GroupService = game:GetService("GroupService")

local TESTING_MODE = 1 -- Set to false or 0 to disable, or 1 for Educator or 2 for Student
local PartyTable
local Educator

local RE = Instance.new("RemoteEvent")
RE.Name = "KuraRE"
RE.Parent = ReplicatedStorage

RE.OnServerEvent:Connect(function(player, command, arg)
    
end)

local RF = Instance.new("RemoteFunction")
RF.Name = "KuraRF"
RF.Parent = ReplicatedStorage

RF.OnServerInvoke = function(player, command, arg)
    if command == "CanUseKura" then
        if typeof(TESTING_MODE) == "number" then
            return if TESTING_MODE == 0 then false else TESTING_MODE
        else
            if Educator == player then
                return 1
            elseif Educator then
                return 2
            else
                return
            end
        end
    end
end

local function UpdatePlayerPermissions(educator)
    if PartyTable then
        for i, player in pairs(PartyTable) do
            if i == 1 then
                
            end
        end
    else
        Educator = educator
    end
end

local function PlayerJoinFunc(player)
    local PlayerJoinData = player:GetJoinData()
    if PlayerJoinData.SourcePlaceId == 2901715109 or PlayerJoinData.SourcePlaceId == 3088421028 then
        -- So they joined from an Explorer Place Id
        if PlayerJoinData.TeleportData then
            if PlayerJoinData.TeleportData.GroupJoinTeleport then
                PartyTable = PlayerJoinData.TeleportData.GroupJoinPlayers
                UpdatePlayerPermissions()
            end
        end
    elseif game.PrivateServerId ~= 0 then
        if player.UserId == game.PrivateServerOwnerId then
            UpdatePlayerPermissions(player)
        end
    end
    if Educator then
        if Educator == player then
            RE:Fire({"KuraSetup", 1})
        else
            RE:Fire({"KuraSetup", 2})
        end
    end
end

Players.PlayerAdded:Connect(PlayerJoinFunc)