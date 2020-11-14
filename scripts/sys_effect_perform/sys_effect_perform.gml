/// @function	sys_effect_perform(index, x, y);
/// @param		{integer}	index
/// @param		{real}		x
/// @param		{real}		y
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_effect_perform(argument0, argument1, argument2) {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Performs effects which have been initialized with vngen_effect_start. Also 
	returns true or false depending on whether the effect is active.

	VNgen's handling of this functionality is highly tailored for its particular
	use-cases and is not intended for general use.

	argument0 = the index of the row containing the target effect ID (integer)
	argument1 = horizontal offset for all effects (real)
	argument2 = vertical offset for all effects (real)

	Example usage:
	   sys_effect_perform(ds_target, 0, 0);
	*/

	/*
	INITIALIZATION
	*/

	//Get the target effect
	var ds_target = argument0;
	var ds_ef = ds_effect[# prop._ef, ds_target];
	var ds_state = ds_effect[# prop._state, ds_target];
	var ef_active = true;


	/*
	PERFORM EFFECTS
	*/
            
	//Perform effect, if any
	if (ds_state != -1) {
	   //Ensure variable data structure exists
	   if (!ds_exists(ds_effect[# prop._ef_var_data, ds_target], ds_type_grid)) {
	      ds_effect[# prop._ef_var_data, ds_target] = ds_grid_create(2, 0);
	   }
   
	   //Get effect variable data
	   var ds_var = ds_effect[# prop._ef_var_data, ds_target];
	   var ds_yindex;
   
	   //Clear previous keyframe values
	   ef_var = -1;
	   ef_var = array_create(ds_grid_height(ds_var));
	   ef_ease = 0;
	   keyframe_count = 0;
   
	   //Get dimensions to pass into scripts
	   input_rate = time_offset;
	   input_width = global.dp_width;
	   input_height = global.dp_height;
	   input_x = argument1;
	   input_y = argument2;
                          
	   //Get effect keyframe data
	   if (ds_state != -2) {            
	      //Reset keyframe ID tracking
	      keyframe_id = -1;
            
	      //Get current keyframe
	      keyframe_current = ds_effect[# prop._ef_key, ds_target];
            
	      //Get effect keyframe data
	      if (script_exists(ds_ef)) {
	         script_execute(ds_ef);
	      }
            
	      //Get total number of keyframes
	      keyframe_count = keyframe_id;
            
	      //Get effect duration for playing
	      var action_ef_duration = ds_effect[# prop._ef_dur, ds_target]/(keyframe_count + 1);             
	   } else {
	      //Get effect duration for stopping
	      var action_ef_duration = ds_effect[# prop._ef_dur, ds_target];                    
	   }      
      
	   //Get total number of effect variables
	   if (array_length_1d(ef_var) != ds_grid_height(ds_var)) {
	      ds_grid_resize(ds_var, ds_grid_width(ds_var), array_length_1d(ef_var));
	   }

	   //Get keyframe target based on transition direction
	   if (ds_effect[# prop._ef_rev, ds_target] == false) {
	      //Forwards
	      var keyframe_target = keyframe_count;
	      var keyframe_loop = 0;
	      var key = 1;
	   } else {
	      //Backwards
	      var keyframe_target = 0;
	      var keyframe_loop = keyframe_count;
	      var key = -1;
	   }
         
	   //Increment effect time/keyframes
	   if (ds_effect[# prop._ef_time, ds_target] <= action_ef_duration) {
	      //Count up effect time
	      ds_effect[# prop._ef_time, ds_target] += time_frame;
               
	      //Continue to next keyframe when complete
	      if (ds_effect[# prop._ef_time, ds_target] > action_ef_duration) {   
	         //Update effect values
	         for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_var); ds_yindex += 1) {
	            ds_var[# prop._var, ds_yindex] = ef_var[ds_yindex];
            
	            //Update effect temp values
	            ds_var[# prop._tmp_var, ds_yindex] = ds_var[# prop._var, ds_yindex];
	         }           
               
	         //Reset time for next keyframe
	         ds_effect[# prop._ef_time, ds_target] = 0;
                              
	         //Increment keyframes, if effect is incomplete
	         if (ds_effect[# prop._ef_key, ds_target] != keyframe_target) { 
	            ds_effect[# prop._ef_key, ds_target] += key;
	         } else {
	            //Otherwise loop effect, if enabled                  
	            if (ds_effect[# prop._ef_loop, ds_target] == true) {
	               //If loop is enabled, restart the effect
	               ds_effect[# prop._ef_key, ds_target] = keyframe_loop;
	            } else {
	               //If loop is disabled, end the effect
	               if (ds_state != -1) {
	                  if (ds_state == -2) {
	                     //If all values are reset, end the animation
	                     ds_effect[# prop._state, ds_target] = -1;
	                     ds_effect[# prop._ef_time, ds_target] = action_ef_duration;
            
	                     //Flag effect as inactive
	                     ef_active = false;
	                  } else {
	                     //Otherwise flag values for reset
	                     ds_effect[# prop._state, ds_target] = -2;
	                     ds_effect[# prop._ef_key, ds_target] = 0;
                           
	                     //Set animation reset time
	                     ds_effect[# prop._ef_dur, ds_target] = ds_effect[# prop._ef_dur, ds_target]/(keyframe_count + 1);  
	                  }
	               }
	            }
	         } 
	      }
	   }                     
   
	   //Get ease mode override, if any
	   if (ds_effect[# prop._ef_ease, ds_target] > 0) {
	      ef_ease = ds_effect[# prop._ef_ease, ds_target];
	   }   
         
	   //Get current effect time
	   var action_ef_time = interp(0, 1, ds_effect[# prop._ef_time, ds_target]/action_ef_duration, ef_ease);      
            
	   //Perform effect keyframes
	   for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_var); ds_yindex += 1) {
	      if (is_real(ds_var[# prop._var, ds_yindex])) {
	         if (is_real(ds_var[# prop._tmp_var, ds_yindex])) {
	            if (is_real(ef_var[ds_yindex])) {
	               ds_var[# prop._var, ds_yindex] = lerp(ds_var[# prop._tmp_var, ds_yindex], ef_var[ds_yindex], action_ef_time);
	            }
	         }
	      }      
      
	      //Update effect values
	      ef_var[ds_yindex] = ds_var[# prop._var, ds_yindex];
	   } 

	   //Get effect code
	   keyframe_current = -1;
   
	   //Perform effect code
	   if (ds_grid_height(ds_var) > 0) {
	      if (script_exists(ds_ef)) {
	         script_execute(ds_ef);
	      }
	   }
   
	   //Remove effect from data structure when complete
	   if (ds_effect[# prop._state, ds_target] == -1) {
	      //Clear effect variable data from memory
	      ds_grid_destroy(ds_var);
	      ds_effect[# prop._ef_var_data, ds_target] = -1;
      
	      //Clear array from memory
	      ef_var = -1;
      
	      //Remove effect from data structure
	      ds_effect = sys_grid_delete(ds_effect, ds_target); 
	   }    
	} else {
	   //Otherwise flag effect as inactive
	   ef_active = false;
	}
   
	//Return effect state
	return ef_active;


}
