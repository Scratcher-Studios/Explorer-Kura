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
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GroupService = game:GetService("GroupService")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")

-- Gets whatever instance of TopbarPlus is currently initialised. If not, start initialising it's own.
local Icon

if ReplicatedStorage:FindFirstChild("TopbarPlusReference") then
    Icon = require(ReplicatedStorage.TopbarPlusReference.Value)
elseif script:FindFirstChild("Icon") then
    Icon = require(script.Icon)
else
    error("TopbarPlus not detected. Unable to initialise Kura.")
end

-- The Fusion module bundled will always be used as Fusion is currently in pre-release.
local Fusion = require(script.Fusion)

local Children = Fusion.Children
local OnEvent = Fusion.OnEvent
local OnChange = Fusion.OnChange
local State = Fusion.State
local Computed = Fusion.Computed
local ComputedPairs = Fusion.ComputedPairs
local FusionTween = Fusion.Tween
local New = Fusion.New

local LocalKuraVersionState = State("dev")-- State({MajorVersionNumber = 0; MinorVersionNumber = 0; PatchNumber = 0;})

local TInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut, 1, false, 0) -- repeatCount should be 0 but it is 1 otherwise Fusion borkes itself

local function CopyDict(original) -- Yes, I stole this from DevHub. No, I don't care.
	local copy = {}
	for k, v in pairs(original) do
		if type(v) == "table" then
			v = CopyDict(v)
		end
		copy[k] = v
	end
	return copy
end

local KuraRE = ReplicatedStorage:WaitForChild("KuraRE")
local KuraRF = ReplicatedStorage:WaitForChild("KuraRF")

local CanUse = KuraRF:InvokeServer("CanUseKura")

local LocalPlayer = Players.LocalPlayer

local ButtonsToggled = {}

if not CanUse then script:Destroy() end

-- UI creation time!

local CurrentTab = State("nil")
local BlackState = State(Color3.fromRGB(0, 0, 0))
local WhiteState = State(Color3.fromRGB(255, 255, 255))
local GreyState = State(Color3.fromRGB(30, 30, 30))

-- Player list states

local PlayerListState = State(Players:GetPlayers())
local MutedPlayersState = State(table.create(Players.MaxPlayers))

local LocatorLib = require(script.LocatorsClient)
local Locators = LocatorLib.New()
local LocatorShownState = State(table.create(Players.MaxPlayers))

local QuickActionsEvents = {}
local QuickActionsInvokes = {}

local FULL_SCREEN_ANNOUNCEMENT_WAIT = 5
local BODY_TEXT_SIZE = 11

local ScreenGui = New "ScreenGui" {
    DisplayOrder = 1000;
    IgnoreGuiInset = false;
    Name = "ExplorerKuraGui";
    Enabled = true;
    Parent = LocalPlayer.PlayerGui
}

local function CreateUICorner()
    return New "UICorner" {
        CornerRadius = UDim.new(0, 5)
    };
end

local function CreateUIPadding()
    return New "UIPadding" {
        PaddingTop = UDim.new(0, 5);
        PaddingBottom = UDim.new(0, 5);
        PaddingLeft = UDim.new(0, 5);
        PaddingRight = UDim.new(0, 5);
    };
end

local ContainerPosition = State(UDim2.new(0.5, 0, -1, 0))

local RaiseHandButton

local ExplorerKuraContainer = New "Frame" {
    Name = "ExplorerKuraContainer";
    Size = UDim2.new(0.5, 0, 0.5, 0);
    AnchorPoint = Vector2.new(0.5, 0);
    Position = FusionTween(ContainerPosition, TInfo);
    BackgroundTransparency = 1;
    Visible = true;
    Parent = ScreenGui;
    [Children] = {
        New "Frame" {
            Name = "Topbar";
            Size = UDim2.new(1, 0, 0, 30);
            AnchorPoint = Vector2.new(0.5, 0);
            Position = UDim2.new(0.5, 0, 0, 0);
            BackgroundColor3 = Color3.fromRGB(0, 0, 0);
            BorderSizePixel = 0;
            Visible = true;
            [Children] = {
                New("UIListLayout") {
                    Padding = UDim.new(0, 5);
                    FillDirection = Enum.FillDirection.Horizontal;
                    HorizontalAlignment = Enum.HorizontalAlignment.Center;
                    VerticalAlignment = Enum.VerticalAlignment.Center;
                }
            }
        }
    }
}

