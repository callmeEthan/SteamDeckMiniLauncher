/// @description INPUT CHECK
global.input[input_up]= keyboard_check_pressed(vk_up)
global.input[input_down]= keyboard_check_pressed(vk_down)
global.input[input_left]= keyboard_check_pressed(vk_left)
global.input[input_right]= keyboard_check_pressed(vk_right)
global.input[input_enter]= keyboard_check_pressed(vk_enter)
global.input[input_escape]= keyboard_check_pressed(vk_escape)
global.input[input_shift]= keyboard_check_pressed(vk_shift)

var _maxpads = gamepad_get_device_count();
for (var i = 0; i < _maxpads; i++)
{
    if (gamepad_is_connected(i))
    {
		if gamepad_button_check_pressed(i, gp_padu) global.input[input_up] = 1
		if gamepad_button_check_pressed(i, gp_padd) global.input[input_down] = 1
		if gamepad_button_check_pressed(i, gp_padl) global.input[input_left] = 1
		if gamepad_button_check_pressed(i, gp_padr) global.input[input_right] = 1
		if gamepad_button_check_pressed(i, gp_face1) global.input[input_enter] = 1
		if gamepad_button_check_pressed(i, gp_face2) global.input[input_escape] = 1
    }
} 