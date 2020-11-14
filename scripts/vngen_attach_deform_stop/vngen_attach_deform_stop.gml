/// @function	vngen_attach_deform_stop(name, id);
/// @param		{string|macro}	name
/// @param		{real|string}	id
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_attach_deform_stop(argument0, argument1) {

	/*
	Stops a scripted deformation playing on the specified attachment, if any. All values modified 
	by the ongoing deformation will be smoothly returned to their defaults before stopping.

	Note that this script does NOT need to be run in order to change deformations, as deformations
	do not stack. Should deformation stacking be needed, create a single deformation script 
	containing all desired modifications.

	argument0 = identifier of the character to be modified (string)
	argument1 = identifier of the attachment on which to stop deformation (real or string) (or keyword 'all' for all)

	Example usage:
	   vngen_event() {
	      vngen_attach_deform_stop("John Doe", "attach");
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
	      //Get character target
	      var ds_char_target = vngen_get_index(argument0, vngen_type_char);
      
	      //If the target character exists...
	      if (!is_undefined(ds_char_target)) {  
	         //Get attachment data from target character
	         var ds_attach = ds_character[# prop._attach_data, ds_char_target];    
         
	         //Get attachment slot
	         if (argument1 == all) {
	            //Modify all attachments, if enabled
	            var ds_attach_target = sys_grid_last(ds_attach);
	            var ds_xindex = 0;
	         } else {
	            //Otherwise get single attachment to modify
	            var ds_attach_target = vngen_get_index(argument1, vngen_type_attach, argument0);
	            var ds_xindex = ds_attach_target;
	         }
      
	         //If the target attachment exists...
	         if (!is_undefined(ds_attach_target)) {
	            while (ds_attach_target >= ds_xindex) {
	               //Terminate the current deformation, if any
	               sys_deform_term(ds_attach, ds_attach_target);
               
	               //Continue to next attachment, if any
	               ds_attach_target -= 1;
	            }            
	         }
	      }
         
	      //Continue to next action once initialized
	      sys_action_term(); 
	   }
	}


}