local function CreateSection(props)
    return New "ScrollingFrame" {
        Name = props.Name;
        Size = UDim2.new(1, 0, 1, -30);
        AnchorPoint = Vector2.new(0.5, 0);
        Position = UDim2.new(0.5, 0, 0, 30);
        Parent = ExplorerKuraContainer;
        Visible = Computed(function()
            if CurrentTab:get() == props.Name then
                return true
            else
                return false
            end
        end),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30);
        BackgroundTransparency = 0.3;
        BorderSizePixel = 0;
        AutomaticCanvasSize = Enum.AutomaticSize.Y;
        CanvasSize = UDim2.new(1, 0, 0, 0);
        VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar;
        ScrollBarThickness = 3;
        ScrollBarImageColor3 = Color3.fromRGB(70, 70, 70)
    }, New "TextButton" {
        Text = "";
        Name = props.Name;
        Size = UDim2.new(0.25, -5, 1, -5);
        Parent = ExplorerKuraContainer.Topbar;
        BackgroundTransparency = 0;
        AutoButtonColor = true;
        BackgroundColor3 = Computed(function()
            if CurrentTab:get() == props.Name then
                return FusionTween(WhiteState, TInfo):get()
            else
                return FusionTween(GreyState, TInfo):get()
            end
        end);
        [Children] = {
            New "UIListLayout" {
                FillDirection = Enum.FillDirection.Horizontal;
                Padding = UDim.new(0, 5);
                HorizontalAlignment = Enum.HorizontalAlignment.Center;
                VerticalAlignment = Enum.VerticalAlignment.Center;
            },
            CreateUICorner();
            New "UIPadding" {
                PaddingTop = UDim.new(0, 5);
                PaddingBottom = UDim.new(0, 5);
                -- PaddingLeft = UDim.new(0,5);
                -- PaddingRight = UDim.new(0,5);
            },
            New "ImageLabel" {
                Size = UDim2.new(1, 0, 1, 0);
                SizeConstraint = Enum.SizeConstraint.RelativeYY;
                Image = props.Image;
                BackgroundTransparency = 1;
                LayoutOrder = 1;
                ImageColor3 = Computed(function()
                    if CurrentTab:get() == props.Name then
                        return FusionTween(BlackState, TInfo):get()
                    else
                        return FusionTween(WhiteState, TInfo):get()
                    end
                end)
            },
            New "TextLabel" {
                BackgroundTransparency = 1;
                TextScaled = true;
                LayoutOrder = 2;
                Font = Enum.Font.GothamBold;
                Text = props.Name;
                Size = UDim2.new(0, 0, 1, 0);
                AutomaticSize = Enum.AutomaticSize.X;
                TextColor3 = Computed(function()
                    if CurrentTab:get() == props.Name then
                        return FusionTween(BlackState, TInfo):get()
                    else
                        return FusionTween(WhiteState, TInfo):get()
                    end
                end)
            }
        },
        [OnEvent("Activated")] = function()
            CurrentTab:set(props.Name)
        end
    }
end

