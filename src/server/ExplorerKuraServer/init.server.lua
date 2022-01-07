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

--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GroupService = game:GetService("GroupService")
local TextService = game:GetService("TextService")

local TESTING_MODE = 1 -- Set to false or 0 to disable, or 1 for Educator or 2 for Student
local PartyTable = table.create(Players.MaxPlayers)
local Educator

local PlayerTeleportTargets = table.create(Players.MaxPlayers)
local TeleportTargets = require(script.TeleportTargets)

local RE = Instance.new("RemoteEvent")
RE.Name = "KuraRE"
RE.Parent = ReplicatedStorage

RE.OnServerEvent:Connect(function(player: Player, command: string, arg)
    if player == Educator then
        -- print(command, arg)
        if command == "PlayerFrames" then
            if typeof(arg.Action) == "string" then
                if arg.Action == "TeleportTo" then
                    if arg.Target then
                        PlayerTeleportTargets[player]:TeleportTo(PlayerTeleportTargets[arg.Target])
                    end
                elseif arg.Action == "TeleportFrom" then
                    if arg.Target then
                        PlayerTeleportTargets[arg.Target]:TeleportTo(PlayerTeleportTargets[player])
                    end
                elseif arg.Action == "Mute" then
                    RE:FireClient(arg.Player, {"Mute"})
                elseif arg.Action == "Unmute" then
                    RE:FireClient(arg.Player, {"Unmute"})
                elseif arg.Action == "ShowLocator" then

                elseif arg.Action == "HideLocator" then

                else
                    error("Action arg " ..arg.Action .." not found.")
                end
            end
        end
    end
end)

local RF = Instance.new("RemoteFunction")
RF.Name = "KuraRF"
RF.Parent = ReplicatedStorage

RF.OnServerInvoke = function(player: userdata, command: string, arg: table)
    if command == "CanUseKura" then
        if typeof(TESTING_MODE) == "number" then
            Educator = player
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
    elseif command == "LatestKuraVersion" then
        return require(8169284660)
    elseif command == "Announcement" then
        if typeof(arg.AnnouncementType) == "string" then
            local message: string
            local success, errorString = pcall(function()
                local MessageFilterResult = TextService:FilterStringAsync(arg.Message, player.UserId, Enum.TextFilterContext.PublicChat)
                message = MessageFilterResult:GetNonChatStringForBroadcastAsync()
            end)
            if success then
                -- print("filter success")
                RE:FireAllClients({"Announcement", arg.AnnouncementType, message})
                return 0
            else
                -- print("filter failure")
                warn(errorString)
                return 1
            end
        else
            -- print("announcementtype not string")
            return 1
        end
    elseif command == "QuickActions" then
        if arg.ActionType == "RequestActionList" then
            local QuickActionsTable = {}
            for _, ModuleScript in pairs(script.QuickActions:GetChilren()) do
                task.spawn(function()
                    assert(ModuleScript:IsA("ModuleScript"), "Quick Action scripts must be a ModuleScript.")
                    local QuickAction = require(ModuleScript)
                    assert(typeof(QuickAction) == "table", "Quick Action module must return a table.")
                    assert(typeof(QuickAction.Name) == "string", "Name of QuickAction must be a string.")
                    if typeof(QuickAction.Image) ~= "string" then
                        QuickAction.Image = "rbxassetid://8129843059" -- Default replacement image
                        warn("Image is not a string.")
                    end
                    QuickAction.Script = ModuleScript
                    QuickActionsTable[QuickAction.Name] = QuickAction
                end)
            end
            return QuickActionsTable
        elseif arg.ActionType == "InvokeServer" then

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

local function PlayerJoinFunc(player: Player)
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
    coroutine.resume(coroutine.create(function()
        local character = player.Character or player.CharacterAdded:Wait()
        PlayerTeleportTargets[player] = TeleportTargets.New(player)
        print("TeleportTarget added!")
    end))
end

Players.PlayerAdded:Connect(PlayerJoinFunc)

Players.PlayerRemoving:Connect(function(player)
    PlayerTeleportTargets[player]:Destroy()
end)

for _, v in pairs(Players:GetPlayers()) do
    PlayerJoinFunc(v)
end