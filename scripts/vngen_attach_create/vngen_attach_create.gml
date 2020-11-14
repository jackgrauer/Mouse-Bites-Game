/// @function	vngen_attach_create(name, id, sprite, x, y, z, transition, duration, [ease]);
/// @param		{string}		name
/// @param		{real|string}	id
/// @param		{sprite}		sprite
/// @param		{real}			x
/// @param		{real}			y
/// @param		{real}			z
/// @param		{script}		transition
/// @param		{real}			duration
/// @param		{integer|macro}	[ease]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_attach_create() {

	/*
	Creates an attachment for the specified character which will be displayed until 
	vngen_attach destroy or vngen_char_destroy is run. Character attachments are
	purely aesthetic and will inherit certain properties from the character itself,
	such as animations and deformations.

	Multiple attachments can exist simultaneously, however be aware that no two 
	attachments can share the same ID **within the same character**. The attachment 
	ID is arbitrary and can be either a number or a string. Note that the value -1 
	is reserved as 'null' and cannot be used as an attachment ID.

	argument0 = identifier of the character to be modified (string)
	argument1 = identifier to use for the attachment (real or string)
	argument2 = the sprite to use as a new attachment (sprite)
	argument3 = the horizontal position to display the attachment **relative to the body top-left corner** (real)
	argument4 = the vertical position to display the attachment **relative to the body top-left corner** (real)
	argument5 = the drawing depth to display the attachment, relative to the character body and shared attachments only (real)
	argument6 = sets the transition script to perform (script) (optional, use 'trans_none' for none)
	argument7 = sets the length of the transition, in seconds (real)
	argument8 = sets the transition easing override (see interp for available modes) (integer) (can also use true/false) (optional, use no argument for none)

	Example usage:
	   vngen_event() {
	      vngen_attach_create("John Doe", "attach", spr_attach, 50, 150, -1, trans_fade, 0.5);
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
	      //Get character target
	      var ds_char_target = vngen_get_index(argument[0], vngen_type_char);
      
	      //If the target character exists...
	      if (!is_undefined(ds_char_target)) {        
	         //Get attachment data from target character
	         var ds_attach = ds_character[# prop._attach_data, ds_char_target];
            
	         //Get the parent sprite dimensions
	         var parent_width = sprite_get_width(ds_character[# prop._sprite, ds_char_target]);
	         var parent_height = sprite_get_height(ds_character[# prop._sprite, ds_char_target]);
      
	         //Get the current number of attachment entries
	         ds_attach_target = ds_grid_height(ds_attach);
   
	         //Create new attachment slot in data structure
	         ds_grid_resize(ds_attach, ds_grid_width(ds_attach), ds_grid_height(ds_attach) + 1);
   
	         //Set basic attachment properties
	         ds_attach[# prop._id, ds_attach_target] = argument[1];								  //ID
	         ds_attach[# prop._sprite, ds_attach_target] = argument[2];							  //Sprite
	         ds_attach[# prop._left, ds_attach_target] = 0;										  //Crop left
	         ds_attach[# prop._top, ds_attach_target] = 0;										  //Crop top
	         ds_attach[# prop._width, ds_attach_target] = sprite_get_width(argument[2]);		  //Crop width
	         ds_attach[# prop._height, ds_attach_target] = sprite_get_height(argument[2]);		  //Crop height
	         ds_attach[# prop._xorig, ds_attach_target] = sprite_get_xoffset(argument[2]);		  //Sprite X origin
	         ds_attach[# prop._yorig, ds_attach_target] = sprite_get_yoffset(argument[2]);		  //Sprite Y origin
	         ds_attach[# prop._x, ds_attach_target] = argument[3];								  //X
	         ds_attach[# prop._y, ds_attach_target] = argument[4];								  //Y
	         ds_attach[# prop._z, ds_attach_target] = argument[5];								  //Z
	         ds_attach[# prop._xscale, ds_attach_target] = 1;									  //X scale
	         ds_attach[# prop._yscale, ds_attach_target] = 1;									  //Y scale
	         ds_attach[# prop._rot, ds_attach_target] = 0;										  //Rotation
	         ds_attach[# prop._col1, ds_attach_target] = c_white;								  //Color1
	         ds_attach[# prop._col2, ds_attach_target] = c_white;								  //Color2
	         ds_attach[# prop._col3, ds_attach_target] = c_white;								  //Color3
	         ds_attach[# prop._col4, ds_attach_target] = c_white;								  //Color4
	         ds_attach[# prop._alpha, ds_attach_target] = 1;									  //Alpha
		     ds_attach[# prop._img_index, ds_attach_target] = 0;								  //Image index
		     ds_attach[# prop._img_num, ds_attach_target] = sprite_get_number(argument[2]);	      //Image total
   
	         //Set special attachment properties
	         ds_attach[# prop._fade_src, ds_attach_target] = -1;       //Fade sprite   
	         ds_attach[# prop._fade_alpha, ds_attach_target] = 1;      //Fade alpha
	         ds_attach[# prop._trans, ds_attach_target] = -1;          //Transition
	         ds_attach[# prop._shader, ds_attach_target] = -1;         //Shader
	         ds_attach[# prop._sh_float_data, ds_attach_target] = -1;  //Shader float data
	         ds_attach[# prop._sh_mat_data, ds_attach_target] = -1;    //Shader matrix data
	         ds_attach[# prop._sh_samp_data, ds_attach_target] = -1;   //Shader sampler data
	         ds_attach[# prop._anim, ds_attach_target] = -1;           //Animation
	         ds_attach[# prop._anim_xscale, ds_attach_target] = 1;     //Animation X scale
	         ds_attach[# prop._anim_yscale, ds_attach_target] = 1;     //Animation Y scale
	         ds_attach[# prop._anim_alpha, ds_attach_target] = 1;      //Animation alpha
	         ds_attach[# prop._def, ds_attach_target] = -1;            //Deformation
	         ds_attach[# prop._def_point_data, ds_attach_target] = -1; //Deform point data
	         ds_attach[# prop._def_surf, ds_attach_target] = -1;       //Deform surface
	         ds_attach[# prop._def_fade_surf, ds_attach_target] = -1;  //Deform fade surface
      
	         //Initialize scaling
	         sys_scale_init(ds_attach, ds_attach_target, parent_width, parent_height, parent_width, parent_height, scale_none);
   
	         //Initialize transitions
	         sys_trans_init(ds_attach, ds_attach_target, argument[6], argument[7], false);
   
	         //Sort data structure by Z depth
	         ds_grid_sort(ds_attach, prop._z, false);
	  
		     //Get calculated properties
		     ds_attach[# prop._final_xscale, ds_attach_target] = ds_attach[# prop._xscale, ds_attach_target]*ds_attach[# prop._oxscale, ds_attach_target];
		     ds_attach[# prop._final_yscale, ds_attach_target] = ds_attach[# prop._yscale, ds_attach_target]*ds_attach[# prop._oyscale, ds_attach_target];
		     ds_attach[# prop._final_width, ds_attach_target] = ds_attach[# prop._width, ds_attach_target];
		     ds_attach[# prop._final_height, ds_attach_target] = ds_attach[# prop._height, ds_attach_target];
		     ds_attach[# prop._final_x, ds_attach_target] = ds_attach[# prop._x, ds_attach_target] - (ds_attach[# prop._xorig, ds_attach_target]*ds_attach[# prop._final_xscale, ds_attach_target]);
		     ds_attach[# prop._final_y, ds_attach_target] = ds_attach[# prop._y, ds_attach_target] - (ds_attach[# prop._yorig, ds_attach_target]*ds_attach[# prop._final_yscale, ds_attach_target]);
	      } else {
	         //Skip action if target character does not exist
	         sys_action_term();
	         exit;
	      }
	   }
	}


	/*
	DATA MANAGEMENT
	*/

	//Skip action if engine is paused
	if (global.vg_pause == true) {
	   exit;
	}

	//Get character slot to modify
	var ds_char_target = vngen_get_index(argument[0], vngen_type_char);

	//Skip action if target character does not exist
	if (is_undefined(ds_char_target)) {
	   exit;
	}

	//Get attachment data from target character
	var ds_attach = ds_character[# prop._attach_data, ds_char_target];

	//Get attachment slot
	var ds_attach_target = vngen_get_index(argument[1], vngen_type_attach, argument[0]);

	//Skip action if target attachment does not exist
	if (is_undefined(ds_attach_target)) {
	   exit;
	}


	/*
	PERFORM TRANSITIONS
	*/

	//Get ease mode
	if (argument_count > 8) {
	   var action_ease = argument[8];
	} else {
	   var action_ease = false;
	}

	//Perform transitions
	if (ds_attach[# prop._trans_time, ds_attach_target] < ds_attach[# prop._trans_dur, ds_attach_target]) {
	   sys_trans_perform(ds_attach, ds_attach_target, action_ease);
   
	   //End action when transitions are complete
	   if (ds_attach[# prop._trans_time, ds_attach_target] >= ds_attach[# prop._trans_dur, ds_attach_target]) {
	      sys_action_term();
	   }
	}


}