local function SetupKura()
    ExplorerKuraContainer.Visible = true
    if CanUse == 1 then
        -- Educator
        ExplorerKuraContainer.Visible = true
        local EducationMode = Icon.new()
        EducationMode:setImage("rbxassetid://8127903187")
        EducationMode:setName("KuraMode")
        EducationMode:setTip("Show/Hide Explorer Kura")
        EducationMode.selected:Connect(function()
            ContainerPosition:set(UDim2.new(0.5, 0, 0, 0))
        end)
        EducationMode.deselected:Connect(function()
            ContainerPosition:set(UDim2.new(0.5, 0, -1, 0))
        end)
        local PlayersFrame, _ = CreateSection({
            Name = "Classroom";
            Image = "rbxassetid://8127901812"
        })
        local QuickActionsFrame, _ = CreateSection({
            Name = "Quick Actions";
            Image = "rbxassetid://8129843059"
        })
        local AnnouncementsFrame, _ = CreateSection({
            Name = "Announcements";
            Image = "rbxassetid://8127903374"
        })
        local AboutFrame, _ = CreateSection({
            Name = "About";
            Image = "rbxassetid://8127902797"
        })
        -- Players Frame
        New "UIListLayout" {
            Padding = UDim.new(0, 5);
            SortOrder = Enum.SortOrder.LayoutOrder;
            FillDirection = Enum.FillDirection.Vertical;
            HorizontalAlignment = Enum.HorizontalAlignment.Center;
            VerticalAlignment = Enum.VerticalAlignment.Top;
            Parent = PlayersFrame;
        };
        -- Sets up playerlist
        local function UpdatePlayerListState()
            PlayerListState:set(Players:GetPlayers()) -- Sorry.
        end
        Players.PlayerAdded:Connect(UpdatePlayerListState)
        Players.PlayerRemoving:Connect(UpdatePlayerListState)
        UpdatePlayerListState()

        local PlayerFrames = ComputedPairs(PlayerListState, 
        -- Processor
        function(_, player)
            return State(New "Frame" {
                BackgroundColor3 = BlackState;
                Size = UDim2.new(1, -10, 0, 40);
                BorderSizePixel = 0;
                Name = player.UserId;
                Parent = PlayersFrame;
                [Children] = {
                    CreateUICorner();
                    New "ObjectValue" {
                        Name = "PlayerObj";
                        Value = player;
                    };
                    New "ImageLabel" {
                        Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48);
                        BackgroundTransparency = 1;
                        SizeConstraint = Enum.SizeConstraint.RelativeYY;
                        Size = UDim2.new(1,0,1,-10);
                        ScaleType = Enum.ScaleType.Fit;
                        AnchorPoint = Vector2.new(0, 0.5);
                        Position = UDim2.new(0,5,0.5,0);
                        Name = "PlayerImage";
                    };
                    New "TextLabel" {
                        Text = player.DisplayName;
                        TextColor3 = WhiteState;
                        Font = Enum.Font.Gotham;
                        AnchorPoint = Vector2.new(0, 0.5);
                        Position = UDim2.new(0,45,0.5,0);
                        Size = UDim2.new(0.5,-45,1,-10);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        TextScaled = true;
                        Name = "PlayerName";
                    };
                    New "Frame" {
                        Name = "ButtonFrames";
                        Size = UDim2.new(0.5,0,1,-10);
                        AnchorPoint = Vector2.new(1, 0.5);
                        Position = UDim2.new(1,-5,0.5,0);
                        BackgroundTransparency = 1;
                        [Children] = {
                            New "UIListLayout" {
                                Padding = UDim.new(0, 5);
                                SortOrder = Enum.SortOrder.LayoutOrder;
                                FillDirection = Enum.FillDirection.Horizontal;
                                HorizontalAlignment = Enum.HorizontalAlignment.Right;
                                VerticalAlignment = Enum.VerticalAlignment.Center;
                            };
                            New "ImageButton" {
                                SizeConstraint = Enum.SizeConstraint.RelativeYY;
                                Size = UDim2.new(1,0,1,0);
                                Name = "Locator";
                                Image = "rbxassetid://8127902577";
                                BackgroundColor3 = Computed(function()
                                    local array = CopyDict(LocatorShownState:get())
                                    if table.find(array, player) then
                                        return FusionTween(State(Color3.fromRGB(200, 0, 0)), TInfo):get()
                                    else
                                        return FusionTween(GreyState, TInfo):get()
                                    end
                                end);
                                [Children] = {
                                    CreateUICorner();
                                };
                                [OnEvent "Activated"] = function()
                                    local array = CopyDict(LocatorShownState:get())
                                    if table.find(array, player) then
                                        KuraRE:FireServer("HideLocators", {player})
                                    else
                                        KuraRE:FireServer("ShowLocators", {player})
                                    end
                                end;
                            };
                            New "ImageButton" {
                                SizeConstraint = Enum.SizeConstraint.RelativeYY;
                                Size = UDim2.new(1,0,1,0);
                                Name = "Chat";
                                Image = Computed(function()
                                    local array = CopyDict(MutedPlayersState:get()) -- See Elttob/Fusion issue #78 to see why I have to do this
                                    if table.find(array, player) then
                                        return "rbxassetid://8127902088"
                                    else
                                        return "rbxassetid://8127903374"
                                    end
                                end);
                                BackgroundColor3 = Computed(function()
                                    local array = CopyDict(MutedPlayersState:get())
                                    if table.find(array, player) then
                                        return FusionTween(State(Color3.fromRGB(200, 0, 0)), TInfo):get()
                                    else
                                        return FusionTween(GreyState, TInfo):get()
                                    end
                                end);
                                [Children] = {
                                    CreateUICorner();
                                };
                                [OnEvent "Activated"] = function()
                                    local array = CopyDict(MutedPlayersState:get())
                                    if table.find(array, player) then
                                        KuraRE:FireServer("PlayerFrames", {Action = "Unmute"; Player = player})
                                    else
                                        KuraRE:FireServer("PlayerFrames", {Action = "Mute"; Player = player})
                                    end
                                end;
                            };
                            New "ImageButton" {
                                SizeConstraint = Enum.SizeConstraint.RelativeYY;
                                Size = UDim2.new(1,0,1,0);
                                Name = "TeleportTo";
                                Image = "rbxassetid://8188131920";
                                BackgroundColor3 = GreyState;
                                [Children] = {
                                    CreateUICorner();
                                };
                                [OnEvent "Activated"] = function()
                                    KuraRE:FireServer("PlayerFrames", {Action = "TeleportTo"; Target = player})
                                end;
                            };
                            New "ImageButton" {
                                SizeConstraint = Enum.SizeConstraint.RelativeYY;
                                Size = UDim2.new(1,0,1,0);
                                Name = "TeleportFrom";
                                Image = "rbxassetid://8188132131";
                                BackgroundColor3 = GreyState;
                                [Children] = {
                                    CreateUICorner();
                                };
                                [OnEvent "Activated"] = function()
                                    KuraRE:FireServer("PlayerFrames", {Action = "TeleportFrom"; Target = player})
                                end;
                            };
                        };
                    }
                };
            })
        end,
        -- Destructor
        function(frame)
            Debris:AddItem(frame)
            local player = frame.PlayerObj.Value
            local MutedPlayers = CopyDict(MutedPlayersState:get())
            if table.find(MutedPlayers, player) then
                table.remove(MutedPlayers, player)
                MutedPlayersState:set(MutedPlayers)
            end
            local LocatorShown = CopyDict(LocatorShownState:get())
            if table.find(LocatorShown, player) then
                table.remove(LocatorShown, player)
                LocatorShownState:set(LocatorShown)
            end
        end
    )
        -- Quick Actions Frame
        New "UIGridLayout" {
            CellPadding = UDim2.new(0,5,0,5);
            CellSize = UDim2.new(0.25,-5,0,50);
            StartCorner = Enum.StartCorner.TopLeft;
            Parent = QuickActionsFrame;
        }
        local QuickActionGridPadding = CreateUIPadding()
        QuickActionGridPadding.Parent = QuickActionsFrame
        local QuickActionsArray = KuraRF:InvokeServer("QuickActions", {ActionType = "RequestActionList"})
        if QuickActionsArray then
            local QuickActionButtons = ComputedPairs(QuickActionsArray,
            -- Processor
            function(name: string, ActionTable)
                local onState = State(ActionTable.DefaultState or false)
                local button = New "TextButton" {
                    BackgroundColor3 = Computed(function()
                        if onState:get() then
                            return FusionTween(WhiteState, TInfo):get()
                        else
                            return FusionTween(GreyState, TInfo):get()
                        end
                    end);
                    Text = "";
                    Parent = QuickActionsFrame;
                    [Children] = {
                        New "TextLabel" {
                            Text = Computed(function()
                                if typeof(ActionTable.FriendlyName) == "string" then
                                    return ActionTable.FriendlyName
                                elseif typeof(ActionTable.FriendlyName) == "table" then
                                    local module = require(ReplicatedStorage.ExplorerKuraQuickActions:FindFirstChild(ActionTable.Script))
                                    if onState:get() then
                                        if typeof(module.FriendlyName[true]) == "string" then
                                            return module.FriendlyName[true]
                                        end
                                    else
                                        if typeof(module.FriendlyName[false]) == "string" then
                                            return module.FriendlyName[false]
                                        end
                                    end
                                end
                                return ActionTable.Script
                            end);
                            TextScaled = true;
                            TextColor3 = Computed(function()
                                if onState:get() then
                                    return FusionTween(BlackState, TInfo):get()
                                else
                                    return FusionTween(WhiteState, TInfo):get()
                                end
                            end);
                            BackgroundTransparency = 1;
                            Font = Enum.Font.GothamSemibold;
                            AnchorPoint = Vector2.new(1,0.5);
                            Position = UDim2.new(1,0,0.5,0);
                            Size = UDim2.new(1,-50,1,0);
                        };
                        New "ImageLabel" {
                            Image = ActionTable.Image;
                            BackgroundTransparency = 1;
                            SizeConstraint = Enum.SizeConstraint.RelativeYY;
                            Size = UDim2.new(1,0,1,0);
                            ScaleType = Enum.ScaleType.Fit;
                            ImageColor3 = Computed(function()
                                if onState:get() then
                                    return FusionTween(BlackState, TInfo):get()
                                else
                                    return FusionTween(WhiteState, TInfo):get()
                                end
                            end);
                            AnchorPoint = Vector2.new(0,0.5);
                            Position = UDim2.new(0,0,0.5,0);
                        };
                        CreateUIPadding();
                        CreateUICorner();
                    };
                    [OnEvent "Activated"] = function()
                        local Module = ReplicatedStorage.ExplorerKuraQuickActions:FindFirstChild(ActionTable.Script)
                        local Action = require(Module)
                        local OnStateResult: boolean|nil, FireServer: any = Action.ClientFunction(onState:get(), {["LocatorShownState"] = LocatorShownState; ["MutedPlayersState"] = MutedPlayersState;})
                        if typeof(OnStateResult) == "boolean" then
                            onState:set(OnStateResult)
                        end
                        if FireServer then
                            KuraRE:FireServer("QuickActions", {ActionTable.Script, FireServer})
                        end
                    end;
                }
                return button
            end,
            -- Destructor
            function(button)
                button:Destroy()
            end
            )
        else
            warn("No Quick Actions found.")
        end
        
        -- Announcements Frame
        local function MessageBoxFrame(title, placeholder)
            local MessageBoxState = State("")
            local SuccessState = State(2)
            local function SendMessage()
                local success = KuraRF:InvokeServer("Announcement", {AnnouncementType = title; Message = MessageBoxState:get();})
                SuccessState:set(success)
                task.wait(1)
                SuccessState:set(2)
            end
            local AnnouncementTemplate = New "Frame" {
                Size = UDim2.new(1,0,0.5,0);
                BackgroundTransparency = 1;
                AnchorPoint = Vector2.new(0.5,0);
                Name = title;
                Parent = AnnouncementsFrame;
                Visible = true;
                [Children] = {
                    New "TextLabel" {
                        AnchorPoint = Vector2.new(0.5,0.5);
                        Position = UDim2.new(0.5,0,0.15,0);
                        Size = UDim2.new(1,0,0.3,0);
                        Text = title;
                        TextScaled = true;
                        TextColor3 = WhiteState;
                        Font = Enum.Font.GothamSemibold;
                        Name = "Title";
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                    };
                    New "TextBox" {
                        Name = "TextBox";
                        BackgroundColor3 = GreyState;
                        TextColor3 = WhiteState;
                        PlaceholderText = placeholder;
                        PlaceholderColor3 = Color3.fromRGB(200,200,200);
                        BackgroundTransparency = 0.3;
                        Text = "";
                        BorderSizePixel = 0;
                        Font = Enum.Font.Gotham;
                        Size = UDim2.new(1,0,0.7,0);
                        Position = UDim2.new(0.5,0,0.3,0);
                        AnchorPoint = Vector2.new(0.5, 0);
                        TextXAlignment = Enum.TextXAlignment.Left;
                        TextYAlignment = Enum.TextYAlignment.Top;
                        TextSize = BODY_TEXT_SIZE;
                        TextWrapped = true;
                        [Children] = {
                            New "ImageButton" {
                                Size = UDim2.new(0, 30, 0, 30);
                                AnchorPoint = Vector2.new(1,1);
                                Position = UDim2.new(1,-5,1,-5);
                                Image = "rbxassetid://8439203229";
                                ImageColor3 = BlackState;
                                ZIndex = 2;
                                AutoButtonColor = true;
                                BackgroundColor3 = Computed(function()
                                    if SuccessState:get() == 2 then
                                        return FusionTween(WhiteState, TInfo):get()
                                    elseif SuccessState:get() == 0 then
                                        return FusionTween(State(Color3.fromRGB(0,200,0)), TInfo):get()
                                    elseif SuccessState:get() == 1 then
                                        return FusionTween(State(Color3.fromRGB(200,0,0)), TInfo):get()
                                    end
                                end);
                                [Children] = {CreateUICorner()};
                                [OnEvent "Activated" ] = SendMessage;
                            };
                            CreateUICorner();
                            CreateUIPadding();
                        };
                        [OnEvent "FocusLost" ] = function(enterPressed)
                            if enterPressed then
                                SendMessage()
                            end
                        end;
                        [OnChange "Text" ] = function(text)
                            MessageBoxState:set(text)
                        end
                    };
                    CreateUIPadding();
                };
            }
            return AnnouncementTemplate
        end
        local BarFrame = MessageBoxFrame("Topbar Announcement", "Small message at the top of the screen. Leave this text box blank to clear.")
        BarFrame.Position = UDim2.new(0.5,0,0,0)
        local FullScreenFrame = MessageBoxFrame("Full Screen Announcement", "Message that temporarily covers the whole screen for " ..tostring(FULL_SCREEN_ANNOUNCEMENT_WAIT) .." seconds.")
        FullScreenFrame.Position = UDim2.new(0.5,0,0.5,0)
        -- About Frame
        New "UIListLayout" {
            Padding = UDim.new(0, 5);
            SortOrder = Enum.SortOrder.LayoutOrder;
            FillDirection = Enum.FillDirection.Vertical;
            HorizontalAlignment = Enum.HorizontalAlignment.Center;
            VerticalAlignment = Enum.VerticalAlignment.Center;
            Parent = AboutFrame;
        };
        New "ImageLabel" {
            BackgroundColor3 = BlackState,
            Size = UDim2.new(1, -10, 0, 100);
            BorderSizePixel = 0;
            Image = "rbxassetid://8167715626";
            ScaleType = Enum.ScaleType.Fit;
            Name = "KuraLogo";
            LayoutOrder = 1;
            Parent = AboutFrame;
            [Children] = {
                CreateUICorner()
            }
        };
        New "TextLabel" {
            BackgroundColor3 = BlackState;
            Size = UDim2.new(1, -10, 0, 20);
            BorderSizePixel = 0;
            Name = "VersionText";
            Text = Computed(function()
                local LocalCurrentKuraVersion = LocalKuraVersionState:get()
                local LatestKuraVersion = KuraRF:InvokeServer("LatestKuraVersion")
                local TriggerUpdate = LatestKuraVersion.TriggerUpdate
                local function CreateWarning(props)
                    return New "Frame" {
                        BackgroundColor3 = props.Colour;
                        BorderSizePixel = 0;
                        Size = UDim2.new(1,-10,0,30);
                        Parent = AboutFrame;
                        LayoutOrder = 3;
                        [Children] = {
                            CreateUICorner();
                            New "ImageLabel" {
                                SizeConstraint = Enum.SizeConstraint.RelativeYY;
                                Size = UDim2.new(1,0,1,0);
                                AnchorPoint = Vector2.new(0,0.5);
                                Position = UDim2.new(0,5,0.5,0);
                                ImageColor3 = BlackState;
                                Image = "rbxassetid://8127902797";
                                BackgroundTransparency = 1;
                            };
                            New "TextLabel" {
                                Size = UDim2.new(1,-35,1,0);
                                AnchorPoint = Vector2.new(0,0.5);
                                Position = UDim2.new(0,35,0.5,0);
                                Text = props.Text;
                                TextColor3 = BlackState;
                                TextScaled = true;
                                Font = Enum.Font.Gotham;
                                BackgroundTransparency = 1;
                            };
                        };
                    }
                end
                if typeof(LocalCurrentKuraVersion) == "table" and LocalCurrentKuraVersion.MajorVersionNumber and LocalCurrentKuraVersion.MinorVersionNumber and LocalCurrentKuraVersion.PatchNumber then
                    if (game.CreatorType == Enum.CreatorType.User and game.CreatorId == LocalPlayer.UserId) or (game.CreatorType == Enum.CreatorType.Group and GroupService:GetGroupInfoAsync(game.CreatorId).Owner.Id == LocalPlayer.UserId) then
                        -- Game developer
                        if LocalCurrentKuraVersion.MajorVersionNumber < TriggerUpdate.MajorVersionNumber then
                            CreateWarning({Text = "This version of Kura is outdated as a new major version has been released. Please update your Kura module now."; Colour = Color3.fromRGB(255, 0, 0)})
                        elseif LocalCurrentKuraVersion.MinorVersionNumber < TriggerUpdate.MinorVersionNumber then
                            CreateWarning({Text = "A new version of Kura has been released. Please update your Kura module now."; Colour = Color3.fromRGB(255, 115, 0)})
                        elseif LocalCurrentKuraVersion.PatchNumber < TriggerUpdate.PatchNumber then
                            CreateWarning({Text = "A patch for Kura has been released. This update may provide additional stability."; Colour = Color3.fromRGB(255, 255, 255)})
                        end
                    else
                        if LocalCurrentKuraVersion.MajorVersionNumber < TriggerUpdate.MajorVersionNumber then
                            CreateWarning({Text = "This version of Kura is outdated as a new major version has been released. Please ask the experience developer to update the version of Kura in this experience."; Colour = Color3.fromRGB(255, 0, 0)})
                        end
                    end
                    return "Version " ..tostring(LocalCurrentKuraVersion.MajorVersionNumber) .."." ..tostring(LocalCurrentKuraVersion.MinorVersionNumber) .."." ..tostring(LocalCurrentKuraVersion.PatchNumber)
                else
                    CreateWarning({Text = "This version of Kura is unsupported as it is not an official Kura release."; Colour = Color3.fromRGB(255, 0, 0)})
                    return "Version Dev"
                end
            end);
            Font = Enum.Font.Gotham;
            TextColor3 = WhiteState;
            TextScaled = true;
            LayoutOrder = 2;
            Parent = AboutFrame;
            [Children] = {
                CreateUICorner();
                CreateUIPadding();
            }
        };
        local function License(props)
            return New "TextLabel" {
                BackgroundColor3 = BlackState;
                Size = UDim2.new(1, -10, 0, 30);
                BorderSizePixel = 0;
                Name = props.Name;
                Text = props.Text;
                Font = Enum.Font.Gotham;
                TextColor3 = WhiteState;
                TextSize = BODY_TEXT_SIZE;
                AutomaticSize = Enum.AutomaticSize.Y;
                TextXAlignment = Enum.TextXAlignment.Left;
                TextScaled = true;
                LayoutOrder = props.LayoutOrder;
                Parent = AboutFrame;
                [Children] = {
                    CreateUICorner();
                    CreateUIPadding();
                }
            };
        end
        License({Name = "EoTMLicense"; Text = require(script.LICENSE), LayoutOrder = 4;})
        License({Name = "FusionLicense"; Text = require(script.Fusion.LICENSE), LayoutOrder = 5;})
        License({Name = "IconLicense"; Text = require(script.Icon.LICENSE), LayoutOrder = 6;})

        local PlaceholderFrame, PlaceholderButton = CreateSection({Name = "placeholder"; Image = "";
        })
        PlaceholderButton:Destroy()
        CurrentTab:set("placeholder")
        New "ImageLabel" {
            Image = "rbxassetid://8167395582";
            BackgroundTransparency = 1;
            Size = UDim2.new(0.9, 0, 0.5, 0);
            Position = UDim2.new(0.5, 0, 0.5, 0);
            AnchorPoint = Vector2.new(0.5, 0.5);
            ScaleType = Enum.ScaleType.Fit;
            Parent = PlaceholderFrame;
        }
    elseif CanUse == 2 then
        -- Student
        ExplorerKuraContainer.Visible = false
        RaiseHandButton = Icon.new()
        RaiseHandButton:setImage("8127902992")
        RaiseHandButton:setName("RaiseHand")
        RaiseHandButton:setTip("Raise Hand")
        RaiseHandButton.selected:Connect(function()
            RaiseHandButton:setTip("Lower Hand")
            KuraRE:FireServer("ShowLocators", {})
        end)
        RaiseHandButton.deselected:Connect(function()
            RaiseHandButton:setTip("Raise Hand")
            KuraRE:FireServer("HideLocators", {})
        end)
    else
        ExplorerKuraContainer.Visible = false
    end
