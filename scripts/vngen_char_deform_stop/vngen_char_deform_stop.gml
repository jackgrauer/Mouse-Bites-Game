/// @function	vngen_char_deform_stop(name);
/// @param		{string|macro}	name
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_char_deform_stop(argument0) {

	/*
	Stops a scripted deformation playing on the specified character, if any. All values modified 
	by the ongoing deformation will be smoothly returned to their defaults before stopping.

	Note that this script does NOT need to be run in order to change deformations, as deformations
	do not stack. Should deformation stacking be needed, create a single deformation script 
	containing all desired modifications.

	argument0 = identifier of the character on which to stop deformation (string) (or keyword 'all' for all)

	Example usage:
	   vngen_event() {
	      vngen_char_deform_stop("John Doe");
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
	      //Get character slot
	      if (argument0 == all) {
	         //Modify all characters, if enabled
	         var ds_target = sys_grid_last(ds_character);
	         var ds_yindex = 0;
	      } else {
	         //Otherwise get single character to modify
	         var ds_target = vngen_get_index(argument0, vngen_type_char);
	         var ds_yindex = ds_target;
	      }
        
	      //If the target character exists...
	      if (!is_undefined(ds_target)) {   
	         while (ds_target >= ds_yindex) { 
	            //Terminate the current deformation, if any
	            sys_deform_term(ds_character, ds_target);
            
	            //Continue to next character, if any
	            ds_target -= 1;
	         }
	      }
         
	      //Continue to next action once initialized
	      sys_action_term();
	   }
	}


}
