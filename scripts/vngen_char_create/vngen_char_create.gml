/// @function	vngen_char_create(name, spr_body, spr_face_idle, spr_face_talk, x, y, z, face_x, face_y, flip, transition, duration, [ease]);
/// @param		{string}		name
/// @param		{sprite}		spr_body
/// @param		{sprite}		spr_face_idle
/// @param		{sprite}		spr_face_talk
/// @param		{real}			x
/// @param		{real}			y
/// @param		{real}			z
/// @param		{real}			face_x
/// @param		{real}			face_y
/// @param		{boolean}		flip
/// @param		{script}		transition
/// @param		{real}			duration
/// @param		{integer|macro}	[ease]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_char_create() {

	/*
	Creates a new character which will be displayed until vngen_char_destroy is run.
	Characters are comprised of three basic sprites: a body, a default or 'listening'
	face, and a 'talking' face. For purely static characters, separate face sprites
	are not required.

	Note that unlike other entities, character IDs double as the name which they will
	be referred to as in text events. If highlighting is enabled, this name must match
	the speaker name set in vngen_text_create **exactly**.

	The value -1 is reserved as 'null' and cannot be used as a character ID.

	argument0  = identifier to use for the character (string) (string recommended)
	argument1  = the sprite to use as the character body (sprite) (required)
	argument2  = the sprite to use as the character's idle expression (sprite) (optional, use 'none' for none)
	argument3  = the sprite to use as the character's speaking expression (sprite) (optional, use 'none' for none)
	argument4  = the horizontal position to display the character (real)
	argument5  = the vertical position to display the character (real)
	argument6  = the drawing depth to display the character, relative to other characters only (real)
	argument7  = the horizontal offset to display the character face **relative to the body top-left corner** (real)
	argument8  = the vertical offset to display the character face **relative to the body top-left corner** (real)
	argument9  = enables or disables flipping the character for display on opposite sides of the screen (boolean) (true/false)
	argument10 = sets the transition script to perform (script) (optional, use 'trans_none' for none)
	argument11 = sets the length of the transition, in seconds (real)
	argument12 = sets the transition easing override (see interp for available modes) (integer) (can also use true/false) (optional, use no argument for none)

	Example usage:
	   vngen_event() {
	      vngen_char_create("John Doe", spr_body, spr_face, spr_talking, 0, view_hview[0] - 900, -1, 384, 128, false, trans_fade, 2);
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
	      //Get the current number of character entries
	      var ds_target = ds_grid_height(ds_character);
      
	      //Create new character slot in data structure
	      ds_grid_resize(ds_character, ds_grid_width(ds_character), ds_grid_height(ds_character) + 1);
      
	      //Set basic character properties
	      ds_character[# prop._id, ds_target] = argument[0];                                //Name
	      ds_character[# prop._sprite, ds_target] = argument[1];                            //Body sprite
	      ds_character[# prop._left, ds_target] = 0;                                        //Crop left
	      ds_character[# prop._top, ds_target] = 0;                                         //Crop top
	      ds_character[# prop._width, ds_target] = sprite_get_width(argument[1]);           //Crop width
	      ds_character[# prop._height, ds_target] = sprite_get_height(argument[1]);         //Crop height
	      ds_character[# prop._xorig, ds_target] = sprite_get_xoffset(argument[1]);         //Sprite X origin
	      ds_character[# prop._yorig, ds_target] = sprite_get_yoffset(argument[1]);         //Sprite Y origin
	      ds_character[# prop._x, ds_target] = argument[4];                                 //X
	      ds_character[# prop._y, ds_target] = argument[5];                                 //Y
	      ds_character[# prop._z, ds_target] = argument[6];                                 //Z
	      ds_character[# prop._xscale, ds_target] = 1;                                      //X scale
	      ds_character[# prop._yscale, ds_target] = 1;                                      //Y scale
	      ds_character[# prop._rot, ds_target] = 0;                                         //Rotation
	      ds_character[# prop._col1, ds_target] = c_white;                                  //Color1
	      ds_character[# prop._col2, ds_target] = c_white;                                  //Color2
	      ds_character[# prop._col3, ds_target] = c_white;                                  //Color3
	      ds_character[# prop._col4, ds_target] = c_white;                                  //Color4
	      ds_character[# prop._alpha, ds_target] = 1;                                       //Alpha
	      ds_character[# prop._img_index, ds_target] = 0;                                   //Image index
	      ds_character[# prop._img_num, ds_target] = sprite_get_number(argument[1]);        //Image total
	      ds_character[# prop._sprite2, ds_target] = argument[2];                           //Face idle sprite
	      ds_character[# prop._sprite3, ds_target] = argument[3];                           //Face talking sprite   
	      ds_character[# prop._face_x, ds_target] = argument[7];                            //Face x
	      ds_character[# prop._face_y, ds_target] = argument[8];                            //Face y
	      ds_character[# prop._pause, ds_target] = 3;                                       //Face idle pause duration
	      ds_character[# prop._face_time, ds_target] = 0;                                   //Face idle pause time
	      ds_character[# prop._attach_data, ds_target] = ds_grid_create(attach_length, 0);  //Attachments
	      ds_character[# prop._hlight, ds_target] = false;                                  //Highlight state
	  
		  //Set character face properties
		  if (sprite_exists(argument[2])) {
		      ds_character[# prop._index, ds_target] = 0;                                   //Face image index   
		      ds_character[# prop._number, ds_target] = sprite_get_number(argument[2]);     //Face image number 
		  }
	  
	      //Set special character properties
	      ds_character[# prop._fade_src, ds_target] = -1;       //Fade surface     
	      ds_character[# prop._fade_alpha, ds_target] = 1;      //Fade alpha
	      ds_character[# prop._trans, ds_target] = -1;          //Transition
	      ds_character[# prop._shader, ds_target] = -1;         //Shader
	      ds_character[# prop._sh_float_data, ds_target] = -1;  //Shader float data
	      ds_character[# prop._sh_mat_data, ds_target] = -1;    //Shader matrix data
	      ds_character[# prop._sh_samp_data, ds_target] = -1;   //Shader sampler data
	      ds_character[# prop._anim, ds_target] = -1;           //Animation
	      ds_character[# prop._anim_xscale, ds_target] = 1;     //Animation X scale
	      ds_character[# prop._anim_yscale, ds_target] = 1;     //Animation Y scale
	      ds_character[# prop._anim_alpha, ds_target] = 1;      //Animation alpha
	      ds_character[# prop._def, ds_target] = -1;            //Deformation
	      ds_character[# prop._def_point_data, ds_target] = -1; //Deform point data
	      ds_character[# prop._def_surf, ds_target] = -1;       //Deform surface
	      ds_character[# prop._def_fade_surf, ds_target] = -1;  //Deform fade surface 
	      ds_character[# prop._surf, ds_target] = surface_create(sprite_get_width(argument[1]), sprite_get_height(argument[1])); //Surface  
      
	      //Initialize scaling
	      sys_scale_init(ds_character, ds_target, global.dp_width, global.dp_height, global.dp_width_init, global.dp_height_init, scale_none);    
      
	      //Flip character, if enabled
	      if (argument[9] == true) {
	         ds_character[# prop._oxscale, ds_target] *= -1;
	      }
      
	      //Initialize transitions
	      sys_trans_init(ds_character, ds_target, argument[10], argument[11], false);
      
	      //Sort data structure by Z depth
	      ds_grid_sort(ds_character, prop._z, false);  
	  
		  //Get calculated properties
		  ds_character[# prop._final_xscale, ds_target] = ds_character[# prop._xscale, ds_target]*ds_character[# prop._oxscale, ds_target];
		  ds_character[# prop._final_yscale, ds_target] = ds_character[# prop._yscale, ds_target]*ds_character[# prop._oyscale, ds_target];
		  ds_character[# prop._final_width, ds_target] = ds_character[# prop._width, ds_target];
		  ds_character[# prop._final_height, ds_target] = ds_character[# prop._height, ds_target];
		  ds_character[# prop._final_x, ds_target] = ds_character[# prop._x, ds_target] - (ds_character[# prop._xorig, ds_target]*ds_character[# prop._final_xscale, ds_target]);
		  ds_character[# prop._final_y, ds_target] = ds_character[# prop._y, ds_target] - (ds_character[# prop._yorig, ds_target]*ds_character[# prop._final_yscale, ds_target]);
	   }
	}


	/*
	DATA MANAGEMENT
	*/

	//Skip action if engine is paused
	if (global.vg_pause == true) {
	   exit;
	}

	//Get character slot
	var ds_target = vngen_get_index(argument[0], vngen_type_char);

	//Skip action if target character does not exist
	if (is_undefined(ds_target)) {
	   exit;
	}


	/*
	PERFORM TRANSITIONS
	*/

	//Get ease mode
	if (argument_count > 12) {
	   var action_ease = argument[12];
	} else {
	   var action_ease = false;
	}

	//Perform transitions
	if (ds_character[# prop._trans_time, ds_target] < ds_character[# prop._trans_dur, ds_target]) {
	   sys_trans_perform(ds_character, ds_target, action_ease);
   
	   //End action when transitions are complete
	   if (ds_character[# prop._trans_time, ds_target] >= ds_character[# prop._trans_dur, ds_target]) {
	      sys_action_term();
	   }
	}



}
