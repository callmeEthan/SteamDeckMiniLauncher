function init_setting()
{
	var bkg;
	ini_open("setting.ini")
	directory = ini_read_string("SETTINGS", "directory", "Games\\")
	title = ini_read_string("SETTINGS", "title", "")
	bkg = ini_read_string("SETTINGS", "background", "");
	ini_close();
	log("Root directory = "+string(directory));
	if bkg != "" && file_exists(bkg)
	{
		log("Loading background: "+bkg)
		background = sprite_add(bkg, 1, 0,0,0,0)
	}
}

function scan_games()
{
	log("Scanning game folder...")
	var temp = file_list_files(directory+"*", fa_directory)
	var s = array_length(temp)
	var game;
	log(string(s)+" game(s) found")
	for(var i=0;i<s;i++)
	{
		log(temp[i]);
		if !directory_exists(directory+temp[i]) continue
		if file_exists(directory+temp[i]+"\\launcher.ini") game = load_entry_data(temp[i])
		else game=generate_entry_data(temp[i])

		if !file_exists(directory+temp[i]+"\\"+game.cover)
		{
			game.cover = spr_img;
		} else {
			game.cover = sprite_add(directory+temp[i]+"\\"+game.cover, 1, 0, 0, 0, 0)
		}
		ds_list_add(self.entry, game)
	}
}

function generate_entry_data(name)
{
	var temp = {
		name: name,
		folder: name,
		cover: "Cover.png",
		last_play: 0,
		description: "No info",
		launch: "game.exe",
		param: ""
	}
	var files = file_list_files(directory+string(name)+"\\*")
	var s = array_length(files)
	for(var i=0;i<s;i++)
	{
		if filename_ext(files[i])==".exe" {temp.launch=files[i];}
		if filename_ext(files[i])==".png" {temp.cover=files[i];}
	}
	
	ini_open(directory+name+"\\launcher.ini");
	ini_write_string("Game", "title", temp.name);
	ini_write_string("Game", "cover", temp.cover);
	ini_write_real("Game", "last_play", temp.last_play);
	ini_write_string("Game", "description", temp.description);
	ini_write_string("Game", "launch", temp.launch);
	ini_write_string("Game", "parameter", temp.param);
	ini_close();
	return temp;
}

function load_entry_data(name)
{
	var temp = {}
	ini_open(directory+name+"\\launcher.ini")
	temp.name = ini_read_string("Game", "title", name)
	temp.folder = name
	temp.cover = ini_read_string("Game", "cover", "Cover.png")
	temp.last_play = ini_read_real("Game", "last_play", 0)
	temp.description = ini_read_string("Game", "description", "No info")
	temp.launch = ini_read_string("Game", "launch", "game.exe")
	temp.param = ini_read_string("Game", "parameter", "")
	ini_close();
	return temp;
}

function launch_game(struct)
{
	var name = struct.name;
	ini_open(directory+struct.folder+"\\launcher.ini");
	ini_write_real("Game", "last_play",  date_current_datetime());
	ini_close()
	var dir = directory+struct.folder+"\\"+struct.launch;
	execute_shell_simple(dir, struct.param);
}