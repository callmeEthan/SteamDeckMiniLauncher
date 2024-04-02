// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function log(text,type){
	text=string(text)
	if type="error" {
		show_debug_message("ERROR: "+text)}
	else if type="success" {
		show_debug_message("SUCCESS: "+text)}
	else if type="quiet" {
		show_debug_message(text)}
	else {show_debug_message(text)}
}

function debug_overlay(text, index=-1) {
	var out = false;
	if index<0 {
		ds_list_add(main.debug_txt, string(text));
		return true;
	} else {
		var s = ds_list_size(main.debug_txt);
		ds_list_set(main.debug_txt, index, string(text));
		if s<=index return true else return false
	}
}

function split_string(str,substr,ds_list) {
var s = str, d = substr;
var rl = ds_list;
var p = string_pos(d, s), o = 1;
var dl = string_length(d);
ds_list_clear(rl);
if (dl) while (p) {
    ds_list_add(rl, string_copy(s, o, p - o));
    o = p + dl;
    p = string_pos_ext(d, s, o);
}
ds_list_add(rl, string_delete(s, 1, o - 1));
}
	
function cmd_init() {	
	global.temp_list=ds_list_create();
	global.temp_map=ds_map_create();
	global.temp_grid=ds_grid_create(1,1);
	
	global.script_ids=ds_map_create();
	global.object_ids=ds_map_create();
	global.memory_ids=ds_map_create();
	global.variables=ds_map_create();
	var s=global.script_ids
	var o=global.object_ids
		
		ds_map_add(s,"sub_cmd",sub_cmd)
		ds_map_add(s,"create_object",create)
		
		ds_map_add(s,"exit",shutdown)
}



function cmd_parse(str) {
	if is_undefined(str) {log("Command string undefined","error");exit}
	var ds=global.temp_list
	var d=" "
	var dl= 1;
	var p = string_pos(d,str);
	var o = 1;
	var sl = string_length(str)
	ds_list_clear(global.temp_list)
	
while (p>0 && p<sl+1) {	
	ds_list_add(ds, string_copy(str, o, p-o))
	o = p+dl
	if string_char_at(str,o)="\"" {p = string_pos_ext("\"", str, o+1);o+=1;dl=2} else {p = string_pos_ext(d, str, o);dl=1}
}
if o<=string_length(str) {ds_list_add(ds, string_delete(str, 1, o-1))}
if ds_map_exists(global.script_ids, ds[| 0]) {
	if ds_list_size(ds) = 1			script_execute(global.script_ids[? ds[| 0]])
	else if ds_list_size(ds) = 2	script_execute(global.script_ids[? ds[| 0]], ds[| 1])
	else if ds_list_size(ds) = 3	script_execute(global.script_ids[? ds[| 0]], ds[| 1], ds[| 2])
	else if ds_list_size(ds) = 4	script_execute(global.script_ids[? ds[| 0]], ds[| 1], ds[| 2], ds[| 3])
	else if ds_list_size(ds) = 5	script_execute(global.script_ids[? ds[| 0]], ds[| 1], ds[| 2], ds[| 3], ds[| 4])
	else if ds_list_size(ds) = 6	script_execute(global.script_ids[? ds[| 0]], ds[| 1], ds[| 2], ds[| 3], ds[| 4], ds[| 5])
	else if ds_list_size(ds) = 7	script_execute(global.script_ids[? ds[| 0]], ds[| 1], ds[| 2], ds[| 3], ds[| 4], ds[| 5], ds[| 6])
	else if ds_list_size(ds) = 8	script_execute(global.script_ids[? ds[| 0]], ds[| 1], ds[| 2], ds[| 3], ds[| 4], ds[| 5], ds[| 6], ds[| 7])
	else if ds_list_size(ds) = 9	script_execute(global.script_ids[? ds[| 0]], ds[| 1], ds[| 2], ds[| 3], ds[| 4], ds[| 5], ds[| 6], ds[| 7], ds[| 8])
	else if ds_list_size(ds) = 10	script_execute(global.script_ids[? ds[| 0]], ds[| 1], ds[| 2], ds[| 3], ds[| 4], ds[| 5], ds[| 6], ds[| 7], ds[| 8], ds[| 9])
	} else {
	if ds_list_size(ds) = 1			script_execute(sub_cmd, self, ds[| 0])
	else if ds_list_size(ds) = 2	script_execute(sub_cmd, self, ds[| 0], ds[| 1])
	else if ds_list_size(ds) = 3	script_execute(sub_cmd, self, ds[| 0], ds[| 1], ds[| 2])
	else if ds_list_size(ds) = 4	script_execute(sub_cmd, self, ds[| 0], ds[| 1], ds[| 2], ds[| 3])
	else if ds_list_size(ds) = 5	script_execute(sub_cmd, self, ds[| 0], ds[| 1], ds[| 2], ds[| 3], ds[| 4])
	else if ds_list_size(ds) = 6	script_execute(sub_cmd, self, ds[| 0], ds[| 1], ds[| 2], ds[| 3], ds[| 4], ds[| 5])
	else if ds_list_size(ds) = 7	script_execute(sub_cmd, self, ds[| 0], ds[| 1], ds[| 2], ds[| 3], ds[| 4], ds[| 5], ds[| 6])
	else if ds_list_size(ds) = 8	script_execute(sub_cmd, self, ds[| 0], ds[| 1], ds[| 2], ds[| 3], ds[| 4], ds[| 5], ds[| 6], ds[| 7])
	else if ds_list_size(ds) = 9	script_execute(sub_cmd, self, ds[| 0], ds[| 1], ds[| 2], ds[| 3], ds[| 4], ds[| 5], ds[| 6], ds[| 7], ds[| 8])
	else if ds_list_size(ds) = 10	script_execute(sub_cmd, self, ds[| 0], ds[| 1], ds[| 2], ds[| 3], ds[| 4], ds[| 5], ds[| 6], ds[| 7], ds[| 8], ds[| 9])
	}
}
///@func sub_cmd(obj, cmd, arguments...)
function sub_cmd(obj,cmd) {
	global.cmd=array_create(argument_count-1)
	global.cmd[@ 0]=cmd
    for (var i = 2; i < argument_count; i ++)
    {
        global.cmd[@ i-1] = argument[i];
    }
	with(obj) event_user(1);
	return(global.cmd);
}

