/// @function	sys_deform_term(entity, index);
/// @param		{integer}	entity
/// @param		{integer}	index
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_deform_term(argument0, argument1) {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Terminates a deformation which has been performed with sys_deform_perform. 
	By nature, only looped deformations need to be terminated.

	VNgen's handling of this functionality is highly tailored for its particular
	use-cases and is not intended for general use.

	argument0 = the data structure for the entity to terminate deformation (integer)
	argument1 = the index of the row containing the target entity ID (integer)

	Example usage:
	   sys_deform_term(ds_scene, ds_target);
	*/

	//Get the target data structure
	var ds_data = argument0;
	var ds_target = argument1;
       
	//If a deformation is currently playing...
	if (script_exists(ds_data[# prop._def, ds_target])) {
	   //Reset keyframe ID tracking
	   keyframe_id = -1;
	   keyframe_current = -2;
            
	   //Get the number of keyframes in the deformation
	   script_execute(ds_data[# prop._def, ds_target]);
         
	   //Get total number of keyframes
	   keyframe_count = keyframe_id;           
         
	   //Force the deformation to skip the remaining keyframes
	   ds_data[# prop._def_key, ds_target] = 0;
         
	   //Force duration to one keyframe length
	   ds_data[# prop._def_dur, ds_target] = ds_data[# prop._def_dur, ds_target]/(keyframe_count + 1);  
         
	   //Force current time to zero
	   ds_data[# prop._def_time, ds_target] = 0;
               
	   //Force the deformation to not loop
	   ds_data[# prop._def_loop, ds_target] = false; 
   
	   //If event is skipped, end deformation immediately
	   if (sys_event_skip()) { 
	      ds_data[# prop._def_time, ds_target] = ds_data[# prop._def_dur, ds_target];
	   } 
         
	   //Update deformation temp values
	   if (ds_exists(ds_data[# prop._def_point_data, ds_target], ds_type_grid)) {
	      //Get point data
	      var ds_point = ds_data[# prop._def_point_data, ds_target];
	      var ds_yindex;
      
	      //Update temp values
	      for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_point); ds_yindex += 1) {
	         ds_point[# prop._tmp_xpoint, ds_yindex] = ds_point[# prop._xpoint, ds_yindex]; //X points
	         ds_point[# prop._tmp_ypoint, ds_yindex] = ds_point[# prop._ypoint, ds_yindex]; //Y points
	      }   
	   }         
         
	   //Flag the deformation for value reset
	   ds_data[# prop._def, ds_target] = -2;
	}


}