end

-- Set up the announcement frames so everyone can see
local FullScreenAnnouncementFrameAppearence = State(false)
local FullScreenAnnouncementFrame = New "Frame" {
    Parent = ScreenGui;
    ZIndex = 2003;
    Visible = true;
    BackgroundColor3 = BlackState;
    BackgroundTransparency = Computed(function()
        if FullScreenAnnouncementFrameAppearence:get() then
            return FusionTween(State(0.3), TInfo):get()
        else
            return FusionTween(State(1), TInfo):get()
        end
    end);
    Size = UDim2.new(1,0,1,40);
    Position = UDim2.new(0.5,0,0,-40);
    AnchorPoint = Vector2.new(0.5,0);
    [Children] = {
        New "TextLabel" {
            ZIndex = 2004;
            Font = Enum.Font.GothamBlack;
            TextColor3 = WhiteState;
            BackgroundTransparency = 1;
            Text = "EDUCATOR ANNOUNCEMENT";
            Name = "Title";
            AnchorPoint = Vector2.new(0.5,0);
            Position = UDim2.new(0.5,0,0,35);
            Size = UDim2.new(1,0,0, BODY_TEXT_SIZE);
            TextScaled = true;
            TextTransparency = Computed(function()
                if FullScreenAnnouncementFrameAppearence:get() then
                    return FusionTween(State(0), TInfo):get()
                else
                    return FusionTween(State(1), TInfo):get()
                end
            end);
        };
        New "TextLabel" {
            ZIndex = 2004;
            Font = Enum.Font.Gotham;
            TextColor3 = WhiteState;
            BackgroundTransparency = 1;
            Text = "";
            Name = "Message";
            AnchorPoint = Vector2.new(0.5,0.5);
            Position = UDim2.new(0.5,0,0.5,0);
            Size = UDim2.new(1,0,0,30);
            TextScaled = true;
            TextTransparency = Computed(function()
                if FullScreenAnnouncementFrameAppearence:get() then
                    return FusionTween(State(0), TInfo):get()
                else
                    return FusionTween(State(1), TInfo):get()
                end
            end);
        };
    };
}

