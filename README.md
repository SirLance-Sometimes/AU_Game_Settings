# AU_Game_Settings

## Summary
The purpose of AU_Save_Game.ps1 is to add functionality to the popular game Among US.  Currently the game doesn't have options to save game setting configurations.  These settings are changed in game and the last settings a player uses are stored, on windows computers, in the user profile `AppData\LocalLow\Innersloth\Among Us\gameHostOptions` . However this file is only used for restoring the settings from the last time a player hosted a game.  Copying these settings to another directory allows us to preserve setting a player might wish to reuse.  This program does exactly that and allows a description to be added on to help a player describe and understand the save file.

## Short comings
This program/script works outside of the game Among US, therefore it must work around behaviors built into the game.

* Once Among Us has started and loaded the configuration at `AppData\LocalLow\Innersloth\Among Us\gameHostOptions` any subsequent overwriting of the configuration file will result in the game using the original setting loaded into memory, and overwriting the configuration file.  Therefore you must load the settings before you launch the game or before you host a game.  If you wish to load new setting you will need to exit the game, run this program to load saved settings, and relaunch the game.

* This program only saves and loads copies of the configuration file, it doesn't offer editing options.  This is because the game is the best native editor of the settings file.
