var s = ds_list_size(entry);
var w = width;
var h = height;
var scale, date, desc;
var l = string_height("1")
var hl = cos(highlight)*0.5+0.5;
draw_set_font(Font2)
//draw_sprite_stretched_ext(background, 0, 0,0,w,h, c_white, 1);
draw_sprite_crop(background, 0, 0,0,w,h)

for(var i=0; i<s; i++)
{
	var temp = entry[| i]
	scale=temp.scale
	if i==select
	{
		date = "Last played: "+(temp.last_play==0 ? "Never" : date_datetime_string(temp.last_play));
		desc = temp.description;
		draw_text(temp.x, temp.y+scale*1.+20, temp.name)
		draw_text_ext_transformed(temp.x+scale*0.95, temp.y, date, l, ppi*1.8, 0.5, 0.5, 0)
		draw_set_alpha(0.8*alpha)
		draw_text_ext_transformed(temp.x, temp.y+ppi+l+20, desc, l, ppi*6, 0.5, 0.5, 0)
		draw_set_alpha(hl);
		draw_roundrect_color_ext(temp.x-5, temp.y-5, temp.x+scale*0.9+5, temp.y+scale+5, 10, 10, c_white, c_white, true)
		draw_set_alpha(alpha*0.8);
	} else {
		draw_text_transformed(temp.x, temp.y+scale*1.+5, temp.name, 0.45, 0.45, 0)
	}
	draw_sprite_crop(temp.cover, 0, temp.x, temp.y, scale*0.9, scale);
}

draw_set_alpha(0.4*alpha)
draw_line(w*0.05, h-l*.7-30, w*0.95, h-l*.7-30)
draw_set_alpha(alpha)

draw_text_transformed(40,30,title, 0.8, 0.8, 0)
draw_set_halign(fa_right)
draw_text_transformed(w-30,30,date_time_string(date_current_datetime()), 0.5, 0.5, 0)
var xx=w-30;
draw_text_transformed(xx, h-l, "Play", 0.7, 0.7, 0);
xx-=string_width("Play")*.7 + l*.7;
draw_sprite_stretched(spr_gamepad, 0, xx, h-l, l*.7, l*.7)
xx-=l*.7
draw_text_transformed(xx, h-l, "Exit", 0.7, 0.7, 0);
xx-=string_width("Exit")*.7 + l*.7;
draw_sprite_stretched(spr_gamepad, 1, xx, h-l, l*.7, l*.7)
xx-=l*.7
draw_text_transformed(xx, h-l, "Navigate", 0.7, 0.7, 0);
xx-=string_width("Navigate")*.7 + l*.7;
draw_sprite_stretched(spr_gamepad, 2, xx, h-l, l*.7, l*.7)
draw_set_halign(fa_left)
/*
draw_set_halign(fa_left)
draw_sprite_stretched(spr_gamepad, 2, 30, h-l, l*.7, l*.7)
draw_text_transformed(l+30, h-l, "Navigate", 0.7, 0.7, 0);