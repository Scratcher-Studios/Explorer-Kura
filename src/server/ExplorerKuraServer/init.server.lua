--!strict

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
local TextService = game:GetService("TextService")

-- local TESTING_MODE = 1 -- Set to false or 0 to disable, or 1 for Educator or 2 for Student
local PartyTable = table.create(Players.MaxPlayers)
local Educator

local ExplorerGetters = Instance.new("Folder")
ExplorerGetters.Name = "ExplorerFunctions"
ExplorerGetters.Parent = game:GetService("ServerStorage")

local TeleportTargets = require(script.TeleportTargets)
local PlayerTeleportTargets = table.create(Players.MaxPlayers)
local GetTeleportTargets = Instance.new("BindableFunction")
GetTeleportTargets.Name = "GetTeleportTargets"
GetTeleportTargets.Parent = ExplorerGetters
GetTeleportTargets.OnInvoke = function()
    return TeleportTargets
end

local MutedPlayersModule = require(script.MutedPlayers)
local MutedPlayers = table.create(Players.MaxPlayers)
local GetMutedPlayers = Instance.new("BindableFunction")
GetMutedPlayers.Name = "GetMutedPlayers"
GetMutedPlayers.Parent = ExplorerGetters
GetMutedPlayers.OnInvoke = function()
    return MutedPlayers
end

local LocatorsModule = require(script.LocatorsServer)
local Locators = table.create(Players.MaxPlayers)
local GetLocators = Instance.new("BindableFunction")
GetLocators.Name = "GetLocators"
GetLocators.Parent = ExplorerGetters
GetLocators.OnInvoke = function()
    return MutedPlayers
end

local QuickActionsServerEvents = table.create(5) -- 5 is just an arbritrary number that I chose. Probably should do this based on # of QuickActions

local function CopyDict(original)
	local copy = {}
	for k, v in pairs(original) do
		if type(v) == "table" then
			v = CopyDict(v)
		end
		copy[k] = v
	end
	return copy
end

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
                    MutedPlayers[arg.Player]:Mute()
                    RE:FireClient(player, {"UpdateMutedState", arg.Player, true})
                elseif arg.Action == "Unmute" then
                    MutedPlayers[arg.Player]:Unmute()
                    RE:FireClient(player, {"UpdateMutedState", arg.Player, false})
                else
                    error("Action arg " ..arg.Action .." not found.")
                end
            end
        elseif command == "QuickActions" then
            if typeof(arg) == "table" then
                if QuickActionsServerEvents[arg[1]] then
                    QuickActionsServerEvents[arg[1]](player, {["TeleportTargets"] = PlayerTeleportTargets; ["MutedPlayers"] = MutedPlayers; ["Locators"] = Locators;},arg[2])
                end
            end  
        end
    end
    if command == "ShowLocators" then
        if Educator == player and typeof(arg) == "table" then
            if Locators[arg[1]] then
                if Locators[arg[1]] == Educator then
                    Locators[arg[1]]:ShowLocator(true, Educator, true)
                else
                    Locators[arg[1]]:ShowLocator(true, Educator)
                end
            end
        else
            Locators[player]:ShowLocator(false, Educator)
        end
    elseif command == "HideLocators" then
        if Educator == player and arg[1] then
            if Locators[arg[1]] then
                if Locators[arg[1]] == Educator then
                    Locators[arg[1]]:HideLocator(true, Educator, true)
                else
                    Locators[arg[1]]:HideLocator(true, Educator)
                end
            end
        else
            Locators[player]:HideLocator(false, Educator)
        end
    end
end)

local RF = Instance.new("RemoteFunction")
RF.Name = "KuraRF"
RF.Parent = ReplicatedStorage

