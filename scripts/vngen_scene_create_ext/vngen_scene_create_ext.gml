/// @function	vngen_scene_create_ext(id, sprite, xorig, yorig, x, y, z, scaling, repeat, foreground, transition, duration, ease);
/// @param		{real|string}	id
/// @param		{sprite}		sprite
/// @param		{real|macro}	xorig
/// @param		{real|macro}	yorig
/// @param		{real}			x
/// @param		{real}			y
/// @param		{real}			z
/// @param		{integer|macro}	scaling
/// @param		{boolean}		repeat
/// @param		{boolean}		foreground
/// @param		{script}		transition
/// @param		{real}			duration
/// @param		{integer|macro}	ease
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_scene_create_ext(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7, argument8, argument9, argument10, argument11, argument12) {

	/*
	Creates a new background or foreground scene which will be displayed until 
	vngen_scene_destroy is run. Scenes are drawn from sprites.

	Multiple scenes can exist simultaneously, however be aware that no two scenes
	can share the same ID. The scene ID, or name, is arbitrary and can be either a
	number or a string. Note that the value -1 is reserved as 'null' and cannot be used 
	as a scene ID.

	argument0  = identifier to use for the scene (real or string)
	argument1  = the sprite to use as a new scene (sprite)
	argument2  = the sprite horizontal offset, or center point (real)
	argument3  = the sprite vertical offset, or center point (real)
	argument4  = the horizontal position to display the scene (real)
	argument5  = the vertical position to display the scene (real)
	argument6  = the drawing depth to display the scene, relative to other scenes only (real)
	argument7  = sets the scaling mode to perform: scale_none, scale_x_y, scale_x, scale_y, 
	             scale_stretch_x_y, scale_stretch_x, scale_stretch_y, scale_prop_x_y, 
	             scale_prop_x, or scale_prop_y (integer or macro)
	argument8  = enables or disables endlessly tiling the scene (boolean) (true/false)
	argument9  = sets the scene to either appear above characters or below (boolean) (true/false)
	argument10 = sets the transition script to perform (script) (optional, use 'trans_none' for none)
	argument11 = sets the length of the transition, in seconds (real)
	argument12 = sets the transition easing override (see interp for available modes) (integer) (can also use true/false)

	Example usage:
	   vngen_event() {
	      vngen_scene_create_ext("scene", spr_bg, 960, 540, 0, 0, -1, 1, false, false, trans_fade, 2, false);
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
	      //Get the current number of scene entries
	      var ds_target = ds_grid_height(ds_scene);
   
	      //Create new scene slot in data structure
	      ds_grid_resize(ds_scene, ds_grid_width(ds_scene), ds_grid_height(ds_scene) + 1);   
   
	      //Set basic scene properties
	      ds_scene[# prop._id, ds_target] = argument0;									//ID
	      ds_scene[# prop._sprite, ds_target] = argument1;								//Sprite
	      ds_scene[# prop._left, ds_target] = 0;										//Crop left
	      ds_scene[# prop._top, ds_target] = 0;											//Crop top
	      ds_scene[# prop._width, ds_target] = sprite_get_width(argument1);				//Crop width
	      ds_scene[# prop._height, ds_target] = sprite_get_height(argument1);			//Crop height
	      ds_scene[# prop._x, ds_target] = argument4;									//X
	      ds_scene[# prop._y, ds_target] = argument5;									//Y
	      ds_scene[# prop._z, ds_target] = argument6;									//Z
	      ds_scene[# prop._xscale, ds_target] = 1;										//X scale
	      ds_scene[# prop._yscale, ds_target] = 1;										//Y scale
	      ds_scene[# prop._rot, ds_target] = 0;											//Rotation
	      ds_scene[# prop._col1, ds_target] = c_white;									//Color1
	      ds_scene[# prop._col2, ds_target] = c_white;									//Color2
	      ds_scene[# prop._col3, ds_target] = c_white;									//Color3
	      ds_scene[# prop._col4, ds_target] = c_white;									//Color4
	      ds_scene[# prop._alpha, ds_target] = 1;										//Alpha
		  ds_scene[# prop._img_index, ds_target] = 0;									//Image index
	      ds_scene[# prop._img_num, ds_target] = sprite_get_number(argument1);			//Image number
   
	      //Set special scene properties
	      ds_scene[# prop._fade_src, ds_target] = -1;              //Fade sprite   
	      ds_scene[# prop._fade_alpha, ds_target] = 1;             //Fade alpha
	      ds_scene[# prop._trans, ds_target] = -1;                 //Transition
	      ds_scene[# prop._shader, ds_target] = -1;                //Shader
	      ds_scene[# prop._sh_float_data, ds_target] = -1;         //Shader float data
	      ds_scene[# prop._sh_mat_data, ds_target] = -1;           //Shader matrix data
	      ds_scene[# prop._sh_samp_data, ds_target] = -1;          //Shader sampler data
	      ds_scene[# prop._anim, ds_target] = -1;                  //Animation
	      ds_scene[# prop._anim_xscale, ds_target] = 1;            //Animation X scale
	      ds_scene[# prop._anim_yscale, ds_target] = 1;            //Animation Y scale
	      ds_scene[# prop._anim_alpha, ds_target] = 1;             //Animation alpha
	      ds_scene[# prop._def, ds_target] = -1;                   //Deformation
	      ds_scene[# prop._def_point_data, ds_target] = -1;        //Deform point data
	      ds_scene[# prop._def_surf, ds_target] = -1;              //Deform surface
	      ds_scene[# prop._def_fade_surf, ds_target] = -1;         //Deform fade surface
	      ds_scene[# prop._scn_repeat, ds_target] = argument8;     //Repeat mode   
	      ds_scene[# prop._scn_foreground, ds_target] = argument9; //Foreground mode  
	      ds_scene[# prop._surf, ds_target] = -1;                  //Scene surface
   
	      //Set sprite origins
	      sys_orig_init(ds_scene, ds_target, argument2, argument3);
   
	      //Initialize scaling
	      sys_scale_init(ds_scene, ds_target, global.dp_width, global.dp_height, global.dp_width_init, global.dp_height_init, argument7);
   
	      //Initialize transitions
	      sys_trans_init(ds_scene, ds_target, argument10, argument11, false);
   
	      //Sort data structure by Z depth
	      ds_grid_sort(ds_scene, prop._z, false); 
	  
		  //Get calculated properties
		  ds_scene[# prop._final_xscale, ds_target] = ds_scene[# prop._xscale, ds_target]*ds_scene[# prop._oxscale, ds_target];
		  ds_scene[# prop._final_yscale, ds_target] = ds_scene[# prop._yscale, ds_target]*ds_scene[# prop._oyscale, ds_target];
		  ds_scene[# prop._final_width, ds_target] = ds_scene[# prop._width, ds_target];
		  ds_scene[# prop._final_height, ds_target] = ds_scene[# prop._height, ds_target];
		  ds_scene[# prop._final_x, ds_target] = ds_scene[# prop._x, ds_target] - (ds_scene[# prop._xorig, ds_target]*ds_scene[# prop._final_xscale, ds_target]);
		  ds_scene[# prop._final_y, ds_target] = ds_scene[# prop._y, ds_target] - (ds_scene[# prop._yorig, ds_target]*ds_scene[# prop._final_yscale, ds_target]);
	   }
	}


	/*
	DATA MANAGEMENT
	*/

	//Skip action if engine is paused
	if (global.vg_pause == true) {
	   exit;
	}

	//Get scene slot
	var ds_target = vngen_get_index(argument0, vngen_type_scene);

	//Skip action if target scene does not exist
	if (is_undefined(ds_target)) {
	   exit;
	}


	/*
	PERFORM TRANSITIONS
	*/

	//Perform transitions
	if (ds_scene[# prop._trans_time, ds_target] < ds_scene[# prop._trans_dur, ds_target]) {
	   sys_trans_perform(ds_scene, ds_target, argument12);
   
	   //End action when transitions are complete
	   if (ds_scene[# prop._trans_time, ds_target] >= ds_scene[# prop._trans_dur, ds_target]) {
	      sys_action_term();
	   }
	}



}