function shutdown() {
	game_end()
	}

function create(object) {
	if is_undefined(object) {log("Object name undefined","error")}
	if is_string(object) {
		object=global.object_ids[? object]
		if !is_undefined(object) {instance_create_depth(0,0,0,object)}
	}
	log("Unknown object name","error")
}

function mouse_get_button_pressed() {
	if mouse_check_button_pressed(mb_right) {return(mb_right)}
	else if mouse_check_button_pressed(mb_left) {return(mb_left)}
	else if mouse_check_button_pressed(mb_middle) {return(mb_middle)}
	else if mouse_check_button_pressed(mb_side1) {return(mb_side1)}
	else if mouse_check_button_pressed(mb_side2) {return(mb_side2)}
	return(mb_none)
	}
	
function mouse_get_button_released() {
	if mouse_check_button_released(mb_right) {return(mb_right)}
	else if mouse_check_button_released(mb_left) {return(mb_left)}
	else if mouse_check_button_released(mb_middle) {return(mb_middle)}
	else if mouse_check_button_released(mb_side1) {return(mb_side1)}
	else if mouse_check_button_released(mb_side2) {return(mb_side2)}
	return(mb_none)
	}

function mouse_check_double_pressed(button) {
	if main.mb_isdouble = true and (button=main.mb_previous or button=mb_any) {return(true)} else {return(false)}
}

function mouse_check_is_hold(button) {
	if main.mb_ishold = true and (button=main.mb_previous or button=mb_any) {return(true)} else {return(false)}
}

function mouse_check_tapped(button) {
	if main.mb_istap = true and (button=main.mb_previous or button=mb_any) {return(true)} else {return(false)}
}

function input_check(input) {
	return(global.input[input])
}

function string_is_number(str) {
	var len = string_length(str);
	var found_decimal = false;
	var initial_digit_index = string_char_at(str, 1) == "-" ? 2 : 1
	for(var i = initial_digit_index; i <= len; ++i) {
	    var c = string_ord_at(str, i);
	   if c == ord(".") {
		    if found_decimal {
	         return false;
	       }
	       initial_digit_index = i + 1;
	        found_decimal = true;
	        continue;
	    } else if c <= ord("9") && c >= ord("0") {
	        continue;
	    } else {
	        return false;
	  }
	}
	return i != initial_digit_index;
}
	