local TopbarAnnouncementFrameAppearence = State(false)
local TopbarAnnouncementFrame = New "Frame" {
    Parent = ScreenGui;
    ZIndex = 2000;
    Visible = true;
    BackgroundColor3 = BlackState;
    BackgroundTransparency = Computed(function()
        if TopbarAnnouncementFrameAppearence:get() then
            return FusionTween(State(0.3), TInfo):get()
        else
            return FusionTween(State(1), TInfo):get()
        end
    end);
    Size = Computed(function()
        if TopbarAnnouncementFrameAppearence:get() then
            return FusionTween(State(UDim2.new(1,0,0,30)), TInfo):get()
        else
            return FusionTween(State(UDim2.new(1,0,0,0)), TInfo):get()
        end
    end);
    Position = UDim2.new(0.5,0,0,5);
    AnchorPoint = Vector2.new(0.5,0);
    [Children] = {
        New "TextLabel" {
            ZIndex = 2001;
            Font = Enum.Font.Gotham;
            TextColor3 = WhiteState;
            BackgroundTransparency = 1;
            Text = "";
            Name = "Message";
            AnchorPoint = Vector2.new(0.5,0.5);
            Position = UDim2.new(0.5,0,0.5,0);
            Size = UDim2.new(1,0,0,21);
            TextScaled = true;
            TextSize = BODY_TEXT_SIZE;
            TextYAlignment = Enum.TextYAlignment.Center;
            TextXAlignment = Enum.TextXAlignment.Center;
            TextTransparency = Computed(function()
                if TopbarAnnouncementFrameAppearence:get() then
                    return FusionTween(State(0), TInfo):get()
                else
                    return FusionTween(State(1), TInfo):get()
                end
            end);
        };
    };
}

