-- LocatorsServer, the server component of the Kura locators system. Licensed with Apache Version 2.0. See LICENSE for details. (c) 2022 Explorers of the Metaverse

--[=[
    @class LocatorsServer
    Stores locator information server-side.
    :::note
    This module relies on Kura Remote Events and may desync with the client.
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
    @within LocatorsServer
    Creates a new LocatorServer object which stores data
    @param Target Player -- Player which the Locator object is associated with
    @return LocatorServer
]=]

function obj.New(Target)
    local self = {}
    self.Target = Target
    self.__Maid = Maid.new()

    self.LocatorShown = false

    setmetatable(self, obj)
    return self
end

--[=[
    @within LocatorsServer
    Shows locator of a specific LocatorServer
    @param isEducatorRequesting boolean -- Unused
    @param educator Player -- Educator from Explorer Kura
    @param isEducatorRequestingSelf boolean -- States if it is the Educator which is requesting the action. This is to prevent the remote event firing twice at the same player.
]=]

function obj:ShowLocator(isEducatorRequesting, educator, isEducatorRequestingSelf)
    RE:FireClient(self.Target, {"ShowLocator"})
    if not isEducatorRequestingSelf then
        RE:FireClient(educator, {"ShowLocator", self.Target})
    end
    self.LocatorShown = true
end

--[=[
    @within LocatorsServer
    Shows locator of a specific LocatorServer
    @param isEducatorRequesting boolean -- Unused
    @param educator Player -- Educator from Explorer Kura
    @param isEducatorRequestingSelf boolean -- States if it is the Educator which is requesting the action. This is to prevent the remote event firing twice at the same player.
]=]

function obj:HideLocator(isEducatorRequesting, educator, isEducatorRequestingSelf)
    RE:FireClient(self.Target, {"HideLocator"})
    if not isEducatorRequestingSelf then
        RE:FireClient(educator, {"HideLocator", self.Target})
    end
    self.LocatorShown = false
end

--[=[
    @within LocatorsServer
    Destroys object.
]=]

function obj:Destroy()
    self.__Maid = nil
    obj = nil
end

return obj