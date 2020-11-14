/// @function	vngen_vox_add(name, sound);
/// @param		{string|macro}	name
/// @param		{sound|array}	sound
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_vox_add() {

	/*
	Adds a new sound or array of sounds to the played as speech synthesis for the specified
	character. Unlike vngen_vox_replace, adding sounds with this script will not clear
	existing resources from the vox entity, but assign multiple sounds to the same character
	which will then be selected at random each time any associated text increments.

	argument0 = identifier or character name associated with the target vox (string) (or keyword 'all' for all)
	argument1 = the new sound resource to add (sound or array)

	Example usage:
	   vngen_event() {
	      vngen_vox_add("John Doe", snd_vox_happy);
	   }
	*/

	/*
	INITIALIZATION
	*/

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
	            //Add new sound(s) to vox
	            sys_vox_add(ds_vox, ds_target, argument[1]);
            
	            //Continue to next vox, if any
	            ds_target -= 1;
	         }
	      }
      
	      //Continue to next action once initialized
	      sys_action_term();
	   }
	}


}
