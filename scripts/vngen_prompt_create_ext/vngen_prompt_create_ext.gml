/// @function	vngen_prompt_create_ext(id, trigger, sprite_idle, sprite_active, sprite_auto, xorig, yorig, x, y, z, scaling, transition, duration, ease);
/// @param		{real|string}	id
/// @param		{string|macro}	trigger
/// @param		{sprite}		sprite_idle
/// @param		{sprite}		sprite_active
/// @param		{sprite}		sprite_auto
/// @param		{real|macro}	xorig
/// @param		{real|macro}	yorig
/// @param		{real}			x
/// @param		{real}			y
/// @param		{real}			z
/// @param		{integer|macro}	scaling
/// @param		{script}		transition
/// @param		{real}			duration
/// @param		{integer|macro}	ease
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_prompt_create_ext(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7, argument8, argument9, argument10, argument11, argument12, argument13) {

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

	The secondary ID value, or name, refers to character names and can be used to give
	different speakers different prompts. This is optional and can be ignored by supplying
	-3 in place of a character name.

	argument0  = identifier to use for the prompt (real or string)
	argument1  = speaker name to use as trigger for drawing the prompt (string) (optional, use 'any' for all characters)
	argument2  = the sprite to use as a waiting prompt (sprite) (required)
	argument3  = the sprite to use as an active prompt (sprite) (optional, use 'none' for none)
	argument4  = the sprite to use as an auto prompt (sprite) (optional, use 'none' for none)
	argument5  = the sprite horizontal offset, or center point (real)
	argument6  = the sprite vertical offset, or center point (real)
	argument7  = the horizontal position to display the prompt (real) (use 'auto' for inline)
	argument8  = the vertical position to display the prompt (real) (use 'auto' for inline)
	argument9  = the drawing depth to display the prompt, relative to other prompts only (real)
	argument10 = sets the scaling mode to perform: scale_none, scale_x_y, scale_x, scale_y, 
	             scale_stretch_x_y, scale_stretch_x, scale_stretch_y, scale_prop_x_y, 
	             scale_prop_x, or scale_prop_y (integer or macro)
	argument11 = sets the transition script to perform (script) (optional, use 'trans_none' for none)
	argument12 = sets the length of the transition, in seconds (real)
	argument13 = sets the transition easing override (see interp for available modes) (integer) (can also use true/false)

	Example usage:
	   vngen_event() {
	      vngen_prompt_create_ext("prompt", "John Doe", sprite_wait, sprite_active, sprite_auto, 0, 0, 1200, 800, 0, 0, trans_fade, 1, true);
	      vngen_prompt_create_ext("prompt", -3, sprite_wait, sprite_active, sprite_auto, 0, 0, 1200, 800, 0, 0, trans_fade, 1, true);
	      vngen_prompt_create_ext("prompt", -3, sprite_wait, sprite_active, sprite_auto, 0, 0, -1, -1, 0, 0, trans_fade, 1, true);
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
	      ds_prompt[# prop._id, ds_target] = argument0;                         	  //ID
	      ds_prompt[# prop._left, ds_target] = 0;                               	  //Crop left
	      ds_prompt[# prop._top, ds_target] = 0;                                	  //Crop top
	      ds_prompt[# prop._width, ds_target] = sprite_get_width(argument2);    	  //Crop width
	      ds_prompt[# prop._height, ds_target] = sprite_get_height(argument2);  	  //Crop height
	      ds_prompt[# prop._x, ds_target] = argument7;                          	  //X
	      ds_prompt[# prop._y, ds_target] = argument8;                          	  //Y
	      ds_prompt[# prop._z, ds_target] = argument9;                          	  //Z
	      ds_prompt[# prop._xscale, ds_target] = 1;                             	  //X scale
	      ds_prompt[# prop._yscale, ds_target] = 1;                             	  //Y scale
	      ds_prompt[# prop._rot, ds_target] = 0;                                	  //Rotation
	      ds_prompt[# prop._col1, ds_target] = c_white;                         	  //Color1
	      ds_prompt[# prop._col2, ds_target] = c_white;                         	  //Color2
	      ds_prompt[# prop._col3, ds_target] = c_white;                         	  //Color3
	      ds_prompt[# prop._col4, ds_target] = c_white;                         	  //Color4
	      ds_prompt[# prop._alpha, ds_target] = 1;                              	  //Alpha
	      ds_prompt[# prop._img_index, ds_target] = 0;                                //Image index
	      ds_prompt[# prop._img_num, ds_target] = sprite_get_number(argument2);       //Image total
	      ds_prompt[# prop._trigger, ds_target] = argument1;						  //Trigger
	      ds_prompt[# prop._sprite2, ds_target] = argument2;				    	  //Waiting sprite
	      ds_prompt[# prop._sprite3, ds_target] = argument3;                    	  //Active sprite
	      ds_prompt[# prop._sprite, ds_target] = argument4;                     	  //Auto sprite
	      ds_prompt[# prop._index, ds_target] = 2;                              	  //Prompt state
      
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
      
	      //Set sprite origins
	      sys_orig_init(ds_prompt, ds_target, argument5, argument6);
      
	      //Initialize scaling
	      sys_scale_init(ds_prompt, ds_target, global.dp_width, global.dp_height, global.dp_width_init, global.dp_height_init, argument10);
      
	      //Initialize transitions
	      sys_trans_init(ds_prompt, ds_target, argument11, argument12, false);
      
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
	var ds_target = vngen_get_index(argument0, vngen_type_prompt);

	//Skip action if target prompt does not exist
	if (is_undefined(ds_target)) {
	   exit;
	}


	/*
	PERFORM TRANSITIONS
	*/

	//Perform transitions
	if (ds_prompt[# prop._trans_time, ds_target] < ds_prompt[# prop._trans_dur, ds_target]) {
	   sys_trans_perform(ds_prompt, ds_target, argument13);
   
	   //End action when transitions are complete
	   if (ds_prompt[# prop._trans_time, ds_target] >= ds_prompt[# prop._trans_dur, ds_target]) {
	      sys_action_term();
	   }
	}



}
