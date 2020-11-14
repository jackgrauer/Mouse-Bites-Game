/// @description
if(!instance_exists(obj_player_base)) exit;

image_blend = obj_player_base.movement_percent > obj_player_base.analog_deadzone ? c_yellow : c_gray;

draw_self();
var _axis_h = gamepad_axis_value(0,gp_axislh);
var _axis_v = gamepad_axis_value(0,gp_axislv);
var _max_dist = 76;

var _x = lerp(0,_max_dist,_axis_h);
var _y = lerp(0,_max_dist,_axis_v);
draw_sprite(spr_thumb,0,x+_x,y+_y);