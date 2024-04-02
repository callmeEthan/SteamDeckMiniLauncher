#macro memory_object_UI 20
#macro Font_default Font1
#macro input_up 0
#macro input_down 1
#macro input_left 2
#macro input_right 3
#macro input_enter 4
#macro input_escape 5
#macro input_shift 6
#macro input_device_keyboard 0
#macro input_device_mouse 1

directory = ""
width = 1280;
height = 800;
ppi = height * 0.4
entry = ds_list_create();
select = 0;
state = 0;
alpha = 1.;
highlight = 0;
title = ""
background = spr_background
init_setting()
scan_games()

entry_pos = function(divider=5, cap=50)
{
	var w = width;
	var h = height;
	var s = ds_list_size(entry), xx, yy;
	if (state == 1)
	{
		for(var i=0; i<s; i++)
		{
			var temp = entry[| i]
			yy = (h * 0.15);
			xx = (w * 0.15) + (ppi*0.8*(i-select));
			if i>select xx+=w;
			else if i<select xx-=w;
			temp.x = from_closer_to_clamp(temp.x, xx, divider, cap);
			temp.y = from_closer_to_clamp(temp.y, yy, divider, cap);
			temp.scale = from_closer_to(temp.scale, i=select? ppi*1.4 : ppi*0.75, divider*1.2)
		}
	exit
	}
	
	if (divider <= 0)
	for(var i=0; i<s; i++)
	{
		var temp = entry[| i]
		yy = (h * 0.15);
		xx = (w * 0.15) + (ppi*0.8*(i-select));
		if i>select xx+=ppi
		temp.x = xx; temp.y = yy; temp.scale = ppi*0.75;
	}
	else
	for(var i=0; i<s; i++)
	{
		var temp = entry[| i]
		yy = (h * 0.15);
		xx = (w * 0.15) + (ppi*0.8*(i-select));
		if i>select xx+=ppi
		temp.x = from_closer_to_clamp(temp.x, xx, divider, cap);
		temp.y = from_closer_to_clamp(temp.y, yy, divider, cap);
		temp.scale = from_closer_to(temp.scale, i=select? ppi : ppi*0.75, divider*1.2)
	}
}



entry_pos(0)