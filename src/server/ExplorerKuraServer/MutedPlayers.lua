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

    self.Muted = false

    setmetatable(self, obj)
    return self
end

function obj:Mute()
    RE:FireClient(self.Target, {"Mute"})
    self.Muted = true
end

function obj:Unmute()
    self.Muted = false
    RE:FireClient(self.Target, {"Unmute"})
end

function obj:Destroy()
    self.__Maid = nil
    obj = nil
end

return obj