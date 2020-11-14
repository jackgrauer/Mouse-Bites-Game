/// @function	vngen_log_button_create(id, text, sprite, spr_hover, spr_select, x, y, z, font, color, [ease]);
/// @param		{real|string}	id
/// @param		{string}		text
/// @param		{sprite}		sprite
/// @param		{sprite}		spr_hover
/// @param		{sprite}		spr_select
/// @param		{real}			x
/// @param		{real}			y
/// @param		{real}			z
/// @param		{font}			font
/// @param		{color}			color
/// @param		{integer|macro}	[ease]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_log_button_create() {

	/*
	Creates a new button which will be displayed in the backlog until 
	vngen_log_button_destroy is run. While log buttons are intended
	for navigation, any arbitrary code can be executed in response to 
	mouse or touch input with vngen_log_get_button. Other input devices 
	can activate log buttons directly with vngen_do_log_button_nav and 
	vngen_do_log_button_select.

	Multiple buttons can exist simultaneously, however be aware that no 
	two buttons can share the same ID. The button ID, or name, is arbitrary 
	and can be either a number or a string. Note that the value -1 is 
	reserved as 'null' and cannot be used as a log button ID.

	Note that unlike regular buttons, log buttons are not created inside
	a VNgen event loop and should instead be created in the Create event.

	argument0  = identifier to use for the button (real or string)
	argument1  = the button text to be displayed (string)
	argument2  = the sprite to use as a button background (sprite) (required)
	argument3  = the sprite to use as a hovered button background (sprite) (optional, use 'none' for none)
	argument4  = the sprite to use as a selected button background (sprite) (optional, use 'none' for none)
	argument5  = the horizontal position to display the button (real)
	argument6  = the vertical position to display the button (real)
	argument7  = the drawing depth to display the button, relative to other buttons only (real)
	argument8  = sets the button text font family to be drawn (font)
	argument9  = sets the default button text color (color)
	argument10 = sets the transition easing override (see interp for available modes) (integer) (can also use true/false) (optional, use no argument for none)

	Example usage:
	   vngen_log_button_create("btn", "Click me!", spr_btn, spr_btn_hover, spr_btn_select, 256, 512, 0, fnt_Arial, c_white);
	*/

	/*
	INITIALIZATION
	*/

	//Get ease mode
	if (argument_count > 10) {
	   var action_ease = argument[10];
	} else {
	   var action_ease = false;
	}

	//Get the current number of button entries
	var ds_target = ds_grid_height(global.ds_log_button);

	//Create new button slot in data structure
	ds_grid_resize(global.ds_log_button, ds_grid_width(global.ds_log_button), ds_grid_height(global.ds_log_button) + 1);
	button_count = ds_target + 1;

	//Get text position
	draw_set_font(argument[8]);
	var text_xorig = (sprite_get_width(argument[2])*0.5) - (string_width(argument[1])*0.5);
	var text_yorig = (sprite_get_height(argument[2])*0.5) - (string_height(argument[1])*0.5);
	draw_set_font(fnt_default);

	//Set basic button properties
	global.ds_log_button[# prop._id, ds_target] = argument[0];								 //ID
	global.ds_log_button[# prop._sprite, ds_target] = argument[2];							 //Sprite
	global.ds_log_button[# prop._left, ds_target] = 0;										 //Crop left
	global.ds_log_button[# prop._top, ds_target] = 0;										 //Crop top
	global.ds_log_button[# prop._width, ds_target] = sprite_get_width(argument[2]);			 //Crop width
	global.ds_log_button[# prop._height, ds_target] = sprite_get_height(argument[2]);		 //Crop height
	global.ds_log_button[# prop._xorig, ds_target] = sprite_get_xoffset(argument[2]);		 //Sprite X origin
	global.ds_log_button[# prop._yorig, ds_target] = sprite_get_yoffset(argument[2]);		 //Sprite Y origin
	global.ds_log_button[# prop._x, ds_target] = argument[5];								 //X
	global.ds_log_button[# prop._y, ds_target] = argument[6];								 //Y
	global.ds_log_button[# prop._z, ds_target] = argument[7];								 //Z
	global.ds_log_button[# prop._txt_x, ds_target] = text_xorig;							 //Text x
	global.ds_log_button[# prop._txt_y, ds_target] = text_yorig;							 //Text y
	global.ds_log_button[# prop._col1, ds_target] = argument[9];							 //Text color
	global.ds_log_button[# prop._xscale, ds_target] = 1;									 //X scale
	global.ds_log_button[# prop._yscale, ds_target] = 1;									 //Y scale
	global.ds_log_button[# prop._rot, ds_target] = 0;										 //Rotation
	global.ds_log_button[# prop._alpha, ds_target] = 1;										 //Alpha
	global.ds_log_button[# prop._img_index, ds_target] = 0;                                  //Image index
	global.ds_log_button[# prop._img_num, ds_target] = sprite_get_number(argument[2]);       //Image total
	global.ds_log_button[# prop._sprite2, ds_target] = argument[3];							 //Hover sprite
	global.ds_log_button[# prop._sprite3, ds_target] = argument[4];							 //Select sprite 
	global.ds_log_button[# prop._surf, ds_target] = -1;										 //Text surface
	global.ds_log_button[# prop._txt_fnt, ds_target] = argument[8];							 //Text font
	global.ds_log_button[# prop._txt_line_height, ds_target] = global.vg_lineheight_text;	 //Text lineheight
	global.ds_log_button[# prop._txt, ds_target] = argument[1];								 //Text string 
	global.ds_log_button[# prop._trigger, ds_target] = -1;									 //Trigger state
	global.ds_log_button[# prop._snd_hover, ds_target] = -1;								 //Hover sound
	global.ds_log_button[# prop._snd_select, ds_target] = -1;								 //Select sound

	//Set special button properties
	global.ds_log_button[# prop._fade_src, ds_target] = -1;       //Fade sprite   
	global.ds_log_button[# prop._fade_alpha, ds_target] = 1;      //Fade alpha
	global.ds_log_button[# prop._trans, ds_target] = -1;          //Transition
	global.ds_log_button[# prop._shader, ds_target] = -1;         //Shader
	global.ds_log_button[# prop._sh_float_data, ds_target] = -1;  //Shader float data
	global.ds_log_button[# prop._sh_mat_data, ds_target] = -1;    //Shader matrix data
	global.ds_log_button[# prop._sh_samp_data, ds_target] = -1;   //Shader sampler data
	global.ds_log_button[# prop._anim, ds_target] = -1;           //Animation
	global.ds_log_button[# prop._anim_xscale, ds_target] = 1;     //Animation X scale
	global.ds_log_button[# prop._anim_yscale, ds_target] = 1;     //Animation Y scale
	global.ds_log_button[# prop._anim_alpha, ds_target] = 1;      //Animation alpha
	global.ds_log_button[# prop._def, ds_target] = -1;            //Deformation
	global.ds_log_button[# prop._def_point_data, ds_target] = -1; //Deform point data
	global.ds_log_button[# prop._def_surf, ds_target] = -1;       //Deform surface
	global.ds_log_button[# prop._def_fade_surf, ds_target] = -1;  //Deform fade surface

	//Set default properties
	global.ds_log_button[# prop._init_x, ds_target] = argument[5];                   //Initial X
	global.ds_log_button[# prop._init_y, ds_target] = argument[6];                   //Initial Y
	global.ds_log_button[# prop._init_xscale, ds_target] = 1;                        //Initial X scale
	global.ds_log_button[# prop._init_yscale, ds_target] = 1;                        //Initial Y scale
	global.ds_log_button[# prop._init_width, ds_target] = display_get_gui_width();   //Initial GUI width
	global.ds_log_button[# prop._init_height, ds_target] = display_get_gui_height(); //Initial GUI height

	//Set hover properties
	global.ds_log_button[# prop._anim_tmp_col1, ds_target] = argument[9]; //Hover text color
	global.ds_log_button[# prop._anim_tmp_x, ds_target] = argument[5];    //Hover X
	global.ds_log_button[# prop._anim_tmp_y, ds_target] = argument[6];    //Hover Y
	global.ds_log_button[# prop._anim_tmp_xscale, ds_target] = 1;         //Hover X scale
	global.ds_log_button[# prop._anim_tmp_yscale, ds_target] = 1;         //Hover Y scale

	//Set select properties
	global.ds_log_button[# prop._anim_col1, ds_target] = argument[9];     //Select text color
	global.ds_log_button[# prop._anim_x, ds_target] = argument[5];        //Select X
	global.ds_log_button[# prop._anim_y, ds_target] = argument[6];        //Select Y
	global.ds_log_button[# prop._anim_xscale, ds_target] = 1;             //Select X scale
	global.ds_log_button[# prop._anim_yscale, ds_target] = 1;             //Select Y scale

	//Get animation duration from select sprite, if any
	var action_dur = time_target;
	if (sprite_exists(argument[4])) {
	   action_dur *= sprite_get_number(argument[4]);
	}

	//Set timing properties
	global.ds_log_button[# prop._anim_time, ds_target] = 0;               //Animation time
	global.ds_log_button[# prop._anim_dur, ds_target] = action_dur;       //Animation duration
	global.ds_log_button[# prop._anim_ease, ds_target] = action_ease;     //Animation ease

	//Initialize scaling
	sys_scale_init(global.ds_log_button, ds_target, global.dp_width, global.dp_height, global.dp_width_init, global.dp_height_init, scale_none);
      
	//Initialize transitions
	sys_trans_init(global.ds_log_button, ds_target, trans_none, 0, false);

	//Sort data structure by Z depth
	ds_grid_sort(global.ds_log_button, prop._z, false);  



}
