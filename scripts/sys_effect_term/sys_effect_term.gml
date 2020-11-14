/// @function	sys_effect_term(index);
/// @param		{integer}	index
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_effect_term(argument0) {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Terminates an effect which has been performed with sys_effect_perform. By
	nature, only looped effects need to be terminated.

	VNgen's handling of this functionality is highly tailored for its particular
	use-cases and is not intended for general use.

	argument0 = the index of the row containing the target effect ID (integer)

	Example usage:
	   sys_effect_term(ds_target);
	*/

	//Get the target data structure
	var ds_target = argument0;

	//If an effect is currently playing...
	if (script_exists(ds_effect[# prop._ef, ds_target])) and (ds_effect[# prop._state, ds_target] > -1) {
	   //Reset keyframe ID tracking
	   keyframe_id = -1;   
	   keyframe_current = -2;
   
	   //Get the number of keyframes in the effect
	   script_execute(ds_effect[# prop._ef, ds_target]);
         
	   //Get total number of keyframes
	   keyframe_count = keyframe_id;           
         
	   //Force the effect to skip the remaining keyframes
	   ds_effect[# prop._ef_key, ds_target] = 0;    
         
	   //Force duration to one keyframe length
	   ds_effect[# prop._ef_dur, ds_target] = ds_effect[# prop._ef_dur, ds_target]/(keyframe_count + 1);  
         
	   //Force current time to zero
	   ds_effect[# prop._ef_time, ds_target] = 0;
               
	   //Force the effect to not loop
	   ds_effect[# prop._ef_loop, ds_target] = false;  
   
	   //If event is skipped, end effect immediately
	   if (sys_event_skip()) { 
	      ds_effect[# prop._ef_time, ds_target] = ds_effect[# prop._ef_dur, ds_target];  
	   }
         
	   //Update effect temp values
	   if (ds_exists(ds_effect[# prop._ef_var_data, ds_target], ds_type_grid)) {
	      //Get effect variable data
	      var ds_var = ds_effect[# prop._ef_var_data, ds_target];
	      var ds_yindex;
      
	      //Update effect temp values
	      for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_var); ds_yindex += 1) {
	         ds_var[# prop._tmp_var, ds_yindex] = ds_var[# prop._var, ds_yindex];
	      }   
	   }
            
	   //Flag the effect for value reset
	   ds_effect[# prop._state, ds_target] = -2;
	}


}
