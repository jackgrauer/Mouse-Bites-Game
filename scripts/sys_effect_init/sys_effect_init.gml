/// @function	sys_effect_init(index, effect, duration, loop, reverse, ease);
/// @param		{integer}		index
/// @param		{script}		effect
/// @param		{real}			duration
/// @param		{boolean}		loop
/// @param		{boolean}		reverse
/// @param		{integer|macro}	ease
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_effect_init(argument0, argument1, argument2, argument3, argument4, argument5) {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Initializes an effect which can be performed with sys_effect_perform.

	VNgen's handling of this functionality is highly tailored for its particular
	use-cases and is not intended for general use.

	argument0 = the index of the row containing the target effect ID (integer)
	argument1 = the effect script to perform (script)
	argument2 = sets the length of the **entire effect**, in seconds (real)
	argument3 = enables or disables looping the effect (boolean) (true/false)
	argument4 = enables or disables performing the transition in reverse keyframe order (boolean) (true/false)
	argument5 = sets the effect easing override (see interp for available modes) (integer) (can also use true/false)

	Example usage:
	   sys_effect_init(ds_target, ef_ramp_down, 0.5, false, false, false);
	*/

	//Skip non-looped effects if event skip is active
	if (argument3 == false) {
	   if (sys_event_skip()) {
	      exit;
	   }
	}

	//Get the target data structure
	var ds_target = argument0;

	//If the target effect exists...
	if (script_exists(argument1)) {
	   //Ensure variable data structure exists
	   if (!ds_exists(ds_effect[# prop._ef_var_data, ds_target], ds_type_grid)) {
	      ds_effect[# prop._ef_var_data, ds_target] = ds_grid_create(2, 0);
	   }
   
	   //Get effect variable data
	   var ds_var = ds_effect[# prop._ef_var_data, ds_target];
   
	   //Blend from previous effect, if any
	   var ds_yindex;
	   for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_var); ds_yindex += 1) {
	      ds_var[# prop._tmp_var, ds_yindex] = ds_var[# prop._var, ds_yindex];
	   }
         
	   //Initialize effect
	   ds_effect[# prop._ef, ds_target] = argument1;                //Effect script
	   ds_effect[# prop._state, ds_target] = 0;                     //Effect state
	   ds_effect[# prop._ef_key, ds_target] = 0;                    //Starting keyframe      
	   ds_effect[# prop._ef_dur, ds_target] = max(0.01, argument2); //Duration
	   ds_effect[# prop._ef_loop, ds_target] = argument3;           //Loop mode
	   ds_effect[# prop._ef_rev, ds_target] = argument4;            //Reverse
	   ds_effect[# prop._ef_ease, ds_target] = argument5;           //Ease override
	   ds_effect[# prop._ef_time, ds_target] = 0;                   //Time  
   
	   //Reverse effect, if enabled
	   if (argument4 == true) {
	      //Reset keyframe ID tracking
	      keyframe_id = -1;
	      keyframe_current = -2;
            
	      //Get animation keyframe data
	      script_execute(argument1);
      
	      //Set starting keyframe
	      ds_effect[# prop._ef_key, ds_target] = keyframe_id;       //Keyframe      
	   }   
	}


}
