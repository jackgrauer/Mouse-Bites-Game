/// @function	sys_anim_init(entity, index, anim, duration, loop, reverse, ease);
/// @param		{integer}		entity
/// @param		{integer}		index
/// @param		{script}		anim
/// @param		{real}			duration
/// @param		{boolean}		loop
/// @param		{boolean}		reverse
/// @param		{integer|macro}	ease
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_anim_init(argument0, argument1, argument2, argument3, argument4, argument5, argument6) {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Initializes an animation which can be performed with sys_anim_perform on compatible 
	entities.

	VNgen's handling of this functionality is highly tailored for its particular
	use-cases and is not intended for general use.

	argument0 = the data structure for the entity to apply animation to (integer)
	argument1 = the index of the row containing the target entity ID (integer)
	argument2 = the animation script to perform (script)
	argument3 = sets the length of the **entire animation**, in seconds (real)
	argument4 = enables or disables looping the animation (boolean) (true/false)
	argument5 = enables or disables performing the transition in reverse keyframe order (boolean) (true/false)
	argument6 = sets the animation easing override (see interp for available modes) (integer) (can also use true/false)

	Example usage:
	   sys_anim_init(ds_scene, ds_target, anim_wiggle, 0.5, true, false, false);
	*/

	//Skip non-looped animations if event skip is active
	if (argument4 == false) {
	   if (sys_event_skip()) {
	      exit;
	   }
	}

	//Get the target data structure
	var ds_data = argument0;
	var ds_target = argument1;

	//If the target animation exists...
	if (script_exists(argument2)) {
	   //Blend from previous animation, if any
	   if (script_exists(ds_data[# prop._anim, ds_target])) {
	      //Get target color values
	      var col1 = ds_data[# prop._anim_col1, ds_target];
	      var col2 = ds_data[# prop._anim_col2, ds_target];
	      var col3 = ds_data[# prop._anim_col3, ds_target];
	      var col4 = ds_data[# prop._anim_col4, ds_target];
      
	      //Update temp animation values
	      ds_data[# prop._anim_tmp_x, ds_target] = ds_data[# prop._anim_x, ds_target];           //X
	      ds_data[# prop._anim_tmp_y, ds_target] = ds_data[# prop._anim_y, ds_target];           //Y
	      ds_data[# prop._anim_tmp_xscale, ds_target] = ds_data[# prop._anim_xscale, ds_target]; //X scale (Perspective zoom)
	      ds_data[# prop._anim_tmp_yscale, ds_target] = ds_data[# prop._anim_yscale, ds_target]; //Y scale (Perspective strength)
	      ds_data[# prop._anim_tmp_rot, ds_target] = ds_data[# prop._anim_rot, ds_target];       //Rotation
	      ds_data[# prop._anim_tmp_col1, ds_target] = ds_data[# prop._col1, ds_target];          //Color1
	      ds_data[# prop._anim_tmp_col2, ds_target] = ds_data[# prop._col2, ds_target];          //Color2
	      ds_data[# prop._anim_tmp_col3, ds_target] = ds_data[# prop._col3, ds_target];          //Color3
	      ds_data[# prop._anim_tmp_col4, ds_target] = ds_data[# prop._col4, ds_target];          //Color4
	      ds_data[# prop._anim_tmp_alpha, ds_target] = ds_data[# prop._anim_alpha, ds_target];   //Alpha  
   
	      //Perspective only
	      if (ds_data == ds_perspective) {
	         ds_perspective[# prop._anim_tmp_xoffset, ds_target] = ds_perspective[# prop._anim_xoffset, ds_target]; //X offset
	         ds_perspective[# prop._anim_tmp_yoffset, ds_target] = ds_perspective[# prop._anim_yoffset, ds_target]; //Y offset
	      }
      
	   //Otherwise clear temp animation values
	   } else {   
	      //Get target color values based on input entity
	      if (ds_data == ds_text) or (ds_data == ds_label) {
	         //Text surface color
	         var col1 = c_white;
	         var col2 = c_white;
	         var col3 = c_white;
	         var col4 = c_white;
	      } else {
	         //Default color
	         var col1 = ds_data[# prop._col1, ds_target];
	         var col2 = ds_data[# prop._col2, ds_target];
	         var col3 = ds_data[# prop._col3, ds_target];
	         var col4 = ds_data[# prop._col4, ds_target];
	      }
      
	      //Clear temp animation values
	      ds_data[# prop._anim_tmp_x, ds_target] = 0;       //X
	      ds_data[# prop._anim_tmp_y, ds_target] = 0;       //Y
	      ds_data[# prop._anim_tmp_xscale, ds_target] = 1;  //X scale (Perspective zoom)
	      ds_data[# prop._anim_tmp_yscale, ds_target] = 1;  //Y scale (Perspective strength)
	      ds_data[# prop._anim_tmp_rot, ds_target] = 0;     //Rotation
	      ds_data[# prop._anim_tmp_col1, ds_target] = col1; //Color1
	      ds_data[# prop._anim_tmp_col2, ds_target] = col2; //Color2
	      ds_data[# prop._anim_tmp_col3, ds_target] = col3; //Color3 (Perspective X offset)
	      ds_data[# prop._anim_tmp_col4, ds_target] = col4; //Color4 (Perspective Y offset)
	      ds_data[# prop._anim_tmp_alpha, ds_target] = 1;   //Alpha
	   }   
       
	   //Initialize animation
	   ds_data[# prop._anim, ds_target] = argument2;                //Animation script
	   ds_data[# prop._anim_key, ds_target] = 0;                    //Starting keyframe      
	   ds_data[# prop._anim_dur, ds_target] = max(0.01, argument3); //Duration
	   ds_data[# prop._anim_loop, ds_target] = argument4;           //Loop mode
	   ds_data[# prop._anim_rev, ds_target] = argument5;            //Loop mode
	   ds_data[# prop._anim_ease, ds_target] = argument6;           //Ease override
	   ds_data[# prop._anim_x, ds_target] = 0;                      //X
	   ds_data[# prop._anim_y, ds_target] = 0;                      //Y
	   ds_data[# prop._anim_xscale, ds_target] = 1;                 //X scale (Perspective zoom)
	   ds_data[# prop._anim_yscale, ds_target] = 1;                 //Y scale (Perspective strength)
	   ds_data[# prop._anim_rot, ds_target] = 0;                    //Rotation
	   ds_data[# prop._anim_col1, ds_target] = col1;                //Color1
	   ds_data[# prop._anim_col2, ds_target] = col2;                //Color2
	   ds_data[# prop._anim_col3, ds_target] = col3;                //Color3 (Perspective X offset)
	   ds_data[# prop._anim_col4, ds_target] = col4;                //Color4 (Perspective Y offset)
	   ds_data[# prop._anim_alpha, ds_target] = 1;                  //Alpha
	   ds_data[# prop._anim_time, ds_target] = 0;                   //Time
   
	   //Reverse animation, if enabled
	   if (argument5 == true) {
	      //Reset keyframe ID tracking
	      keyframe_id = -1;
	      keyframe_current = -2;
            
	      //Get animation keyframe data
	      script_execute(argument2);
      
	      //Set starting keyframe
	      ds_data[# prop._anim_key, ds_target] = keyframe_id;       //Keyframe      
	   }
	}


}
