-- Example Quick Actions module for demonstration purposes. Licensed with Apache Version 2.0. See LICENSE for details. (c) 2022 Explorers of the Metaverse

--[=[
    @class QuickAction
    Quick Actions provide an interface for the educator to control the experience of the class in your experience. From a single button press on the Quick Actions interface, the Educator can initiate actions to change the Experience.
    :::note
    This module relies on Kura Remote Events.
    :::
]=]

local module = {}

-- Specify services here

local ReplicatedStorage = game:GetService("ReplicatedStorage")


--[=[
    @prop FriendlyName string | {true: string, false: string}
    @within QuickAction
    FriendlyName can either be a fixed string or can vary depending on state, where a table with boolean keys and string values is used.
]=]
module.FriendlyName = {[true] = "On"; [false] = "Off"}

--[=[
    @prop DefaultState boolean
    @within QuickAction
    Specifies the default state which will be passed on to the button in the Quick Action interface.
    :::caution
    If not specified, the DefaultState will be set to false.
    :::
]=]
module.DefaultState = false

--[=[
    @prop Image Content
    @within QuickAction
    Add an image to the button.
    :::info
    If not specified, a default specified in ExplorerKuraServer(/init.server.lua) is used instead with a warning.
    :::
]=]

module.Image = nil

--[=[
    @function ClientFunction
    @within QuickAction
    The ClientFunction is the function that is passed onto the client which is run when the button on the Quick Actions section is activated.
    @param onState: boolean -- Passes on the state of the button from the Quick Action interface.
    @return OnStateResult: boolean -- The new resultant state which will be passed on to the interface to be displayed.
    @return FireServer: any -- The argument which will be passed onto the server after this function finishes via KuraRE. If it is nil, KuraRE does not fire.
    :::danger
    Remember that the onStateResult should be opposite of onState if you want a simple boolean button. Otherwise, the button will get stuck in one state.
    :::
]=]
module.ClientFunction = function(onState: boolean) -- onState basically is the current value of the state of the button.
    if onState then
        return false, nil
    else
        return true, nil
    end
end

--[=[
    @function ServerEvent
    @within QuickAction
    The ServerEvent is the function that the server runs if KuraRE is fired in ClientFunction by providing a return value that is not nil.
    @param Player: Player -- Player who initiated the ClientFunction. This is sanity-checked as the Educator.
    @param ExplorerArgs = {TeleportTargets = {[Player]: TeleportTarget}, MutedPlayers = {[Player]: MutedPlayer}, Locators = {[Player]: LocatorServer},} -- Arguments passed on from ExplorerKuraServer. If you are not using QuickActions, use the ExplorerGetters folder.
    @param ClientArgs: any -- Arguments passed on by the user in the ClientFunction.
]=]
module.ServerEvent = function(player: Player, ExplorerArgs, ClientArgs) -- player is the player requesting the function (which is only the educator currently), ExplorerArgs are tables that ExplorerKuraServer stores whilst ClientArgs are arguments passed over by the ClientFunction.

end

return module