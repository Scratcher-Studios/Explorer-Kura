local module = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")

module.FriendlyName = "hi"

module.DefaultState = false

module.Image = nil

module.ClientFunction = function()
    print("henlo")
    return nil, nil
end

module.ServerEvent = function()

end

return module