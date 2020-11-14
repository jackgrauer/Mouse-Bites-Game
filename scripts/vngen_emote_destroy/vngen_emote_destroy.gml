/// @function	vngen_emote_destroy(id, wait);
/// @param		{real|string|macro}	id
/// @param		{boolean}			wait
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_emote_destroy() {

	/*
	Removes an emote previously created with vngen_emote_create, optionally
	waiting until the animation has completed to destroy it.

	As this script is itself treated as an action, it is only practical to
	destroy looped emotes.

	argument0 = identifier of the emote to be removed (real or string) (or keyword 'all' for all)
	argument1 = enables or disables waiting for the emote animation to complete before destroying (boolean) (true/false)

	Example usage:
	   vngen_event() {
	      vngen_emote_destroy("emote", true);
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
	      //Get emote slot
	      if (argument[0] == all) {
	         //Destroy all emotees, if enabled
	         var ds_target = sys_grid_last(ds_emote);
	         var ds_yindex = 0;
	      } else {
	         //Otherwise get single emote to destroy
	         var ds_target = vngen_get_index(argument[0], vngen_type_emote);
	         var ds_yindex = ds_target;
	      }      
         
	      //If the target emote exists...
	      if (!is_undefined(ds_target)) {   
	         while (ds_target >= ds_yindex) {  
	            //Reset loop count if 'wait' is enabled
				if (argument[1] == true) {
				   ds_emote[# prop._time, ds_target] = 0;
				}
            
	            //Continue to next emote, if any
	            ds_target -= 1;
	         }   
	      } else {
	         //Skip action if emote does not exist
	         sys_action_term();
	         exit;
	      }   
	   }
	}


	/*
	DATA MANAGEMENT
	*/

	//Skip action if engine is paused
	if (global.vg_pause == true) {
	   exit;
	}

	//Get emote slot
	if (argument[0] == all) {
	   //Destroy all emotees, if enabled
	   var ds_target = sys_grid_last(ds_emote);
	   var ds_yindex = 0;
	} else {
	   //Otherwise get single emote to destroy
	   var ds_target = vngen_get_index(argument[0], vngen_type_emote);
	   var ds_yindex = ds_target;
	}   

	//Skip action if target emote does not exist
	if (is_undefined(ds_target)) {
	   exit;
	}


	/*
	DESTROY EMOTES
	*/

	while (ds_target >= ds_yindex) {
	   //Skip animation if vngen_do_continue is run
	   if (sys_action_skip()) {
	      ds_emote[# prop._time, ds_target] = 1;
	   }

	   //End action when animation is complete
	   if (ds_emote[# prop._time, ds_target] >= 1) {
	      //Remove emote from data structure, if not looped
	      ds_emote = sys_grid_delete(ds_emote, ds_target);

	      //End action when destroying is complete
	      if (ds_target == ds_yindex) {
	         sys_action_term();
	      }
	   }

	   //Continue to next emote, if any
	   ds_target -= 1;
	}


}
