/// @function	sys_vox_add(entity, index, source);
/// @param		{integer}		entity
/// @param		{integer}		index
/// @param		{sound|array}	source
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_vox_add() {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Adds a new sound or array of sounds to the specified vox data structure

	argument0 = the data structure for the entity to apply vox to (integer)
	argument1 = the index of the row containing the target entity ID (integer)
	argument2 = the sound resource to add (sound or array)
            
	Example usage:
	   sys_vox_add(ds_vox, ds_target, snd_vox);
	*/

	//Get the target data structure
	var ds_data = argument[0];
	var ds_target = argument[1];   

	//Ensure sound data structure exists
	if (!ds_exists(ds_data[# prop._snd, ds_target], ds_type_list)) {
	   ds_data[# prop._snd, ds_target] = ds_list_create();
	}

	//Add vox from array, if input
	if (is_array(argument[2])) {
	   //Initialize temporary variables for converting array to data structure
	   var ds_array = argument[2];
	   var ds_yindex;
   
	   //Convert array to list
	   for (ds_yindex = 0; ds_yindex < array_length_1d(ds_array); ds_yindex += 1) {
	      ds_list_add(ds_data[# prop._snd, ds_target], ds_array[@ ds_yindex]);
	   }
	} else {
	   //Otherwise add single sound
	   ds_list_add(ds_data[# prop._snd, ds_target], argument[2]);
	}


}
