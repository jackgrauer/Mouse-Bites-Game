/// @function	vngen_prompt_create(id, sprite_idle, sprite_active, sprite_auto, x, y, z, transition, duration, [ease]);
/// @param		{real|string}	id
/// @param		{sprite}		sprite_idle
/// @param		{sprite}		sprite_active
/// @param		{sprite}		sprite_auto
/// @param		{real}			x
/// @param		{real}			y
/// @param		{real}			z
/// @param		{script}		transition
/// @param		{real}			duration
/// @param		{integer|macro}	[ease]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_prompt_create() {

	/*
	Creates a new text prompt which will be displayed until vngen_prompt_destroy is run.
	Prompts act as visual indicators of the current text state, optionally displaying 
	different sprites for when the text typewriter effect is complete (waiting),
	incomplete (active), or auto mode is enabled (auto).

	If desired, X and Y can be determined automatically if set to -1. This will cause
	the prompt to appear inline at the end of the current text element(s).

	Multiple prompts can exist simultaneously, however be aware that no two prompts
	can share the same ID. The prompt ID is arbitrary and can be either a number or 
	a string. Note that the value -1 is reserved as 'null' and cannot be used 
	as a prompt ID.

	argument0 = identifier to use for the prompt (real or string)
	argument1 = the sprite to use as a waiting prompt (sprite) (required)
	argument2 = the sprite to use as an active prompt (sprite) (optional, use 'none' for none)
	argument3 = the sprite to use as an auto prompt (sprite) (optional, use 'none' for none)
	argument4 = the horizontal position to display the prompt (real) (use 'auto' for inline)
	argument5 = the vertical position to display the prompt (real) (use 'auto' for inline)
	argument6 = the drawing depth to display the prompt, relative to other prompts only (real)
	argument7 = sets the transition script to perform (script) (optional, use 'trans_none' for none)
	argument8 = sets the length of the transition, in seconds (real)
	argument9 = sets the transition easing override (see interp for available modes) (integer) (can also use true/false) (optional, use no argument for none)

	Example usage:
	   vngen_event() {
	      vngen_prompt_create("prompt", sprite_wait, sprite_active, sprite_auto, 1200, 800, 0, trans_fade, 3);
	      vngen_prompt_create("prompt", sprite_wait, sprite_active, sprite_auto, -1, -1, 0, trans_fade, 3, true);
	   }
	*/

	/*
	INITIALIZATION
	*/

	//Enable action, if active
	switch (sys_action_init()) {
	   //Exit if event is inactive
	   case false: {
	      exit;
	   }
      
	   //Initialize action if active
	   case true: {
	      //Get the current number of prompt entries
	      var ds_target = ds_grid_height(ds_prompt);
      
	      //Create new prompt slot in data structure
	      ds_grid_resize(ds_prompt, ds_grid_width(ds_prompt), ds_grid_height(ds_prompt) + 1);
      
	      //Set basic prompt properties
	      ds_prompt[# prop._id, ds_target] = argument[0];								//ID
	      ds_prompt[# prop._left, ds_target] = 0;										//Crop left
	      ds_prompt[# prop._top, ds_target] = 0;										//Crop top
	      ds_prompt[# prop._width, ds_target] = sprite_get_width(argument[1]);			//Crop width
	      ds_prompt[# prop._height, ds_target] = sprite_get_height(argument[1]);		//Crop height
	      ds_prompt[# prop._xorig, ds_target] = sprite_get_xoffset(argument[1]);		//Sprite X origin
	      ds_prompt[# prop._yorig, ds_target] = sprite_get_yoffset(argument[1]);		//Sprite Y origin
	      ds_prompt[# prop._x, ds_target] = argument[4];								//X
	      ds_prompt[# prop._y, ds_target] = argument[5];								//Y
	      ds_prompt[# prop._z, ds_target] = argument[6];								//Z
	      ds_prompt[# prop._xscale, ds_target] = 1;										//X scale
	      ds_prompt[# prop._yscale, ds_target] = 1;										//Y scale
	      ds_prompt[# prop._rot, ds_target] = 0;										//Rotation
	      ds_prompt[# prop._col1, ds_target] = c_white;									//Color1
	      ds_prompt[# prop._col2, ds_target] = c_white;									//Color2
	      ds_prompt[# prop._col3, ds_target] = c_white;									//Color3
	      ds_prompt[# prop._col4, ds_target] = c_white;									//Color4
	      ds_prompt[# prop._alpha, ds_target] = 1;										//Alpha
	      ds_prompt[# prop._img_index, ds_target] = 0;                                  //Image index
	      ds_prompt[# prop._img_num, ds_target] = sprite_get_number(argument[1]);       //Image total
	      ds_prompt[# prop._trigger, ds_target] = any;								    //Trigger
	      ds_prompt[# prop._sprite2, ds_target] = argument[1];							//Waiting sprite
	      ds_prompt[# prop._sprite3, ds_target] = argument[2];							//Active sprite
	      ds_prompt[# prop._sprite, ds_target] = argument[3];							//Auto sprite
	      ds_prompt[# prop._index, ds_target] = 2;										//Prompt state
      
	      //Set special prompt properties
	      ds_prompt[# prop._fade_src, ds_target] = -1;       //Fade sprite   
	      ds_prompt[# prop._fade_alpha, ds_target] = 1;      //Fade alpha
	      ds_prompt[# prop._trans, ds_target] = -1;          //Transition
	      ds_prompt[# prop._shader, ds_target] = -1;         //Shader
	      ds_prompt[# prop._sh_float_data, ds_target] = -1;  //Shader float data
	      ds_prompt[# prop._sh_mat_data, ds_target] = -1;    //Shader matrix data
	      ds_prompt[# prop._sh_samp_data, ds_target] = -1;   //Shader sampler data
	      ds_prompt[# prop._anim, ds_target] = -1;           //Animation
	      ds_prompt[# prop._anim_xscale, ds_target] = 1;     //Animation X scale
	      ds_prompt[# prop._anim_yscale, ds_target] = 1;     //Animation Y scale
	      ds_prompt[# prop._anim_alpha, ds_target] = 1;      //Animation alpha
	      ds_prompt[# prop._def, ds_target] = -1;            //Deformation
	      ds_prompt[# prop._def_point_data, ds_target] = -1; //Deform point data
	      ds_prompt[# prop._def_surf, ds_target] = -1;       //Deform surface
	      ds_prompt[# prop._def_fade_surf, ds_target] = -1;  //Deform fade surface
   
	      //Initialize scaling   
	      sys_scale_init(ds_prompt, ds_target, global.dp_width, global.dp_height, global.dp_width_init, global.dp_height_init, scale_none);
      
	      //Initialize transitions
	      sys_trans_init(ds_prompt, ds_target, argument[7], argument[8], false);
      
	      //Sort data structure by Z depth
	      ds_grid_sort(ds_prompt, prop._z, false);  
	  
		  //Get calculated properties
		  ds_prompt[# prop._final_xscale, ds_target] = ds_prompt[# prop._xscale, ds_target]*ds_prompt[# prop._oxscale, ds_target];
		  ds_prompt[# prop._final_yscale, ds_target] = ds_prompt[# prop._yscale, ds_target]*ds_prompt[# prop._oyscale, ds_target];
		  ds_prompt[# prop._final_width, ds_target] = ds_prompt[# prop._width, ds_target];
		  ds_prompt[# prop._final_height, ds_target] = ds_prompt[# prop._height, ds_target];
		  ds_prompt[# prop._final_x, ds_target] = ds_prompt[# prop._x, ds_target] - (ds_prompt[# prop._xorig, ds_target]*ds_prompt[# prop._final_xscale, ds_target]);
		  ds_prompt[# prop._final_y, ds_target] = ds_prompt[# prop._y, ds_target] - (ds_prompt[# prop._yorig, ds_target]*ds_prompt[# prop._final_yscale, ds_target]);
	   }
	}


	/*
	DATA MANAGEMENT
	*/

	//Skip action if engine is paused
	if (global.vg_pause == true) {
	   exit;
	}

	//Get prompt slot
	var ds_target = vngen_get_index(argument[0], vngen_type_prompt);

	//Skip action if target prompt does not exist
	if (is_undefined(ds_target)) {
	   exit;
	}


	/*
	PERFORM TRANSITIONS
	*/

	//Get ease mode
	if (argument_count > 9) {
	   var action_ease = argument[9];
	} else {
	   var action_ease = false;
	}

	//Perform transitions
	if (ds_prompt[# prop._trans_time, ds_target] < ds_prompt[# prop._trans_dur, ds_target]) {
	   sys_trans_perform(ds_prompt, ds_target, action_ease);
   
	   //End action when transitions are complete
	   if (ds_prompt[# prop._trans_time, ds_target] >= ds_prompt[# prop._trans_dur, ds_target]) {
	      sys_action_term();
	   }
	}



}
