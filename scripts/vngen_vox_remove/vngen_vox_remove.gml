/// @function	vngen_vox_remove(name, sound);
/// @param		{string|macro}	name
/// @param		{sound|array}	sound
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_vox_remove() {
	//                   0      1 

	/*
	Removes a sound or array of sounds from speech synthesis associated with specified
	character. Unlike vngen_vox_stop, removing sounds with this script will not completely
	destroy the vox entity and remove it from memory, but only remove sounds from a list
	of multiple assigned to the same character.

	argument0 = identifier or character name associated with the target vox (string) (or keyword 'all' for all)
	argument1 = the sound resource to remove (sound or array)

	Example usage:
	   vngen_event() {
	      vngen_vox_remove("John Doe", snd_vox_happy);
	   }
	*/

	/*
	INITIALIZATION
	*/

	//Initialize temporary variables for checking vox slot
	var ds_data, ds_xindex, ds_yindex;
	var ds_array = argument[1];

	//Enable action, if active
	switch (sys_action_init()) {
	   //Exit if event is inactive
	   case false: {
	      exit;
	   }
      
	   //Initialize action if active
	   case true: {
	      //Get vox slot
	      if (argument[0] == all) {
	         //Modify all vox, if enabled
	         var ds_target = sys_grid_last(ds_vox);
	         var ds_yindex = 0;
	      } else {
	         //Otherwise get single vox to modify
	         var ds_target = vngen_get_index(argument[0], vngen_type_vox);
	         var ds_yindex = ds_target;
	      }  
   
	      //If the target vox exists...
	      if (!is_undefined(ds_target)) {
	         while (ds_target >= ds_yindex) {  
	            //Ensure sound data structure exists
	            if (!ds_exists(ds_vox[# prop._snd, ds_target], ds_type_list)) {
	               ds_vox[# prop._snd, ds_target] = ds_list_create();
	            }
            
	            //Get vox sound data
	            ds_data = ds_vox[# prop._snd, ds_target];
            
	            //Remove vox from array, if input
	            if (is_array(ds_array)) {               
	               //Remove array from list
	               for (ds_yindex = 0; ds_yindex < array_length_1d(ds_array); ds_yindex += 1) {
	                  //Get sound resource to remove
	                  ds_xindex = ds_list_find_index(ds_data, ds_array[@ ds_yindex]);
                  
	                  //If resource exists, remove it
	                  if (ds_xindex != -1) {
	                     ds_list_delete(ds_data, ds_xindex);
	                  }
	               }
	            } else {
	               //Otherwise get single sound resource to remove
	               var ds_xindex = ds_list_find_index(ds_data, argument[1]);
               
	               //If resource exists, remove it
	               if (ds_xindex != -1) {
	                  ds_list_delete(ds_data, ds_xindex);
	               }
	            }
            
	            //Continue to next vox, if any
	            ds_target -= 1;
	         }
	      }
      
	      //Continue to next action once initialized
	      sys_action_term();
	   }
	}


}
