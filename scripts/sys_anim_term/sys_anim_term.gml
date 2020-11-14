/// @function	sys_anim_term(entity, index);
/// @param		{integer}	entity
/// @param		{integer}	index
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_anim_term(argument0, argument1) {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Terminates an animation which has been performed with sys_anim_perform. By
	nature, only looped animations need to be terminated.

	VNgen's handling of this functionality is highly tailored for its particular
	use-cases and is not intended for general use.

	argument0 = the data structure for the entity to terminate animation (integer)
	argument1 = the index of the row containing the target entity ID (integer)

	Example usage:
	   sys_anim_term(ds_scene, ds_target);
	*/

	//Get the target data structure
	var ds_data = argument0;
	var ds_target = argument1;

	//If an animation is currently playing...
	if (script_exists(ds_data[# prop._anim, ds_target])) {
	   //Reset keyframe ID tracking
	   keyframe_id = -1;   
	   keyframe_current = -2;
            
	   //Get the number of keyframes in the animation
	   script_execute(ds_data[# prop._anim, ds_target]);
         
	   //Get total number of keyframes
	   keyframe_count = keyframe_id;               
         
	   //Force the animation to skip the remaining keyframes
	   ds_data[# prop._anim_key, ds_target] = 0;
         
	   //Force duration to one keyframe length
	   ds_data[# prop._anim_dur, ds_target] = ds_data[# prop._anim_dur, ds_target]/(keyframe_count + 1);  
         
	   //Force current time to zero
	   ds_data[# prop._anim_time, ds_target] = 0;
               
	   //Force the animation to not loop
	   ds_data[# prop._anim_loop, ds_target] = false;  
   
	   //If event is skipped, end animation immediately
	   if (sys_event_skip()) { 
	      ds_data[# prop._anim_time, ds_target] = ds_data[# prop._anim_dur, ds_target];
	   }
         
	   //Update animation temp values
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
   
	   //Text only
	   if (ds_data == ds_text) or (ds_data == ds_label) {
	      ds_data[# prop._anim_tmp_col1, ds_target] = c_white; //Color1
	      ds_data[# prop._anim_tmp_col2, ds_target] = c_white; //Color2
	      ds_data[# prop._anim_tmp_col3, ds_target] = c_white; //Color3
	      ds_data[# prop._anim_tmp_col4, ds_target] = c_white; //Color4
	   }
         
	   //Flag the animation for value reset
	   ds_data[# prop._anim, ds_target] = -2;
	}


}
