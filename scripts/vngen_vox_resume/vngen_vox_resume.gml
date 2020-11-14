/// @function	vngen_vox_resume(name);
/// @param		{string|macro}	name
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_vox_resume(argument0) {

	/*
	Unpauses the given speech synthesis to resume playing.

	This script should only be used to resume sounds paused with
	vngen_vox_pause and not the built-in audio_resume_sound
	function.

	argument0 = identifier or character name associated with the target vox (string) (or keyword 'all' for all)

	Example usage:
	   vngen_event() {
	      vngen_vox_resume("John Doe");
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
	      if (argument0 == all) {
	         //Pause all vox, if enabled
	         var ds_target = sys_grid_last(ds_vox);
	         var ds_yindex = 0;
	      } else {
	         //Otherwise get single vox to pause
	         var ds_target = vngen_get_index(argument0, vngen_type_vox);
	         var ds_yindex = ds_target;
	      }  
   
	      //If the target vox exists...
	      if (!is_undefined(ds_target)) {
	         while (ds_target >= ds_yindex) { 
	            //Set audio type to playing
	            ds_vox[# prop._type, ds_target] = 0;
            
	            //Continue to next vox, if any
	            ds_target -= 1;
	         }
	      }
      
	      //Continue to next action once initialized
	      sys_action_term();
	   }
	}


}
