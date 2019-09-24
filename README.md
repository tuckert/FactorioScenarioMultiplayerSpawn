# FactorioScenarioMultiplayerSpawn
A custom scenario for allowing separate spawn locations in multiplayer. Designed for Co-op and PvE. 

0.17 is in a dev branch "dev_0.17". At this point it's basically stable. I will merge to master once 0.17 factorio is made stable.

0.16 is stable but will not receive any further updates.

## Instructions

### STEP 1

Download the zip. 

Place it in your Factorio/scenarios/... folder.

It should look something like this (for my windows steam install location):

C:\Users\user\AppData\Roaming\Factorio\scenarios\FactorioScenarioMultiplayerSpawn\control.lua


### STEP 2

Go into config.lua and edit the strings to add your own server messages.

Rename the "FactorioScenarioMultiplayerSpawn" folder to something shorter and more convenient (optional).


### STEP 3

#### OPTION 1 (Client Hosted)
Start a multiplayer game on your client like normal.

#### OPTION 2 (Headless)
Generate a new map, use that save file to host if you want to.

#### OPTION 3 (Headless)
Place the scenario code in the game's scenario folder, typically something like "..\Factorio\scenarios\FactorioScenarioMultiplayerSpawn\\.."

Start a new game (generates a random map based on the config in config.lua) from the command line:
./factorio --start-server-load-scenario FactorioScenarioMultiplayerSpawn --server-settings my-server-settings.json

If you want to RESUME from this method, use something like this:
./factorio --start-server-load-latest --server-settings my-server-settings.json


## Configuration

Look in config.lua for some controls over the different modules.  

Not all configurations have been fully tested so modify at your own risk.

If you want to change the RSO config, look for the rso_config and rso_resource_config files.


## TODO

I need to update this with more details about the implementation and explain some of the configuration options.

For now, just take a look at the source and it should be easy to understand I hope.

## Stable Version (Factorio v0.17.69)
At this point master branch is basically stable, I'll help with bug fixes and minor features but I have no large changes planned.

## Credit
Several other portions of the code (tags, frontier style rocket silo) have also been adapted from other scenario code.

Credit to 3Ra for help as well: https://github.com/3RaGaming

Praise be to Mylon

## Random Notes
Feel free to submit bugs/fixes/requests/pulls/forks whatever you want.

I do not plan on supporting PvP, but I will help anyone who wants to make it a configurable option.

## Contact
discord.gg/trnpcen
oarcinae@gmail.com
