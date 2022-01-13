--[[
    LocatorsServer, the server component of the Kura locators system. Licensed with Apache Version 2.0. See LICENSE for details. (c) 2022 Explorers of the Metaverse
]]

local obj = {}
obj.__index = obj

local Maid = require(script.Parent.Maid)

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RE

task.spawn(function()
    RE = ReplicatedStorage:WaitForChild("KuraRE")
end)

function obj.New(Target)
    local self = {}
    self.Target = Target
    self.__Maid = Maid.new()

    self.LocatorShown = false

    setmetatable(self, obj)
    return self
end

function obj:ShowLocator(isEducatorRequesting, educator, isEducatorRequestingSelf)
    RE:FireClient(self.Target, {"ShowLocator"})
    if not isEducatorRequestingSelf then
        RE:FireClient(educator, {"ShowLocator", self.Target})
    end
    self.LocatorShown = true
end

function obj:HideLocator(isEducatorRequesting, educator, isEducatorRequestingSelf)
    RE:FireClient(self.Target, {"HideLocator"})
    if not isEducatorRequestingSelf then
        RE:FireClient(educator, {"HideLocator", self.Target})
    end
    self.LocatorShown = false
end

function obj:Destroy()
    self.__Maid = nil
    obj = nil
end

return obj