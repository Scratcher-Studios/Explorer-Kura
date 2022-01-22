# Installation

## Quick Install

### 1. Get the .rbxm

**Via GitHub**

Go to the Releases page and download the .rbxm file of the latest version.

**Via Roblox**

Go to the Releases page and follow the link to the Roblox mode.

Only trust models created by EcoScratcher (with a verified tick) or Explorers of the Metaverse.

### 2. Run the Script

Copy and paste the Kura Installation script into the Command Bar. This is the bar that is usually at the bottom of the screen. If it is not present, you may need to enable it in the View ribbon of Studio. Press enter to fire the script.

### 3. Playtest

In ExplorerKuraServer, change the TESTING_MODE variable to 1 (for Educator) or 2 (for Student). This will allow you to test if the installation has succeeded.

## Install via GitHub
Download from the GitHub repository the zip, then copy the the following in some order:

ExplorerKuraClient goes into client (StarterPlayerScripts)

ExplorerKuraServer goes into server (ServerScriptService)

ExplorerKuraQuickActions goes into shared (ReplicatedStorage)

## Dependency behaviour

As it is curently set:

- TopbarPlus will use the currently initialised version as per the value object in ReplicatedStorage. If there is no initialised version, the version bundled with Kura will be initialised.

- Fusion will use the version bundled with Kura as it is currently still pre-release software.