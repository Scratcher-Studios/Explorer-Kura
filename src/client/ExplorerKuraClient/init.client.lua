--[[

Copyright 2021 Explorers of the Metaverse

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

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GroupService = game:GetService("GroupService")
local Players = game:GetService("Players")
local Icon

local Fusion = require(ReplicatedStorage:FindFirstChild("Fusion") or script.Fusion)
State = Fusion.State

local TInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut, 0, false, 0)

if ReplicatedStorage:FindFirstChild("TopbarPlusReference") then
    Icon = require(ReplicatedStorage.TopbarPlusReference.Value)
else
    Icon = require(script.Icon)
end

local KuraRE = ReplicatedStorage:WaitForChild("KuraRE")
local KuraRF = ReplicatedStorage:WaitForChild("KuraRF")

local CanUse = KuraRF:InvokeServer("CanUseKura")
local ButtonsToggled = {}

if not CanUse then
    script:Destroy()
end

-- UI creation time!

local CurrentTab = State("nil")
local BlackState = State(Color3.fromRGB(0,0,0))
local WhiteState = State(Color3.fromRGB(255,255,255))
local GreyState = State(Color3.fromRGB(30,30,30))

local ScreenGui = Fusion.New "ScreenGui" {
    DisplayOrder = 1000;
    IgnoreGuiInset = false;
    Name = "ExplorerKuraGui";
    Enabled = true;
    Parent = Players.LocalPlayer.PlayerGui;
}

local ContainerPosition = State(UDim2.new(0.5, 0, -0.5, -30))

local ExplorerKuraContainer = Fusion.New "Frame" {
    Name = "ExplorerKuraContainer";
    Size = UDim2.new(0.5, 0, 0.3, 0);
    AnchorPoint = Vector2.new(0.5, 0);
    Position = Fusion.Tween(ContainerPosition, TInfo);
    BackgroundTransparency = 1;
    Visible = true;
    Parent = ScreenGui;
    [Fusion.Children] = {
        Fusion.New "Frame" {
            Name = "Topbar";
            Size = UDim2.new(1,0,0,30);
            AnchorPoint = Vector2.new(0.5,0);
            Position = UDim2.new(0.5,0,0,0);
            BackgroundColor3 = Color3.fromRGB(0,0,0);
            BorderSizePixel = 0;
            Visible = true;
            [Fusion.Children] = {
                Fusion.New("UIListLayout") {
                    Padding = UDim.new(0, 5)
                };
            };
        };
    };
}

local function CreateSection(props)
    return Fusion.New "ScrollingFrame" {
        Name = props.Name;
        Size = UDim2.new(1,0,0,-30);
        AnchorPoint = Vector2.new(0.5, 0);
        Position = UDim2.new(0.5,0,0,30);
        Parent = ExplorerKuraContainer;
        Visible = Fusion.Computed(function()
            if CurrentTab:get() == props.Name then
                return true
            else
                return false
            end
        end);
        BackgroundColor3 = Color3.fromRGB(30,30,30);
        BackgroundTransparency = 0.3;
        BorderSizePixel = 0;
        AutomaticCanvasSize = Enum.AutomaticSize.Y;
    }, Fusion.New "TextButton" {
        Text = "";
        Size = UDim2.new(0.2,0,1,-5);
        Parent = ExplorerKuraContainer.Topbar;
        BackgroundTransparency = 0;
        AutoButtonColor = true;
        BackgroundColor3 = Fusion.Computed(function()
            if CurrentTab:get() == props.Name then
                return Fusion.Tween(WhiteState, TInfo):get()
            else
                return Fusion.Tween(GreyState, TInfo):get()
            end
        end);
        [Fusion.Children] = {
            Fusion.New "UIListLayout" {
                FillDirection = Enum.FillDirection.Horizontal;
                Padding = UDim.new(0,5);
                HorizontalAlignment = Enum.HorizontalAlignment.Center;
                VerticalAlignment = Enum.VerticalAlignment.Center;
            };
            Fusion.New "UICorner" {
                CornerRadius = UDim.new(1/3, 0);
            };
            Fusion.New "UIPadding" {
                PaddingTop = UDim.new(0,5);
                PaddingBottom = UDim.new(0,5);
                PaddingLeft = UDim.new(0,5);
                PaddingRight = UDim.new(0,5);
            };
            Fusion.New "ImageLabel" {
                Size = UDim2.new(1,0,1,0);
                SizeConstraint = Enum.SizeConstraint.RelativeYY;
                Image = props.Image;
                BackgroundTransparency = 1;
                LayoutOrder = 1;
                ImageColor3 = Fusion.Computed(function()
                    if CurrentTab:get() == props.Name then
                        return Fusion.Tween(BlackState, TInfo):get()
                    else
                        return Fusion.Tween(WhiteState, TInfo):get()
                    end
                end);
            };
            Fusion.New "TextLabel" {
                BackgroundTransparency = 1;
                TextScaled = true;
                LayoutOrder = 2;
                Font = Enum.Font.GothamBold;
                Text = props.Name;
                Size = UDim2.new(0, 0, 1, 0);
                AutomaticSize = Enum.AutomaticSize.X;
                TextColor3 = Fusion.Computed(function()
                    if CurrentTab:get() == props.Name then
                        return Fusion.Tween(BlackState, TInfo):get()
                    else
                        return Fusion.Tween(WhiteState, TInfo):get()
                    end
                end);
            };
        };
        [Fusion.OnEvent("Activated")] = function()
            CurrentTab:set(props.Name)
        end;
    }
end

local function SetupKura()
    if CanUse == 1 then
        -- Educator
        local EducationMode = Icon.new()
        EducationMode:setImage("8127903187")
        EducationMode:setName("KuraMode")
        EducationMode:setTip("Show/Hide Explorer Kura")
        EducationMode.selected:Connect(function()
            ContainerPosition:set(UDim2.new(0.5,0,0,-30))
        end)
        EducationMode.deselected:Connect(function()
            ContainerPosition:set(UDim2.new(0.5,0,0,-30))
        end)
        CreateSection({Name = "Players"; Image = "8127901812";})
        CreateSection({Name = "Quick Actions"; Image = "8129843059";})
        CreateSection({Name = "Announcements"; Image = "8127903374";})
        CreateSection({Name = "About"; Image = "8127902797";})
    elseif CanUse == 2 then
        -- Student
        local RaiseHandButton = Icon.new()
        RaiseHandButton:setImage("8127902992")
        RaiseHandButton:setName("RaiseHand")
        RaiseHandButton:setTip("Raise Hand")
        RaiseHandButton.selected:Connect(function()
            ContainerPosition:set(UDim2.new(0.5, 0, 0, 5))
        end)
        RaiseHandButton.deselected:Connect(function()
            ContainerPosition:set(UDim2.new(0.5, 0, -0.5, -30))
        end)
    end
    -- Sets up playerlist
    local PlayerListState = State.new(Players:GetPlayers())
    local function UpdatePlayerListState()
        PlayerListState:set(Players:GetPlayers()) -- Sorry.
    end
    -- Sets up Quick Action
    local QuickActionArrays = KuraRF:InvokeServer({"QuickActions", "RequestActionList"})
end

KuraRE.OnClientEvent:Connect(function(args)
    if args[1] == "KuraSetup" then
        SetupKura(args[2])
    end
end)

KuraRF.OnClientInvoke = function(args)
    
end

if CanUse then
    SetupKura(CanUse)
end