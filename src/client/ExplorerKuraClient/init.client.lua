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
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local Icon

local Fusion = require(script.Fusion)
State = Fusion.State

local LocalKuraVersionState = State {MajorVersionNumber = 0; MinorVersionNumber = 0; PatchNumber = 0;}

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

if ReplicatedStorage:FindFirstChild("TopbarPlusReference") then
    Icon = require(ReplicatedStorage.TopbarPlusReference.Value)
else
    Icon = require(script.Icon)
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

local ScreenGui = Fusion.New "ScreenGui" {
    DisplayOrder = 1000;
    IgnoreGuiInset = false;
    Name = "ExplorerKuraGui";
    Enabled = true;
    Parent = LocalPlayer.PlayerGui
}

local function CreateUICorner()
    return Fusion.New "UICorner" {
        CornerRadius = UDim.new(0, 5)
    };
end

local function CreateUIPadding()
    return Fusion.New "UIPadding" {
        PaddingTop = UDim.new(0, 5);
        PaddingBottom = UDim.new(0, 5);
        PaddingLeft = UDim.new(0, 5);
        PaddingRight = UDim.new(0, 5);
    };
end

local ContainerPosition = State(UDim2.new(0.5, 0, -1, 0))

local RaiseHandButton

local ExplorerKuraContainer = Fusion.New "Frame" {
    Name = "ExplorerKuraContainer";
    Size = UDim2.new(0.5, 0, 0.5, 0);
    AnchorPoint = Vector2.new(0.5, 0);
    Position = Fusion.Tween(ContainerPosition, TInfo);
    BackgroundTransparency = 1;
    Visible = true;
    Parent = ScreenGui;
    [Fusion.Children] = {
        Fusion.New "Frame" {
            Name = "Topbar";
            Size = UDim2.new(1, 0, 0, 30);
            AnchorPoint = Vector2.new(0.5, 0);
            Position = UDim2.new(0.5, 0, 0, 0);
            BackgroundColor3 = Color3.fromRGB(0, 0, 0);
            BorderSizePixel = 0;
            Visible = true;
            [Fusion.Children] = {
                Fusion.New("UIListLayout") {
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
    return Fusion.New "ScrollingFrame" {
        Name = props.Name;
        Size = UDim2.new(1, 0, 1, -30);
        AnchorPoint = Vector2.new(0.5, 0);
        Position = UDim2.new(0.5, 0, 0, 30);
        Parent = ExplorerKuraContainer;
        Visible = Fusion.Computed(function()
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
    }, Fusion.New "TextButton" {
        Text = "";
        Name = props.Name;
        Size = UDim2.new(0.25, -5, 1, -5);
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
                Padding = UDim.new(0, 5);
                HorizontalAlignment = Enum.HorizontalAlignment.Center;
                VerticalAlignment = Enum.VerticalAlignment.Center;
            },
            CreateUICorner();
            Fusion.New "UIPadding" {
                PaddingTop = UDim.new(0, 5);
                PaddingBottom = UDim.new(0, 5);
                -- PaddingLeft = UDim.new(0,5);
                -- PaddingRight = UDim.new(0,5);
            },
            Fusion.New "ImageLabel" {
                Size = UDim2.new(1, 0, 1, 0);
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
                end)
            },
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
                end)
            }
        },
        [Fusion.OnEvent("Activated")] = function()
            CurrentTab:set(props.Name)
        end
    }
end

local function SetupKura()
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
        Fusion.New "UIListLayout" {
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

        local PlayerFrames = Fusion.ComputedPairs(PlayerListState, 
        -- Processor
        function(_, player)
            return State(Fusion.New "Frame" {
                BackgroundColor3 = BlackState;
                Size = UDim2.new(1, -10, 0, 40);
                BorderSizePixel = 0;
                Name = player.UserId;
                Parent = PlayersFrame;
                [Fusion.Children] = {
                    CreateUICorner();
                    Fusion.New "ObjectValue" {
                        Name = "PlayerObj";
                        Value = player;
                    };
                    Fusion.New "ImageLabel" {
                        Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48);
                        BackgroundTransparency = 1;
                        SizeConstraint = Enum.SizeConstraint.RelativeYY;
                        Size = UDim2.new(1,0,1,-10);
                        ScaleType = Enum.ScaleType.Fit;
                        AnchorPoint = Vector2.new(0, 0.5);
                        Position = UDim2.new(0,5,0.5,0);
                        Name = "PlayerImage";
                    };
                    Fusion.New "TextLabel" {
                        Text = player.Name;
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
                    Fusion.New "Frame" {
                        Name = "ButtonFrames";
                        Size = UDim2.new(0.5,0,1,-10);
                        AnchorPoint = Vector2.new(1, 0.5);
                        Position = UDim2.new(1,-5,0.5,0);
                        BackgroundTransparency = 1;
                        [Fusion.Children] = {
                            Fusion.New "UIListLayout" {
                                Padding = UDim.new(0, 5);
                                SortOrder = Enum.SortOrder.LayoutOrder;
                                FillDirection = Enum.FillDirection.Horizontal;
                                HorizontalAlignment = Enum.HorizontalAlignment.Right;
                                VerticalAlignment = Enum.VerticalAlignment.Center;
                            };
                            Fusion.New "ImageButton" {
                                SizeConstraint = Enum.SizeConstraint.RelativeYY;
                                Size = UDim2.new(1,0,1,0);
                                Name = "Locator";
                                Image = "rbxassetid://8127902577";
                                BackgroundColor3 = Fusion.Computed(function()
                                    local array = CopyDict(LocatorShownState:get())
                                    if table.find(array, player) then
                                        return Fusion.Tween(State(Color3.fromRGB(200, 0, 0)), TInfo):get()
                                    else
                                        return Fusion.Tween(GreyState, TInfo):get()
                                    end
                                end);
                                [Fusion.Children] = {
                                    CreateUICorner();
                                };
                                [Fusion.OnEvent "Activated"] = function()
                                    local array = CopyDict(LocatorShownState:get())
                                    if table.find(array, player) then
                                        Locators:HideLocator(player)
                                        table.remove(array, table.find(array, player))
                                    else
                                        Locators:ShowLocator(player)
                                        table.insert(array, player)
                                    end
                                    LocatorShownState:set(array)
                                end;
                            };
                            Fusion.New "ImageButton" {
                                SizeConstraint = Enum.SizeConstraint.RelativeYY;
                                Size = UDim2.new(1,0,1,0);
                                Name = "Chat";
                                Image = Fusion.Computed(function()
                                    local array = CopyDict(MutedPlayersState:get()) -- See Elttob/Fusion issue #78 to see why I have to do this
                                    if table.find(array, player) then
                                        return "rbxassetid://8127902088"
                                    else
                                        return "rbxassetid://8127903374"
                                    end
                                end);
                                BackgroundColor3 = Fusion.Computed(function()
                                    local array = CopyDict(MutedPlayersState:get())
                                    if table.find(array, player) then
                                        return Fusion.Tween(State(Color3.fromRGB(200, 0, 0)), TInfo):get()
                                    else
                                        return Fusion.Tween(GreyState, TInfo):get()
                                    end
                                end);
                                [Fusion.Children] = {
                                    CreateUICorner();
                                };
                                [Fusion.OnEvent "Activated"] = function()
                                    local array = CopyDict(MutedPlayersState:get())
                                    if table.find(array, player) then
                                        table.remove(array, table.find(array, player))
                                        KuraRE:FireServer("PlayerFrames", {Action = "Unmute"; Player = player})
                                        print("unmute")
                                    else
                                        table.insert(array, player)
                                        KuraRE:FireServer("PlayerFrames", {Action = "Mute"; Player = player})
                                        print("mute")
                                    end
                                    MutedPlayersState:set(array)
                                end;
                            };
                            Fusion.New "ImageButton" {
                                SizeConstraint = Enum.SizeConstraint.RelativeYY;
                                Size = UDim2.new(1,0,1,0);
                                Name = "TeleportTo";
                                Image = "rbxassetid://8188131920";
                                BackgroundColor3 = GreyState;
                                [Fusion.Children] = {
                                    CreateUICorner();
                                };
                                [Fusion.OnEvent "Activated"] = function()
                                    KuraRE:FireServer("PlayerFrames", {Action = "TeleportTo"; Target = player})
                                end;
                            };
                            Fusion.New "ImageButton" {
                                SizeConstraint = Enum.SizeConstraint.RelativeYY;
                                Size = UDim2.new(1,0,1,0);
                                Name = "TeleportFrom";
                                Image = "rbxassetid://8188132131";
                                BackgroundColor3 = GreyState;
                                [Fusion.Children] = {
                                    CreateUICorner();
                                };
                                [Fusion.OnEvent "Activated"] = function()
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
            local Debris = game:GetService("Debris")
            Debris:AddItem(frame)
            local player = frame.PlayerObj.Value
            local MutedPlayers = MutedPlayersState:get()
            if table.find(MutedPlayers, player) then
                table.remove(MutedPlayers, player)
                MutedPlayersState:set(MutedPlayers)
            end
            local LocatorShown = LocatorShownState:get()
            if table.find(LocatorShown, player) then
                table.remove(LocatorShown, player)
                LocatorShownState:set(LocatorShown)
            end
        end
    )
        -- Quick Actions Frame
        Fusion.New "UIGridLayout" {
            CellPadding = UDim2.new(0,5,0,5);
            CellSize = UDim2.new(0.25,0,0,50);
            StartCorner = Enum.StartCorner.TopLeft;
            Parent = QuickActionsFrame;
        }
        local QuickActionGridPadding = CreateUIPadding()
        QuickActionGridPadding.Parent = QuickActionsFrame
        local QuickActionsArray = KuraRF:InvokeServer("QuickActions", {ActionType = "RequestActionList"})
        print(QuickActionsArray)
        if QuickActionsArray then
            local QuickActionButtons = Fusion.ComputedPairs(QuickActionsArray,
            -- Processor
            function(name: string, ActionTable)
                local onState = State(ActionTable.DefaultState or false)
                local button = Fusion.New "TextButton" {
                    BackgroundColor3 = Fusion.Computed(function()
                        if onState:get() then
                            return Fusion.Tween(WhiteState, TInfo):get()
                        else
                            return Fusion.Tween(GreyState, TInfo):get()
                        end
                    end);
                    Text = "";
                    Parent = QuickActionsFrame;
                    [Fusion.Children] = {
                        Fusion.New "TextLabel" {
                            Text = Fusion.Computed(function()
                                if typeof(ActionTable.FriendlyName) == "string" then
                                    return ActionTable.FriendlyName
                                elseif typeof(ActionTable.FriendlyName) == "table" then
                                    local module = require(ReplicatedStorage:WaitForChild("QuickActions"):FindFirstChild(ActionTable.Script))
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
                            TextColor3 = Fusion.Computed(function()
                                if onState:get() then
                                    return Fusion.Tween(BlackState, TInfo):get()
                                else
                                    return Fusion.Tween(WhiteState, TInfo):get()
                                end
                            end);
                            BackgroundTransparency = 1;
                            Font = Enum.Font.GothamSemibold;
                            AnchorPoint = Vector2.new(1,0.5);
                            Position = UDim2.new(1,0,0.5,0);
                            Size = UDim2.new(1,-50,1,0);
                        };
                        Fusion.New "ImageLabel" {
                            Image = ActionTable.Image;
                            BackgroundTransparency = 1;
                            SizeConstraint = Enum.SizeConstraint.RelativeYY;
                            Size = UDim2.new(1,0,1,0);
                            ScaleType = Enum.ScaleType.Fit;
                            ImageColor3 = Fusion.Computed(function()
                                if onState:get() then
                                    return Fusion.Tween(BlackState, TInfo):get()
                                else
                                    return Fusion.Tween(WhiteState, TInfo):get()
                                end
                            end);
                            AnchorPoint = Vector2.new(0,0.5);
                            Position = UDim2.new(0,0,0.5,0);
                        };
                        CreateUIPadding();
                        CreateUICorner();
                    };
                    [Fusion.OnEvent("Activated")] = function()
                        print(ActionTable)
                        local Module = ReplicatedStorage.QuickActions:FindFirstChild(ActionTable.Script)
                        print(Module)
                        local Action = require(Module)
                        local OnStateResult: boolean|nil, FireServer: any = Action.ClientFunction(onState:get())
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
            local AnnouncementTemplate = Fusion.New "Frame" {
                Size = UDim2.new(1,0,0.5,0);
                BackgroundTransparency = 1;
                AnchorPoint = Vector2.new(0.5,0);
                Name = title;
                Parent = AnnouncementsFrame;
                Visible = true;
                [Fusion.Children] = {
                    Fusion.New "TextLabel" {
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
                    Fusion.New "TextBox" {
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
                        [Fusion.Children] = {
                            Fusion.New "ImageButton" {
                                Size = UDim2.new(0, 30, 0, 30);
                                AnchorPoint = Vector2.new(1,1);
                                Position = UDim2.new(1,-5,1,-5);
                                Image = "rbxassetid://8439203229";
                                ImageColor3 = BlackState;
                                ZIndex = 2;
                                AutoButtonColor = true;
                                BackgroundColor3 = Fusion.Computed(function()
                                    if SuccessState:get() == 2 then
                                        return Fusion.Tween(WhiteState, TInfo):get()
                                    elseif SuccessState:get() == 0 then
                                        return Fusion.Tween(State(Color3.fromRGB(0,200,0)), TInfo):get()
                                    elseif SuccessState:get() == 1 then
                                        return Fusion.Tween(State(Color3.fromRGB(200,0,0)), TInfo):get()
                                    end
                                end);
                                [Fusion.Children] = {CreateUICorner()};
                                [Fusion.OnEvent("Activated")] = SendMessage;
                            };
                            CreateUICorner();
                            CreateUIPadding();
                        };
                        [Fusion.OnEvent("FocusLost")] = function(enterPressed)
                            if enterPressed then
                                SendMessage()
                            end
                        end;
                        [Fusion.OnChange("Text")] = function(text)
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
        Fusion.New "UIListLayout" {
            Padding = UDim.new(0, 5);
            SortOrder = Enum.SortOrder.LayoutOrder;
            FillDirection = Enum.FillDirection.Vertical;
            HorizontalAlignment = Enum.HorizontalAlignment.Center;
            VerticalAlignment = Enum.VerticalAlignment.Center;
            Parent = AboutFrame;
        };
        Fusion.New "ImageLabel" {
            BackgroundColor3 = BlackState,
            Size = UDim2.new(1, -10, 0, 100);
            BorderSizePixel = 0;
            Image = "rbxassetid://8167715626";
            ScaleType = Enum.ScaleType.Fit;
            Name = "KuraLogo";
            LayoutOrder = 1;
            Parent = AboutFrame;
            [Fusion.Children] = {
                CreateUICorner()
            }
        };
        Fusion.New "TextLabel" {
            BackgroundColor3 = BlackState;
            Size = UDim2.new(1, -10, 0, 20);
            BorderSizePixel = 0;
            Name = "VersionText";
            Text = Fusion.Computed(function()
                local LocalCurrentKuraVersion = LocalKuraVersionState:get()
                local LatestKuraVersion = KuraRF:InvokeServer("LatestKuraVersion")
                local TriggerUpdate = LatestKuraVersion.TriggerUpdate
                local function CreateWarning(props)
                    return Fusion.New "Frame" {
                        BackgroundColor3 = props.Colour;
                        BorderSizePixel = 0;
                        Size = UDim2.new(1,-10,0,30);
                        Parent = AboutFrame;
                        LayoutOrder = 3;
                        [Fusion.Children] = {
                            CreateUICorner();
                            Fusion.New "ImageLabel" {
                                SizeConstraint = Enum.SizeConstraint.RelativeYY;
                                Size = UDim2.new(1,0,1,0);
                                AnchorPoint = Vector2.new(0,0.5);
                                Position = UDim2.new(0,5,0.5,0);
                                ImageColor3 = BlackState;
                                Image = "rbxassetid://8127902797";
                                BackgroundTransparency = 1;
                            };
                            Fusion.New "TextLabel" {
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
            [Fusion.Children] = {
                CreateUICorner();
                CreateUIPadding();
            }
        };
        local function License(props)
            return Fusion.New "TextLabel" {
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
                [Fusion.Children] = {
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
        Fusion.New "ImageLabel" {
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
        RaiseHandButton.selected:Connect(function() end)
        RaiseHandButton.deselected:Connect(function() end)

    else
        ExplorerKuraContainer.Visible = false
    end
end

-- Set up the announcement frames so everyone can see
local FullScreenAnnouncementFrameAppearence = State(false)
local FullScreenAnnouncementFrame = Fusion.New "Frame" {
    Parent = ScreenGui;
    ZIndex = 2003;
    Visible = true;
    BackgroundColor3 = BlackState;
    BackgroundTransparency = Fusion.Computed(function()
        if FullScreenAnnouncementFrameAppearence:get() then
            return Fusion.Tween(State(0.3), TInfo):get()
        else
            return Fusion.Tween(State(1), TInfo):get()
        end
    end);
    Size = UDim2.new(1,0,1,40);
    Position = UDim2.new(0.5,0,0,-40);
    AnchorPoint = Vector2.new(0.5,0);
    [Fusion.Children] = {
        Fusion.New "TextLabel" {
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
            TextTransparency = Fusion.Computed(function()
                if FullScreenAnnouncementFrameAppearence:get() then
                    return Fusion.Tween(State(0), TInfo):get()
                else
                    return Fusion.Tween(State(1), TInfo):get()
                end
            end);
        };
        Fusion.New "TextLabel" {
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
            TextTransparency = Fusion.Computed(function()
                if FullScreenAnnouncementFrameAppearence:get() then
                    return Fusion.Tween(State(0), TInfo):get()
                else
                    return Fusion.Tween(State(1), TInfo):get()
                end
            end);
        };
    };
}

local TopbarAnnouncementFrameAppearence = State(false)
local TopbarAnnouncementFrame = Fusion.New "Frame" {
    Parent = ScreenGui;
    ZIndex = 2000;
    Visible = true;
    BackgroundColor3 = BlackState;
    BackgroundTransparency = Fusion.Computed(function()
        if TopbarAnnouncementFrameAppearence:get() then
            return Fusion.Tween(State(0.3), TInfo):get()
        else
            return Fusion.Tween(State(1), TInfo):get()
        end
    end);
    Size = Fusion.Computed(function()
        if TopbarAnnouncementFrameAppearence:get() then
            return Fusion.Tween(State(UDim2.new(1,0,0,30)), TInfo):get()
        else
            return Fusion.Tween(State(UDim2.new(1,0,0,0)), TInfo):get()
        end
    end);
    Position = UDim2.new(0.5,0,0,5);
    AnchorPoint = Vector2.new(0.5,0);
    [Fusion.Children] = {
        Fusion.New "TextLabel" {
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
            TextTransparency = Fusion.Computed(function()
                if TopbarAnnouncementFrameAppearence:get() then
                    return Fusion.Tween(State(0), TInfo):get()
                else
                    return Fusion.Tween(State(1), TInfo):get()
                end
            end);
        };
    };
}

KuraRE.OnClientEvent:Connect(function(args)
    print(args)
    if args[1] == "KuraSetup" then
        CanUse = args[2]
        SetupKura(args[2])
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
        else
            Locators:ShowLocator(LocalPlayer)
            table.insert(LocatorsTable, LocalPlayer)
        end
        LocatorShownState:set(CopyDict(LocatorsTable))
    elseif args[2] == "HideLocator" then
        local LocatorsTable = LocatorShownState:get()
        if args[2] then
            Locators:ShowLocator(args[2])
            if table.find(LocatorsTable, args[2]) then
                table.remove(LocatorsTable, table.find(LocatorsTable, args[2]))
            end
        else
            Locators:ShowLocator(LocalPlayer)
            if table.find(LocatorsTable, LocalPlayer) then
                table.remove(LocatorsTable, table.find(LocatorsTable, LocalPlayer))
            end
        end
        LocatorShownState:set(CopyDict(LocatorsTable))
    end
end)
--[[
KuraRF.OnClientInvoke = function(args)
    This is such a terrible idea. Never ever do this.
end
]]
if CanUse then SetupKura(CanUse) end