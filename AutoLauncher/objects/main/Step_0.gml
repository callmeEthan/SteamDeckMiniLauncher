entry_pos();
if state!=0 {exit}
highlight += 0.05;

if input_check(input_right) || input_check(input_left) highlight = 0;
select += input_check(input_right) - input_check(input_left);
if select<0 {select = ds_list_size(entry)-1}
else if select>ds_list_size(entry)-1 select = 0;

if input_check(input_escape) {game_end()};

if input_check(input_enter) {
	state = 1;
	var temp = entry[| select]
	launch_game(temp)
	highlight = pi/2
	alarm[0]=1;
}
