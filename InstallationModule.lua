--[[
    EXPLORER KURA VERSION 0.1.0
    Thank you for choosing to install Explorer Kura.
    To install, please parent this script to Workspace, select the contents of this script (Ctrl+A), copy into the Command Bar (bar at the
    bottom of your screen) and hit Enter to run the script.
    To uninstall, delete all instances starting with "ExplorerKura".
]]

local InstallScript = workspace:FindFirstChild("Kura Installation")
assert(InstallScript, "Place the script inside Workspace.")

InstallScript.ExplorerKuraClient.Parent = game:GetService("StarterPlayer").StarterPlayerScripts
InstallScript.ExplorerKuraServer.Parent = game:GetService("ServerScriptService")
InstallScript.ExplorerKuraQuickActions.Parent = game:GetService("ReplicatedStorage")

print("Installation complete, cleaning up...")
local Debris = game:GetService("Debris")
Debris:AddItem(InstallScript)