/// @function	vngen_prompt_deform_stop(id);
/// @param		{real|string|macro}	id
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_prompt_deform_stop(argument0) {

	/*
	Stops a scripted deformation playing on the specified prompt, if any. All values modified 
	by the ongoing deformation will be smoothly returned to their defaults before stopping.

	Note that this script does NOT need to be run in order to change deformations, as deformations
	do not stack. Should deformation stacking be needed, create a single deformation script 
	containing all desired modifications.

	argument0 = identifier of the prompt on which to stop deformation (real or string) (or keyword 'all' for all)

	Example usage:
	   vngen_event() {
	      vngen_prompt_deform_stop("prompt");
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
	      //Get prompt slot
	      if (argument0 == all) {
	         //Modify all prompts, if enabled
	         var ds_target = sys_grid_last(ds_prompt);
	         var ds_yindex = 0;
	      } else {
	         //Otherwise get single prompt to modify
	         var ds_target = vngen_get_index(argument0, vngen_type_prompt);
	         var ds_yindex = ds_target;
	      }
         
	      //If the target prompt exists...
	      if (!is_undefined(ds_target)) { 
	         while (ds_target >= ds_yindex) {  
	            //Terminate the current deformation, if any
	            sys_deform_term(ds_prompt, ds_target);
            
	            //Continue to next prompt, if any
	            ds_target -= 1;
	         }   
	      }
         
	      //Continue to next action once initialized
	      sys_action_term();
	   }
	}


}