function thousands_separator(val) {
	var r, i, d;
	d=frac(val)
	r = string(floor(val))
	for (i = string_length(r) - 2; i > 1; i -= 3) {
		r = string_insert(",", r, i)}
	if d>0 {
		d=string(d)
		d=string_copy(d,3,string_length(d-2))
		r=r+"."+d}
return r
}

function date_format(format, datetime=date_current_datetime())    {
    /// @func   date_format(format, datetime)
    ///
    /// @desc   Returns a formatted string generated from a date-time.
    ///         If no date-time value is given, the current time is used. 
    ///         Find additional notes and format examples below.
    ///
    /// @param  {string}    format      string controlling date formatting
    /// @param  {real}      [datetime]  optional date-time value
    ///
    /// @return {string}    the formatted date-time
    ///
    /// Day format characters:
    ///     d - day of the month with leading zeros, 2 digits with leading zeros; 01 through 31
    ///     D - day of the week, textual, 3 letters; Fri
    ///     j - day of the month without leading zeros; 1 through 31
    ///     l - day of the week, textual, long; Friday
    ///     N - ISO 8601 day number of the week; 1 (Monday) through 7 (Sunday)
    ///     S - English ordinal suffix, textual, 2 characters; st, nd, rd, th
    ///     w - day of the week, numeric, 0 (Sunday) through 6 (Saturday)
    ///     z - day of the year (starting from zero); 0 through 365
    ///
    /// Week format characters:
    ///     W - ISO 8601 week number of year, weeks starting on Monday; 42
    ///
    /// Month format characters:
    ///     F - month, textual, long; January
    ///     m - month with leading zeros; 01 through 12
    ///     M - month, textual, 3 letters; Jan
    ///     n - month without leading zeros; 1 through 12
    ///     t - number of days in the given month; 28 through 31
    ///
    /// Year format characters:
    ///     L - whether it is a leap year; 0 or 1
    ///     o - ISO 8601 year, like Y unless ISO week belongs to prev or next year; 2008
    ///     Y - year, 4 digits; 1999
    ///     y - year, 2 digits; 99
    ///
    /// Time format characters:
    ///     a - lowercase Ante meridiem and Post meridiem; am or pm
    ///     A - uppercase Ante meridiem and Post meridiem; AM or PM
    ///     g - hour, 12-hour format without leading zeros; 1 through 12
    ///     G - hour, 24-hour format without leading zeros; 0 through 23
    ///     h - hour, 12-hour format; 01 through 12
    ///     H - hour, 24-hour format; 00 through 23
    ///     i - minutes, with leading zero; 00 through 59
    ///     s - seconds, with leading zero; 00 through 59
    ///
    /// Full Date/Time format characters:
    ///     c - ISO 8601 extended format date; 2004-02-12T15:19:21
    ///     r - RFC 2822 formatted data; Thu, 21 Dec 2000 16:01:07 -0000
    ///     U - seconds since the Unix epoch
    ///
    ///     \ - next character output literally, not interpreted (see note below)
    ///
    /// Note: \ (backslash) is an "escape" character in standard strings and must itself
    ///     be escaped. For instance, \t is interpreted as the TAB character in a standard
    ///     string; when written as \\t, a literal "t" is produced by this function instead.
    ///     However, GameMaker Studio 2 also has "verbatim" strings which do not use escape
    ///     sequences. These are literal strings prefixed by an @ symbol. Backslashes in
    ///     these do not require escaping and \t would produce a literal "t" not a TAB.
    ///
    /// Examples:
    ///     date_format("l jS \\of F Y h:i:s A") == "Sunday 4th of May 2008 05:45:34 PM"
    ///     date_format("\\I\\t \\i\\s \\t\\h\\e zS \\d\\a\\y.") == "It is the 124th day."
    ///     date_format(@"\I\t \i\s \t\h\e zS \d\a\y.") == "It is the 124th day."
    ///
    /// GMLscripts.com/license
        var out = "";
        var day,month,year,week,weekday,second,minute,hour24,hour12;
        day     = date_get_day(datetime);
        month   = date_get_month(datetime);
        year    = date_get_year(datetime);
        week    = date_get_week(datetime);
        weekday = date_get_weekday(datetime);
        second  = date_get_second(datetime);
        minute  = date_get_minute(datetime);
        hour24  = date_get_hour(datetime);
        hour12  = ((hour24 + 23) mod 12) + 1;
        for (var i = 1; i <= string_length(format); i += 1) {
            var c = string_char_at(format,i);
            switch (c) {
            case "F":
                switch (month) {
                case 1:  out += "January";   break;
                case 2:  out += "February";  break;
                case 3:  out += "March";     break;
                case 4:  out += "April";     break;
                case 5:  out += "May";       break;
                case 6:  out += "June";      break;
                case 7:  out += "July";      break;
                case 8:  out += "August";    break;
                case 9:  out += "September"; break;
                case 10: out += "October";   break;
                case 11: out += "November";  break;
                case 12: out += "December";  break;
                }
                break;
            case "M":
                switch (month) {
                case 1:  out += "Jan"; break;
                case 2:  out += "Feb"; break;
                case 3:  out += "Mar"; break;
                case 4:  out += "Apr"; break;
                case 5:  out += "May"; break;
                case 6:  out += "Jun"; break;
                case 7:  out += "Jul"; break;
                case 8:  out += "Aug"; break;
                case 9:  out += "Sep"; break;
                case 10: out += "Oct"; break;
                case 11: out += "Nov"; break;
                case 12: out += "Dec"; break;
                }
                break;
            case "l":
                switch (weekday) {
                case 0: out += "Sunday";    break;
                case 1: out += "Monday";    break;
                case 2: out += "Tuesday";   break;
                case 3: out += "Wednesday"; break;
                case 4: out += "Thursday";  break;
                case 5: out += "Friday";    break;
                case 6: out += "Saturday";  break;
                }
                break;
            case "D":
                switch (weekday) {
                case 0: out += "Sun"; break;
                case 1: out += "Mon"; break;
                case 2: out += "Tue"; break;
                case 3: out += "Wed"; break;
                case 4: out += "Thu"; break;
                case 5: out += "Fri"; break;
                case 6: out += "Sat"; break;
                }
                break;
            case "S":
                if (day >= 10 && day <= 20) out += "th";
                else if ((day mod 10) == 1) out += "st";
                else if ((day mod 10) == 2) out += "nd";
                else if ((day mod 10) == 3) out += "rd";
                else                        out += "th";
                break;
            case "o":
                if (month ==  1 && day <=  3 && week != 1) { out += string(year - 1); break; }
                if (month == 12 && day >= 29 && week == 1) { out += string(year + 1); break; }
            case "Y": out += string(year); break;
            case "y": out += string_copy(string(year),3,2); break;
            case "m": if (month < 10) out += "0";
            case "n": out += string(month); break;
            case "d": if (day < 10) out += "0";
            case "j": out += string(day); break;
            case "H": if (hour24 < 10) out += "0";
            case "G": out += string(hour24); break;
            case "h": if (hour12 < 10) out += "0";
            case "g": out += string(hour12); break;
            case "i": if (minute < 10) out += "0"; out += string(minute); break;
            case "s": if (second < 10) out += "0"; out += string(second); break;
            case "a": if (hour24 < 12) out += "am" else out += "pm"; break;
            case "A": if (hour24 < 12) out += "AM" else out += "PM"; break;
            case "U": out += string(floor(date_second_span(datetime, 25569))); break;
            case "z": out += string(date_get_day_of_year(datetime) - 1); break;
            case "t": out += string(date_days_in_month(datetime)); break;
            case "L": out += string(date_leap_year(datetime)); break;
            case "w": out += string(weekday); break;
            case "N": out += string(((weekday + 6) mod 7) + 1); break;
            case "W": out += string(week); break;
            case "c": out += date_format("o-m-dTH:i:s", datetime); break;
            case "r": out += date_format("D, d M Y H:i:s +0000", datetime); break;
            case "\\": i += 1; c = string_char_at(format, i);
            default:  out += c; break;
            }
        }
        return out;
    }



