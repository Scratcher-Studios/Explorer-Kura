--[[
    EXPLORER KURA VERSION DEV
    Thank you for choosing to install Explorer Kura.
    To install, please parent this script to Workspace, select the contents of this script (Ctrl+A), copy into the Command Bar (bar at the
    bottom of your screen) and hit Enter to run the script.
    To uninstall, delete all instances starting with "ExplorerKura".
]]

local InstallScript = workspace:FindFirstChild("Kura Installation")
local Debris = game:GetService("Debris")
assert(InstallScript, "Place the script inside Workspace.")

Debris:AddItem(InstallScript.ExplorerKuraQuickActions.ExampleQuickActionsModule)

InstallScript.ExplorerKuraClient.Parent = game:GetService("StarterPlayer").StarterPlayerScripts
InstallScript.ExplorerKuraServer.Parent = game:GetService("ServerScriptService")
InstallScript.ExplorerKuraQuickActions.Parent = game:GetService("ReplicatedStorage")

print("Installation complete, cleaning up...")

Debris:AddItem(InstallScript)