KuraRE.OnClientEvent:Connect(function(args)
    if args[1] == "KuraSetup" then
        CanUse = args[2]
        SetupKura()
    elseif args[1] == "Mute" then
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
    elseif args[1] == "Unmute" then
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
    elseif args[1] == "UpdateMuted" then
        MutedPlayersState:set(args[2])
    elseif args[1] == "Announcement" then
        if args[2] == "Topbar Announcement" then
            -- print("engaging topbar announcement")
            if args[3]:len() == 0 then
                TopbarAnnouncementFrameAppearence:set(false)
            else
                TopbarAnnouncementFrameAppearence:set(false)
                TopbarAnnouncementFrame.Message.Text = args[3]
                TopbarAnnouncementFrameAppearence:set(true)
            end
        elseif args[2] == "Full Screen Announcement" then
            -- print("engaging FSA")
            if args[3]:len() ~= 0 then
                FullScreenAnnouncementFrameAppearence:set(false)
                FullScreenAnnouncementFrame.Message.Text = args[3]
                FullScreenAnnouncementFrameAppearence:set(true)
                task.wait(FULL_SCREEN_ANNOUNCEMENT_WAIT)
                if FullScreenAnnouncementFrameAppearence:get() then
                    FullScreenAnnouncementFrameAppearence:set(false)
                end
            end
        end
    elseif args[1] == "ShowLocator" then
        local LocatorsTable = LocatorShownState:get()
        if args[2] then
            Locators:ShowLocator(args[2])
            table.insert(LocatorsTable, args[2])
            print(Locators:GetPlayerLocatorStatus(args[2]))
        else
            Locators:ShowLocator(LocalPlayer)
            table.insert(LocatorsTable, LocalPlayer)
        end
        LocatorShownState:set(CopyDict(LocatorsTable))
    elseif args[1] == "HideLocator" then
        local LocatorsTable = LocatorShownState:get()
        if args[2] then
            Locators:HideLocator(args[2])
            if table.find(LocatorsTable, args[2]) then
                table.remove(LocatorsTable, table.find(LocatorsTable, args[2]))
            end
        else
            Locators:HideLocator(LocalPlayer)
            if table.find(LocatorsTable, LocalPlayer) then
                table.remove(LocatorsTable, table.find(LocatorsTable, LocalPlayer))
            end
        end
        LocatorShownState:set(CopyDict(LocatorsTable))
    elseif args[1] == "UpdateMutedState" then
        local array = CopyDict(MutedPlayersState:get())
        if args[3] == true then
            -- Mute
            if not table.find(array, args[2]) then
                table.insert(array, args[2])
            end
        elseif args[3] == false then
            -- Unmute
            if table.find(array, args[2]) then
                table.remove(array, table.find(array, args[2]))
            end
        end
        MutedPlayersState:set(array)
    end
end)
--[[
KuraRF.OnClientInvoke = function(args)
    This is such a terrible idea. Never ever do this.
end
]]
if CanUse then SetupKura() end