function set_variable(name,value) {
	if name="?" or is_undefined(name) or is_undefined(value) {
		if name!="?" {
		if is_undefined(name) log("Variable name not defined","error")
		if is_undefined(value) log("Value not defined","error")}
		log("    Usage: set_variable <name> <value>")
		log("        name: name of the variable.")
		log("        value: value to set memory.")
		exit}
	global.variables[? name]=value
	log(name+"="+value)
}
	
function delete_variable(name) {
	if name="?" or is_undefined(name) {
		if name!="?" {log("Variable name not defined","error")}
		log("    Usage: delete_variable <name> <value>")
		log("        name: name of the variable to delete.")
		exit}
	ds_map_delete(global.variables, name)
	log(name+" variable deleted")
}

function list_variable() {
	log("Listing all ("+string(ds_map_size(global.variables))+") user-defined variables")
	var s=ds_map_size(global.variables)
	var n=ds_map_find_first(global.variables)
	var v=global.variables[? n]
	for (var i=0;i<s;i++) {
		log("    "+n+"="+string(v))
		n=ds_map_find_next(global.variables,n)
		v=global.variables[? n]
	}
}

function file_list_files(mask, attribute=0) {
	var files = [];
	var file_name = file_find_first(mask, attribute);

	while (file_name != "")
	{
	    array_push(files, file_name);
	    file_name = file_find_next();
	}

	file_find_close(); 
	return files
}


