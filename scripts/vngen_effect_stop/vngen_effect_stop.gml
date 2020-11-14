/// @function	vngen_effect_stop(id);
/// @param		{real|string|macro}	id
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_effect_stop(argument0) {

	/*
	Stops a scripted effect, if currently playing. All values modified by the ongoing 
	effect will be smoothly returned to their defaults before stopping.

	argument0 = identifier of the effect to stop (real or string) (or keyword 'all' for all)

	Example usage:
	   vngen_event() {
	      vngen_effect_stop("vibrate");
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
	      //Get effect slot
	      if (argument0 == all) {
	         //Destroy all effects, if enabled
	         var ds_target = sys_grid_last(ds_effect);
	         var ds_yindex = 0;
	      } else {
	         //Otherwise get single effect to destroy
	         var ds_target = vngen_get_index(argument0, vngen_type_effect);
	         var ds_yindex = ds_target;
	      }
         
	      //If the target effect exists...
	      if (!is_undefined(ds_target)) {   
	         while (ds_target >= ds_yindex) {  
	            //Terminate the current effect, if any
	            sys_effect_term(ds_target);
            
	            //Continue to next effect, if any
	            ds_target -= 1;
	         }
	      }  
      
	      //Continue to next action once initialized
	      sys_action_term();     
	   }
	}


}
