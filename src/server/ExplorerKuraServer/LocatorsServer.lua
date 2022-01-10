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

function obj:ShowLocator(isEducatorRequesting, educator)
    if isEducatorRequesting then
        RE:FireClient(obj.Target, {"ShowLocator"})
    else
        RE:FireClient(educator, {"ShowLocator", self.Target})
    end
    self.LocatorShown = true
end

function obj:HideLocator(isEducatorRequesting, educator)
    if isEducatorRequesting then
        RE:FireClient(obj.Target, {"HideLocator"})
    else
        RE:FireClient(educator, {"HideLocator", self.Target})
    end
    self.LocatorShown = false
end

function obj:Destroy()
    self.__Maid = nil
    obj = nil
end

return obj