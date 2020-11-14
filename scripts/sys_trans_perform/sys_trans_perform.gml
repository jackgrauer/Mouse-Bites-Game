/// @function	sys_trans_perform(entity, index, ease);
/// @param		{integer}		x
/// @param		{integer}		y
/// @param		{integer|macro}	speed
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_trans_perform(argument0, argument1, argument2) {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Performs transitions which have been initialized with sys_trans_init on 
	compatible entities when created or destroyed. Also returns true or false 
	depending on whether the transition is active.

	VNgen's handling of this functionality is highly tailored for its particular
	use-cases and is not intended for general use.

	argument0 = the data structure for the entity to apply transition to (integer)
	argument1 = the index of the row containing the target entity ID (integer)
	argument2 = sets the transition easing override (see interp for available modes) (integer)

	Example usage:
	   sys_trans_perform(ds_data, ds_target, true);
	*/

	/*
	INITIALIZATION
	*/

	//Get the target data structure
	var ds_data = argument0;
	var ds_target = argument1;
	var ds_trans = ds_data[# prop._trans, ds_target];
	var trans_active = true;


	/*
	PERFORM TRANSITIONS
	*/

	//Perform transition, if any
	if (ds_trans != -1) {
	   //Clear previous keyframe values
	   trans_left = 0;
	   trans_top = 0;
	   trans_width = 0;
	   trans_height = 0; 
	   trans_x = 0;
	   trans_y = 0;
	   trans_xscale = 1;
	   trans_yscale = 1; 
	   trans_rot = 0;
	   trans_alpha = 1;
	   trans_ease = 0;
	   keyframe_count = 0;
   
	   //Get dimensions to pass into scripts
	   input_width = ds_data[# prop._width, ds_target];
	   input_height = ds_data[# prop._height, ds_target];
	   input_x = ds_data[# prop._x, ds_target];
	   input_y = ds_data[# prop._y, ds_target];
	   input_xscale = ds_data[# prop._xscale, ds_target]*ds_data[# prop._oxscale, ds_target];
	   input_yscale = ds_data[# prop._yscale, ds_target]*ds_data[# prop._oyscale, ds_target];
	   input_rot = ds_data[# prop._rot, ds_target];
   
	   //Get transition keyframe data
	   if (script_exists(ds_trans)) {        
	      //Reset keyframe ID tracking
	      keyframe_id = -1;
            
	      //Get current keyframe
	      keyframe_current = ds_data[# prop._trans_key, ds_target];
      
	      //Get transition keyframe data
	      script_execute(ds_trans);
               
	      //Get total number of keyframes
	      keyframe_count = keyframe_id;
      
	      //Get transition duration for playing
	      var action_trans_duration = ds_data[# prop._trans_dur, ds_target]/(keyframe_count + 1);   
	   } else {
	      //Get transition duration for stopping
	      var action_trans_duration = ds_data[# prop._trans_dur, ds_target];   
	   }

	   //Get keyframe target based on transition direction
	   if (ds_data[# prop._trans_rev, ds_target] == false) {
	      //Forwards
	      var keyframe_target = (keyframe_count + 1);
	      var key = 1;
	   } else {
	      //Backwards
	      var keyframe_target = 0;
	      var key = -1;
	   }
   
	   //Increment animation time/keyframes
	   if (ds_data[# prop._trans_time, ds_target] <= action_trans_duration) {
	      //Skip transition if transition does not exist or vngen_do_continue is run
	      if (sys_action_skip()) or (!script_exists(ds_data[# prop._trans, ds_target])) {
	         ds_data[# prop._trans_key, ds_target] = keyframe_target;
	         ds_data[# prop._trans_time, ds_target] = action_trans_duration + 1;
	      } else {
	         //Otherwise count up transition time
	         ds_data[# prop._trans_time, ds_target] += time_frame;
	      }
      
	      //Continue to next keyframe when complete
	      if (ds_data[# prop._trans_time, ds_target] > action_trans_duration) {  
	         //Update transition temp values
	         ds_data[# prop._trans_tmp_left, ds_target] = ds_data[# prop._trans_left, ds_target];     //Left
	         ds_data[# prop._trans_tmp_top, ds_target] = ds_data[# prop._trans_top, ds_target];       //Top
	         ds_data[# prop._trans_tmp_width, ds_target] = ds_data[# prop._trans_width, ds_target];   //Width
	         ds_data[# prop._trans_tmp_height, ds_target] = ds_data[# prop._trans_height, ds_target]; //Height
	         ds_data[# prop._trans_tmp_x, ds_target] = ds_data[# prop._trans_x, ds_target];           //X
	         ds_data[# prop._trans_tmp_y, ds_target] = ds_data[# prop._trans_y, ds_target];           //Y
	         ds_data[# prop._trans_tmp_xscale, ds_target] = ds_data[# prop._trans_xscale, ds_target]; //X scale
	         ds_data[# prop._trans_tmp_yscale, ds_target] = ds_data[# prop._trans_yscale, ds_target]; //Y scale
	         ds_data[# prop._trans_tmp_rot, ds_target] = ds_data[# prop._trans_rot, ds_target];       //Rotation
	         ds_data[# prop._trans_tmp_alpha, ds_target] = ds_data[# prop._trans_alpha, ds_target];   //Alpha
                  
	         //Reset time for next keyframe
	         ds_data[# prop._trans_time, ds_target] = 0;
         
	         //Increment keyframes, if transition is incomplete
	         if (ds_data[# prop._trans_key, ds_target] != keyframe_target) { 
	            ds_data[# prop._trans_key, ds_target] += key;
	         } else {
	            //Otherwise end the transition
	            ds_data[# prop._trans, ds_target] = -1;
	            ds_data[# prop._trans_key, ds_target] = 0;
	            ds_data[# prop._trans_time, ds_target] = action_trans_duration;
            
	            //Flag transition as inactive
	            trans_active = false;
	         }
	      }
	   }
   
	   //Get ease mode override, if any
	   if (argument2 > 0) {
	      trans_ease = argument2;
	   }
   
	   //Get current transition time
	   var action_trans_time = interp(0, 1, ds_data[# prop._trans_time, ds_target]/action_trans_duration, trans_ease);
   
	   //Perform transition keyframes
	   ds_data[# prop._trans_left, ds_target] = clamp(lerp(ds_data[# prop._trans_tmp_left, ds_target], trans_left, action_trans_time), 0, input_width - 1);         //Left
	   ds_data[# prop._trans_top, ds_target] = clamp(lerp(ds_data[# prop._trans_tmp_top, ds_target], trans_top, action_trans_time), 0, input_height - 1);           //Top
	   ds_data[# prop._trans_width, ds_target] = clamp(lerp(ds_data[# prop._trans_tmp_width, ds_target], trans_width, action_trans_time), -input_width + 1, 0);     //Width
	   ds_data[# prop._trans_height, ds_target] = clamp(lerp(ds_data[# prop._trans_tmp_height, ds_target], trans_height, action_trans_time), -input_height + 1, 0); //Height
	   ds_data[# prop._trans_x, ds_target] = lerp(ds_data[# prop._trans_tmp_x, ds_target], trans_x, action_trans_time);                                             //X
	   ds_data[# prop._trans_y, ds_target] = lerp(ds_data[# prop._trans_tmp_y, ds_target], trans_y, action_trans_time);                                             //Y
	   ds_data[# prop._trans_xscale, ds_target] = lerp(ds_data[# prop._trans_tmp_xscale, ds_target], trans_xscale, action_trans_time);                              //X scale
	   ds_data[# prop._trans_yscale, ds_target] = lerp(ds_data[# prop._trans_tmp_yscale, ds_target], trans_yscale, action_trans_time);                              //Y scale
	   ds_data[# prop._trans_rot, ds_target] = lerp(ds_data[# prop._trans_tmp_rot, ds_target], trans_rot, action_trans_time);                                       //Rotation
	   ds_data[# prop._trans_alpha, ds_target] = lerp(ds_data[# prop._trans_tmp_alpha, ds_target], trans_alpha, action_trans_time);                                 //Alpha
	} else {
	   //Otherwise flag transition as inactive
	   trans_active = false;
	}
   
	//Return transition state
	return trans_active;


}
