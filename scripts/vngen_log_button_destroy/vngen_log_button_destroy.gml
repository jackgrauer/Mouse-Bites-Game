/// @function	vngen_log_button_destroy(id);
/// @param		{real|string}	id
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_log_button_destroy() {

	/*
	Removes a log button previously created with vngen_log_button_create.

	argument0 = identifier of the button to be removed (real or string) (or keyword 'all' for all)

	Example usage:
	   vngen_event() {
	      vngen_log_button_destroy("button");
	   }
	*/

	/*
	INITIALIZATION
	*/

	//Get button slot
	if (argument[0] == all) {
	   //Destroy all buttons, if enabled
	   var ds_target = sys_grid_last(global.ds_log_button);
	   var ds_yindex = 0;
	} else {
	   //Otherwise get single button to destroy
	   var ds_target = vngen_get_index(argument[0], vngen_type_button);
	   var ds_yindex = ds_target;
	}   

	//Skip action if target button does not exist
	if (is_undefined(ds_target)) {
	   exit;
	}


	/*
	FINALIZATION
	*/

	while (ds_target >= ds_yindex) {    
	   //Clear text surface from memory, if any
	   if (surface_exists(global.ds_log_button[# prop._surf, ds_target])) {
	      surface_free(global.ds_log_button[# prop._surf, ds_target]);
	   }
   
	   //Remove button from data structure
	   global.ds_log_button = sys_grid_delete(global.ds_log_button, ds_target);
   
	   //Get number of remaining buttons
	   button_count = ds_grid_height(global.ds_log_button);
   
	   //End action when transitions are complete
	   if (ds_target == ds_yindex) {
	      sys_action_term();
	   }
            
	   //Continue to next button, if any
	   ds_target -= 1;
	}


}
