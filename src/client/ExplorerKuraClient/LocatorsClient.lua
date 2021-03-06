--[=[
	@class LocatorsClient

	Stores locator information client-side and displays locators.
	:::caution
	This module uses [Fusion](https://elttob.github.io/Fusion/). If using this module is used in another project, Fusion must be installed and the path to Fusion must be changed.
	:::
]=]

local obj = {}
obj.__index = obj
local Players = game:GetService("Players")
local CharacterConnections = table.create(Players.MaxPlayers)

local Fusion = require(script.Parent.Fusion)
local New = Fusion.New
local Children = Fusion.Children

--[=[
	@within LocatorsClient
	Creates LocatorClient object. No paramaters are passed as it is associated with the game rather than a specific player.
	@return LocatorClient
]=]

function obj.New()
	local self = table.create(Players.MaxPlayers)
	local function OnPlayerAdded(player)
		local function AddGui()
			local rootpart = player.Character:WaitForChild("HumanoidRootPart")
			local BillboardGui = New "BillboardGui" {
				Parent = rootpart;
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
				AlwaysOnTop = true;
				ClipsDescendants = true;
				LightInfluence = 0;
				Size = UDim2.fromOffset(150, 100);
				StudsOffsetWorldSpace = Vector3.new(0, 5, 0);
				Enabled = false;
				[Children] = {
					New "ImageLabel" {
						AnchorPoint = Vector2.new(0.5, 0);
						BackgroundColor3 = Color3.new(1, 1, 1);
						BackgroundTransparency = 1;
						Position = UDim2.fromScale(0.5, 0);
						Size = UDim2.fromScale(1, 0.75);
						Image = "rbxassetid://8127902577";
						ScaleType = Enum.ScaleType.Fit;
					};
					New "TextLabel" {
						AnchorPoint = Vector2.new(0.5, 1);
						BackgroundColor3 = Color3.new(1, 1, 1);
						BackgroundTransparency = 1;
						Position = UDim2.fromScale(0.5, 1);
						Size = UDim2.fromScale(1, 0.25);
						Font = Enum.Font.GothamBold;
						TextColor3 = Color3.new(1, 1, 1);
						TextScaled = true;
						TextStrokeTransparency = 0;
						Text = player.DisplayName;
					}
				};
			}
			self[player] = BillboardGui
		end
		if player.Character then
			AddGui()
		end
		CharacterConnections[player] = player.CharacterAdded:Connect(AddGui)
	end
	Players.PlayerAdded:Connect(OnPlayerAdded)
	for _, player in pairs(Players:GetPlayers()) do
		OnPlayerAdded(player)
	end
	Players.PlayerRemoving:Connect(function(player)
		CharacterConnections[player]:Disconnect()
	end)
	setmetatable(self, obj)
	return self
end

--[=[
	@within LocatorsClient
	Shows locator of a specific player.
	@param player Player -- Player which the Locator is associated with.
]=]

function obj:ShowLocator(player)
	if self[player] then
		self[player].Enabled = true
	else
		warn("unable to find player billboardgui")
	end
end

--[=[
	@within LocatorsClient
	Hides locator of a specific player.
	@param player Player -- Player which the Locator is associated with.
]=]

function obj:HideLocator(player)
	if self[player] then
		self[player].Enabled = false
	else
		warn("unable to find player billboardgui")
	end
end

--[=[
	@within LocatorsClient
	Gets if locator of a specific player is enabled.
	@param player Player -- Player which the Locator is associated with.
]=]

function obj:GetPlayerLocatorStatus(player)
	if self[player] then
		return self[player].Enabled
	else
		return
	end
end

return obj