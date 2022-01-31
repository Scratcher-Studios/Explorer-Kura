# Installation

## Quick Install

### 1. Get the .rbxm

**Via GitHub**

Go to the [Releases](https://github.com/Scratcher-Studios/Explorer-Kura/releases) page on GitHub and download the .rbxm file of the latest version.

**Via Roblox**

[This link will direct you to the latest published version of the module.](https://www.roblox.com/library/8608062925/Explorer-Kura-Education-Module)

Alternatively, go to the [Releases](https://github.com/Scratcher-Studios/Explorer-Kura/releases) page on GitHub and follow the link to the Roblox model.

Only trust models created by [EcoScratcher](https://www.roblox.com/users/153299765/profile) (with a verified tick) or [Explorers of the Metaverse](https://www.roblox.com/groups/12236350/Explorers-of-the-Metaverse#!/about).

### 2. Run the Script

Copy and paste the Kura Installation script into the Command Bar. This is the bar that is usually at the bottom of the screen. If it is not present, you may need to enable it in the View ribbon of Studio. Press enter to fire the script.

### 3. Playtest

In ExplorerKuraServer, change the TESTING_MODE variable to 1 (for Educator) or 2 (for Student). This will allow you to test if the installation has succeeded.

## Install via GitHub
Download from the GitHub repository the zip, then place the following scripts in these following areas:

ExplorerKuraClient goes into client (StarterPlayerScripts)

ExplorerKuraServer goes into server (ServerScriptService)

ExplorerKuraQuickActions goes into shared (ReplicatedStorage)

## Dependency behaviour

As it is curently set:

- TopbarPlus will use the currently initialised version as per the value object in ReplicatedStorage. If there is no initialised version, the version bundled with Kura will be initialised.

- Fusion will use the version bundled with Kura as it is currently still pre-release software.

The following table shows which versions of Fusion are bundled with each version of Explorer Kura.

| Kura version | Fusion version |
|--------------|----------------|
| v0.2.0       | v0.1           |
| v0.1.0       | v0.1           |