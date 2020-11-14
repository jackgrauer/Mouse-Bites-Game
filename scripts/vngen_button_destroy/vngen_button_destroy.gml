/// @function	vngen_button_destroy(id, transition, duration, [ease]);
/// @param		{real|string|macro}	id
/// @param		{script}			transition
/// @param		{real}				duration
/// @param		{integer|macro}		[ease]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_button_destroy() {

	/*
	Removes a button previously created with vngen_button_create, optionally
	transitioning out with the given transition style and duration.

	argument0 = identifier of the button to be removed (real or string) (or keyword 'all' for all)
	argument1 = sets the transition script to perform (script) (optional, use 'trans_none' for none)
	argument2 = sets the length of the transition, in seconds (real)
	argument3 = sets the transition easing override (see interp for available modes) (integer) (can also use true/false) (optional, use no argument for none)

	Example usage:
	   vngen_event() {
	      vngen_button_destroy("button", trans_fade, 2, true);
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
	      //Get button slot
	      if (argument[0] == all) {
	         //Destroy all buttons, if enabled
	         var ds_target = sys_grid_last(ds_button);
	         var ds_yindex = 0;
	      } else {
	         //Otherwise get single button to destroy
	         var ds_target = vngen_get_index(argument[0], vngen_type_button);
	         var ds_yindex = ds_target;
	      }      
         
	      //If the target button exists...
	      if (!is_undefined(ds_target)) {   
	         while (ds_target >= ds_yindex) {  
	            //Initialize transitions
	            sys_trans_init(ds_button, ds_target, argument[1], argument[2], true);   
            
	            //Continue to next button, if any
	            ds_target -= 1;
	         }   
	      } else {
	         //Skip action if button does not exist
	         sys_action_term();
	         exit;
	      }   
	   }
	}


	/*
	DATA MANAGEMENT
	*/

	//Get button slot
	if (argument[0] == all) {
	   //Destroy all buttons, if enabled
	   var ds_target = sys_grid_last(ds_button);
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
	PERFORM TRANSITIONS
	*/

	while (ds_target >= ds_yindex) { 
	   //Get ease mode
	   if (argument_count > 3) {
	      var action_ease = argument[3];
	   } else {
	      var action_ease = false;
	   }
   
	   //Perform transitions
	   if (ds_button[# prop._trans_time, ds_target] < ds_button[# prop._trans_dur, ds_target]) {
	      sys_trans_perform(ds_button, ds_target, action_ease);
   
      
	      /*
	      FINALIZATION
	      */
         
	      if (ds_button[# prop._trans_time, ds_target] >= ds_button[# prop._trans_dur, ds_target]) {
	         //Clear text surface from memory, if any
	         if (surface_exists(ds_button[# prop._surf, ds_target])) {
	            surface_free(ds_button[# prop._surf, ds_target]);
	         }
 
	         //Clear button state
	         if (button_hover == ds_button[# prop._id, ds_target]) {
	            button_hover = -1; 
	         }
	         if (button_active == ds_button[# prop._id, ds_target]) {
	            button_active = -1;
	         }
         
	         //Remove button from data structure
	         ds_button = sys_grid_delete(ds_button, ds_target);
         
	         //Get number of remaining buttons
	         button_count = ds_grid_height(ds_button);
         
	         //End action when transitions are complete
	         if (ds_target == ds_yindex) {
	            sys_action_term();
	         }
	      }
	   }
            
	   //Continue to next button, if any
	   ds_target -= 1;
	}



}
