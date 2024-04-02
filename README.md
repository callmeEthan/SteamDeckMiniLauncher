# Steam Deck Mini Launcher
I wanted to play some mini game on steam deck, but don't want to bother adding every game onto steam and customize cover, icon, background, ect... So this launcher was created.  
**Made using gamemaker 2 in a day**
![alt text](https://github.com/callmeEthan/SteamDeckMiniLauncher/blob/main/Screenshot/screenshot0.png?raw=true)
It is useful for launching many mini game. Or a game series/franchise without them needing to be added to steam library individually. These game will also share the same compatdata, saving some disk space, and allow games such as Mass Effect to share save files.
# How to run
- Download the [latest release](https://github.com/callmeEthan/SteamDeckMiniLauncher/releases) onto your steam deck, extract it anywhere.  
- Add **AutoLauncher.exe** to steam as non-steam game, make sure to run it with Proton compatibility.  
- Navigate with dpad left, right. Press A to start game. Press B to exit.
- **Some file are included as an example template, you should delete them and move your own game folder in.**
# How to config/add game
There is no config interface, all setting are inside ini files.  
Once the launcher started, it will looks for games folder inside "Games\\\*", you can edit **setting.ini** to change game folder, title and background image.  
```
[SETTINGS]
directory = "Game\"
title = "Mass Effect Legendary Edition"
background = "shepard.jpg"
```
Each folder inside "Games\\\*" are considered an entry, and a **launcher.ini** file will be created inside them.  
You can edit **launcher.ini** to config game entry (game title, cover image, description, executable, launch parameter).  
```
[Game]
title="Mass Effect"
cover="me1.png"
last_play="45383.726233"
description="As Commander Shepard, you lead an elite squad on a heroic, action-packed adventure throughout the galaxy."
launch="Binaries\Win64\MassEffect1.exe"
parameter="-NoHomeDir -SeekFreeLoadingPCConsole -Subtitles 20 -OVERRIDELANGUAGE=INT"
```
Executable and image file are automatically added to launcher.ini if found (subdirectories are not scanned).  
# Credit
**Me**  
Source code are available, you can redistribute it and/or modify it under the terms of the GNU General Public License Version 3 as published by the Free Software Foundation. 