RF.OnServerInvoke = function(player: userdata, command: string, arg: table)
    if command == "CanUseKura" then
        --[[
        if typeof(TESTING_MODE) == "number" then
            if TESTING_MODE == 1 then
                Educator = player
            end
            return if TESTING_MODE == 0 then false else TESTING_MODE
        else
            if Educator == player then
                for _, v in ipairs(Players:GetPlayers()) do
                    if v ~= Educator then
                        RE:FireClient(v, {"KuraSetup", 2})
                    end
                end
                return 1
            elseif Educator then
                return 2
            else
                return
            end
        end
        ]]
        if not Educator then
            Educator = player
            return 1
        else
            return 2
        end
    elseif command == "LatestKuraVersion" then
        return require(8169284660)
    elseif command == "Announcement" then
        if typeof(arg.AnnouncementType) == "string" and player == Educator then
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
    elseif command == "QuickActions" and player == Educator then
        if arg.ActionType == "RequestActionList" then
            assert(ReplicatedStorage:FindFirstChild("ExplorerKuraQuickActions"), "QuickActions not found.")
            local QuickActionsTable = {}
            for _, ModuleScript in ipairs(ReplicatedStorage.ExplorerKuraQuickActions:GetChildren()) do
                task.spawn(function()
                    assert(ModuleScript:IsA("ModuleScript"), "Quick Action scripts must be a ModuleScript.")
                    local QuickAction = CopyDict(require(ModuleScript))
                    assert(typeof(QuickAction) == "table", "Quick Action module must return a table.")
                    if typeof(QuickAction.FriendlyName) == "table" then
                        assert(typeof(QuickAction.FriendlyName[true]) == "string" and typeof(QuickAction.FriendlyName[false]) == "string", "QuickAction must have strings for both true and false states of FriendlyName.")
                        -- Bit of a weird fix but Remotes are weird like that
                        QuickAction.FriendlyName = {}
                    else
                        assert(typeof(QuickAction.FriendlyName) == "string", "FriendlyName of QuickAction must be a string.")
                    end
                    if typeof(QuickAction.Image) ~= "string" then
                        QuickAction.Image = "rbxassetid://8129843059" -- Default replacement image
                        warn("Image is not a string.")
                    end
                    QuickAction.Script = ModuleScript.Name
                    if typeof(QuickAction.ServerInvoke) == "function" then
                        -- Not currently supported and probably never will be
                    end
                    if typeof(QuickAction.ServerEvent) == "function" then
                        QuickActionsServerEvents[QuickAction.Script] = QuickAction.ServerEvent
                    end
                    assert(typeof(QuickAction.ClientFunction) == "function", "QuickAction nust pass through a client function.")
                    if not typeof(QuickAction.DefaultState) == "boolean" then
                        warn("Default state not set, automatically setting to false. Explicitly set default state to disable.")
                    end
                    QuickActionsTable[QuickAction.Script] = CopyDict(QuickAction)
                end)
            end
            return QuickActionsTable
        elseif arg.ActionType == "InvokeServer" then
            -- Ignore
        end
    end
end

local function PlayerJoinFunc(player: Player)
    local PlayerJoinData = player:GetJoinData()
    if PlayerJoinData.SourcePlaceId == 2901715109 or PlayerJoinData.SourcePlaceId == 3088421028 then
        -- So they joined from an Explorer Place Id
        if PlayerJoinData.TeleportData then
            if PlayerJoinData.TeleportData.GroupJoinTeleport then
                PartyTable = CopyDict(PlayerJoinData.TeleportData.GroupJoinPlayers)
                for i, player in ipairs(PartyTable) do
                    if i == 1 then
                        Educator = player
                    end
                end
            end
        end
    elseif game.PrivateServerId ~= 0 then
        if player.UserId == game.PrivateServerOwnerId then
            Educator = player
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
        MutedPlayers[player] = MutedPlayersModule.New(player)
        local character = player.Character or player.CharacterAdded:Wait()
        PlayerTeleportTargets[player] = TeleportTargets.New(player)
        Locators[player] = LocatorsModule.New(player)
    end))
end

Players.PlayerAdded:Connect(PlayerJoinFunc)

Players.PlayerRemoving:Connect(function(player)
    PlayerTeleportTargets[player]:Destroy()
    Locators[player]:Destroy()
    MutedPlayers[player]:Destroy()
end)

for _, v in pairs(Players:GetPlayers()) do
    PlayerJoinFunc(v)
end