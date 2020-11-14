/// @function	sys_deform_init(entity, index, def, duration, loop, reverse, ease);
/// @param		{integer}		entity
/// @param		{integer}		index
/// @param		{script}		def
/// @param		{real}			duration
/// @param		{boolean}		loop
/// @param		{boolean}		reverse
/// @param		{integer|macro}	ease
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_deform_init(argument0, argument1, argument2, argument3, argument4, argument5, argument6) {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Initializes a deformation which can be performed with sys_deform_perform on 
	compatible entities.

	VNgen's handling of this functionality is highly tailored for its particular
	use-cases and is not intended for general use.

	argument0 = the data structure for the entity to apply deformation to (integer)
	argument1 = the index of the row containing the target entity ID (integer)
	argument2 = the deformation script to perform (script)
	argument3 = sets the length of the **entire animation**, in seconds (real)
	argument4 = enables or disables looping the animation (boolean) (true/false)
	argument5 = enables or disables performing the deformation in reverse keyframe order (boolean) (true/false)
	argument6 = sets the deformation easing override (see interp for available modes) (integer) (can also use true/false)

	Example usage:
	   sys_deform_init(ds_scene, ds_target, def_wave, 2, true, false, false);
	*/

	//Skip non-looped deformations if event skip is active
	if (argument4 == false) {
	   if (sys_event_skip()) {
	      exit;
	   }
	}

	//Get the target data structure
	var ds_data = argument0;
	var ds_target = argument1;

	//If the target deformation exists...
	if (script_exists(argument2)) {
	   if (ds_exists(ds_data[# prop._def_point_data, ds_target], ds_type_grid)) {
	      //Get point data
	      var ds_point = ds_data[# prop._def_point_data, ds_target];
	      var ds_yindex;
      
	      //Blend from previous deform, if any
	      for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_point); ds_yindex += 1) {
	         ds_point[# prop._tmp_xpoint, ds_yindex] = ds_point[# prop._xpoint, ds_yindex]; //X points
	         ds_point[# prop._tmp_ypoint, ds_yindex] = ds_point[# prop._ypoint, ds_yindex]; //Y points
	      }   
	   } else {
	      //Otherwise initialize point data structure
	      ds_data[# prop._def_point_data, ds_target] = ds_grid_create(4, 0); 
	   }
         
	   //Initialize deformation
	   ds_data[# prop._def, ds_target] = argument2;                //Deformation script
	   ds_data[# prop._def_key, ds_target] = 0;                    //Starting keyframe      
	   ds_data[# prop._def_dur, ds_target] = max(0.01, argument3); //Duration
	   ds_data[# prop._def_loop, ds_target] = argument4;           //Loop mode
	   ds_data[# prop._def_rev, ds_target] = argument5;            //Reverse
	   ds_data[# prop._def_ease, ds_target] = argument6;           //Ease override  
	   ds_data[# prop._def_time, ds_target] = 0;                   //Time
   
	   //Reverse deformation, if enabled
	   if (argument5 == true) {
	      //Reset keyframe ID tracking
	      keyframe_id = -1;
	      keyframe_current = -2;
            
	      //Get animation keyframe data
	      script_execute(argument2);
      
	      //Set starting keyframe
	      ds_data[# prop._def_key, ds_target] = keyframe_id;       //Keyframe      
	   }   
	}


}
