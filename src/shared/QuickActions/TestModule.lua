local module = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")

module.FriendlyName = {[true] = "On"; [false] = "Off"}

module.DefaultState = false

module.Image = nil

module.ClientFunction = function(onState)
    if onState then
        return false, nil -- OnStateResult, FireServer
    else
        return true, nil -- OnStateResult, FireServer
    end
end

module.ServerEvent = function(player, args)

end

return module