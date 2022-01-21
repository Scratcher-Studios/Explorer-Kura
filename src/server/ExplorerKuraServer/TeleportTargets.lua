-- Creates a TeleportTarget which allows for teleportation. Licensed with Apache Version 2.0. See LICENSE for details. (c) 2022 Explorers of the Metaverse

--[=[
    @class TeleportTargets

    TeleportTargets is a server side module intended to facilitate teleportation of players to and from each other, as well as to a single spawn point or a spawn point set beforehand through [RespawnLocation](https://developer.roblox.com/en-us/api-reference/property/Player/RespawnLocation).
]=]

local obj = {}
obj.__index = obj
local Players = game:GetService("Players")
local Maid = require(script.Parent.Maid)

local USE_PIVOTTO = false -- I'll work on this eventually

local function Teleport(ToTeleport: Model, TeleportLocation: BasePart)
    if not USE_PIVOTTO then
        if not ToTeleport.PrimaryPart then
            warn("Primary part is not set on the model. Check the Roblox DevHub for details to rectify.") -- In future versions, a bounding box part will be created and will be set as a primary part.
        end
        ToTeleport:MoveTo(TeleportLocation.Position)
        print("teleported!")
    else
        error("PivotTo support is not implemented at this time, use Vector3 instead.")
    end
end

--[=[
    @within TeleportTargets
    Creates a TeleportTarget object.
    @param Target Player -- Player who the TeleportTarget is associated with.
    @return TeleportTarget
]=]

function obj.New(Target)
    local self = {}
    self.Target = Target
    self.__Maid = Maid.new()
    if Target:IsA("BasePart") then
        self.TargetPart = Target
        self.Type = "Part"
    elseif Players:GetPlayerFromCharacter(Target) or Target:IsA("Player") then
        if Target:IsA("Player")  then
            Target = Target.Character
            self.Target = Target
        end
        if Target then
            self.Type = "Player"
            local Player = Players:GetPlayerFromCharacter(Target)
            if Target:FindFirstChildWhichIsA("Humanoid") then
                self.TargetPart = Target:FindFirstChild("HumanoidRootPart")
                self.__Maid.CharacterAdded = Player.CharacterAdded:Connect(function(character)
                    self.TargetPart = character:FindFirstChild("HumanoidRootPart")
                    self.SpawnTargetPart = character.RespawnLocation
                end)
            end
        else
            warn("Character not detected!")
            return
        end
    elseif Target:IsA("Model") then
        self.TargetPart = Target
        self.Type = "Model"
    end
    setmetatable(self, obj)
    
    return self
end

--[=[
    @within TeleportTargets
    Teleports the Target of a TeleportTarget to another Target of a TeleportTarget. If no parameter is passed, the target is the spawnpoint of the character.
    @param TeleportTarget TeleportTarget | nil -- Player who the TeleportTarget is associated with.
]=]

function obj:TeleportTo(TeleportTarget)
    -- Honestly I should do type checking here. But I have decided not to for laziness.
    if self.Target:IsA("Model") then
        if TeleportTarget then
            if self.Type == "Player" then
                if TeleportTarget.TargetPart then
                    Teleport(self.Target, TeleportTarget.TargetPart)
                    print("teleport to player")
                else
                    print("no targetpart!")
                end
            else
                Teleport(self.Target, TeleportTarget.TargetPart)
                print("teleport to player")
            end
        else
            -- Assume teleport to spawn
            print("teleport to spawn")
            if self.Type == "Player" then
                -- TODO teleport to spawn logic
                local player = Players:GetPlayerFromCharacter(self.Target)
                if player.RespawnLocation then
                    Teleport(self.Target, player.RespawnLocation)
                else
                    local SpawnLocation = workspace:FindFirstChildWhichIsA("SpawnLocation", true)
                    if SpawnLocation then
                        Teleport(self.Target, SpawnLocation)
                    end
                end
            end
        end
    elseif self.Target:IsA("BasePart") then
        warn("Models only, no BaseParts.")
    else
        error("Unknown target type.")
    end
end

--[=[
    @within TeleportTargets
    Destroys object.
]=]

function obj:Destroy()
    self.__Maid = nil
end

return obj