function cpu_request(priority=cpu_thread.low, cost=1)
{
	/*
		For codes that does not require immediate execution, you can use this function to delay it.
		It will add a queue to thread list, you can check for queue using cpu_queue, it will return true once thread is available.
		You can define "Priority" and "Cost" of the request, High priority thread will be executed first, if cpu thread is full, other priority will be ignored and delayed.
		Medium priority will only take 75% of maximum thread, any remained thread is used for low priority.
		"Cost" will takes up more thread, set to higher number if intended codes is performance costing.
		You can define maximum thread available in main object, or set it to change dynamically depend on framerate/performance.
		
		Use for function such as rendering, AI path finding, strategic, ray casting...
	*/
	switch(priority)
	{
		case cpu_thread.high:
			var thread = main.cpu_thread_high;
			main.cpu_thread_high += cost;
			break
			
		case cpu_thread.medium:
			var thread = main.cpu_thread_medium;
			main.cpu_thread_medium += cost;
			break
			
		default:
		case cpu_thread.low:
			var thread = main.cpu_thread_low;
			main.cpu_thread_low += cost;
			break
	}
	return	{priority: cpu_thread.low,	queue: thread}
}

function cpu_queue(thread)
{
	switch(thread.priority)
	{
		case cpu_thread.high:
			if main.cpu_step_high>=thread.queue {
				thread.queue = infinity;
				return true}
			break;
			
		case cpu_thread.medium:
			if main.cpu_step_medium>=thread.queue {
				thread.queue = infinity;
				return true}
			break;
			
		case cpu_thread.low:
			if main.cpu_step_low>=thread.queue {
				thread.queue = infinity;
				return true}
			break;
	}
	return false;
}

function debug_data_type(data) {
	if is_struct(data) {log("Data is struct: "+string(data));return true}
	if is_string(data) {log("Data is string: "+string(data));return true}
	if is_real(data) {log("Data is real: "+string(data));return true}
	if is_array(data) {log("Data is array: "+string(data));return true}
	if is_undefined(data) {log("Data is undefined: "+string(data));return true}
	if is_bool(data) {log("Data is bool: "+string(data));return true}
	if is_infinity(data) {log("Data is infinity: "+string(data));return true}
	if is_method(data) {log("Data is method: "+string(data));return true}
	if is_ptr(data) {log("Data is ptr: "+string(data));return true}
	if is_nan(data) {log("Data is NaN: "+string(data));return true}
	if is_numeric(data) {log("Data is numeric: "+string(data));return true}
	if is_int32(data) {log("Data is int32: "+string(data));return true}
	if is_int64(data) {log("Data is int64: "+string(data));return true}
	if is_vec3(data) {log("Data is vec3: "+string(data));return true}
	if is_vec4(data) {log("Data is vec4: "+string(data));return true }
}


function buffer_create_from_surface(surface)
{
	// Return new buffer containing information of specified surface.
	//	Buffer is fixed with alignment of 1.
	var w = surface_get_width(surface);
	var h = surface_get_height(surface);
	var buff = buffer_create(4*(w*h) , buffer_fixed, 1);
	buffer_get_surface(buff, surface, 0);
	return buff
}
function surface_buffer_getpixel(buff, w, h, x, y, channel)
{
	// Read color information of a specific pixel on a surface buffer.
	var pos = 4 * (y * w + x) + channel;
	buffer_seek(buff,buffer_seek_start, pos);
	//return buffer_read(buff, buffer_u8);
	return buffer_peek(buff, pos, buffer_u8);
}

///@func buffer_writes(buffer, type, values...)
function buffer_writes(buffer, type, value) {for (var i = 2; i < argument_count; i ++) buffer_write(buffer, type, argument[i])}