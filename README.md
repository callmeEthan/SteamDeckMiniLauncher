# Steam Deck Mini Launcher
I wanted to play some mini game on steam deck, but don't want to bother adding every game onto steam and customize cover, icon, background, ect... So this launcher was created.  
**Made using gamemaker 2 in a day**
![alt text](https://github.com/callmeEthan/SteamDeckMiniLauncher/blob/main/Screenshot/screenshot0.png?raw=true)
It is useful for launching many mini game. Or a game series/franchise without them needing to be added to steam library individually. These game will also share the same compatdata, saving some disk space, and allow games such as Mass Effect to share save files.
# How to run
- Download the [latest release](https://github.com/callmeEthan/SteamDeckMiniLauncher/releases) onto your steam deck, extract it anywhere.  
- Add **AutoLauncher.exe** to steam as non-steam game, make sure to run it with Proton compatibility.  
- Navigate with dpad left, right. Press A to start game. Press B to exit, Shoulder LR button to switch category.
- **Some file are included as an example template, you should delete them and move your own game folder in.**
# How to config/add game
There is no config interface, all setting are inside ini files.  
Once the launcher started, it will looks for game folders and create **ini** configuration file automatically.  
The format is as follow:
### Categories
Each folder next to the launcher.exe is considered a category (Games, Application, ect...), a **setting.ini** file will be created inside them.
```
[SETTINGS]
ignore="0.000000"
background=""
title="Application"
```
<details>
  <summary>Variables detail</summary>
- ignore: set to 1 to hide this category.
- background: image file to use as background, place the image next to the ini file. If image file is not found, it will use default background instead.
- title: name of the category to display.
</details>
### Games/Entries
Each folder inside the categories folder are considered an entry, and a **launcher.ini** file will be created inside them.  
```
[Game]
parameter="-NoHomeDir -SeekFreeLoadingPCConsole -Subtitles 20 -language=INT"
launch="Binaries\Win64\MassEffect3.exe"
description="Earth is burning. The Reapers have taken over and other civilizations are falling like dominoes. Lead the final fight to save humanity and take back Earth from these terrifying machines, Commander Shepard. "
last_play="45383.733906"
cover="me3.png"
title="Mass Effect 3"
```
<details>
  <summary>Variables detail</summary>
- parameter: launch parameter to launch the executable with.
- launch: directory of the executable to launch.
- description: optional.
- last_play: this value will be updated automatically when you launch the game.
- cover: image file to use as cover, place the image file next to the ini.
- title: name of the entry to display.
</details>
Executable and image file are automatically added to launcher.ini if found (subdirectories are not scanned). Althought it might not be the file  you wanted, you should still enter it yourself...  
# Useful tips
You can use symlink to link game folder instead of copy the whole game file.  
You can create multiple entry for the same game (making multiple launch option for a  single game possible):
- Create an empty game folder.
- Edit the entry ini file, and set ```launch = "../Game folder/game.exe"```  
```"../"``` will navigate up one directory level, you can even open entry in a different category by moving one step further:  
```launch = "../../Category/Game folder/game.exe"```
# Credit
**Me**  
Source code are available, you can redistribute it and/or modify it under the terms of the GNU General Public License Version 3 as published by the Free Software Foundation. 
