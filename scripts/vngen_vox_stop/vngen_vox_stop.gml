/// @function	vngen_vox_stop(name, [fade], [ease]);
/// @param		{string|macro}	name
/// @param		{real}			[fade]
/// @param		{integer|macro}	[ease]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_vox_stop() {

	/*
	Stops the given speech synthesis sound with optional fade out parameters.

	argument0 = identifier or character name associated with the target sound (string) (or keyword 'all' for all)
	argument1 = the length of time to fade the sound out, in seconds (real) (optional, use no argument for none)
	argument2 = sets the fade easing method (see interp for available modes) (integer) (can also use true/false) (optional, use no argument for none)

	Example usage:
	   vngen_event() {
	      vngen_vox_stop("John Doe");
	      vngen_vox_stop("John Doe", 2);
	      vngen_vox_stop("John Doe", 2, true);
	   }
	*/

	/*
	INITIALIZATION
	*/

	//Get fade time, if any
	if (argument_count > 1) {
	   var action_fade = argument[1];
	} else {
	   var action_fade = 0;
	}

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
	         //Destroy all vox, if enabled
	         var ds_target = sys_grid_last(ds_vox);
	         var ds_yindex = 0;
	      } else {
	         //Otherwise get single vox to destroy
	         var ds_target = vngen_get_index(argument[0], vngen_type_vox);
	         var ds_yindex = ds_target;
	      }   
   
	      //If the target vox exists...
	      if (!is_undefined(ds_target)) {
	         while (ds_target >= ds_yindex) { 
	            //Backup original values to temp value slots
	            ds_vox[# prop._tmp_vol, ds_target] = ds_vox[# prop._snd_vol, ds_target]; //Volume
            
	            //Set transition time
	            if (action_fade > 0) {
	               ds_vox[# prop._time, ds_target] = 0;  //Time
	            } else {
	               ds_vox[# prop._time, ds_target] = -1; //Time
	            }      
            
	            //Continue to next vox, if any
	            ds_target -= 1;
	         }
	      } else {
	         //Skip action if vox does not exist
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

	//Get vox slot
	if (argument[0] == all) {
	   //Destroy all vox, if enabled
	   var ds_target = sys_grid_last(ds_vox);
	   var ds_yindex = 0;
	} else {
	   //Otherwise get single vox to destroy
	   var ds_target = vngen_get_index(argument[0], vngen_type_vox);
	   var ds_yindex = ds_target;
	}    

	//Skip action if target vox does not exist
	if (is_undefined(ds_target)) {
	   exit;
	}


	/*
	PERFORM TRANSITIONS
	*/

	while (ds_target >= ds_yindex) { 
	   //Increment transition time
	   if (ds_vox[# prop._time, ds_target] < action_fade) {
	      if (!sys_action_skip()) {      
	         ds_vox[# prop._time, ds_target] += time_frame; 
	      } else {
	         //Otherwise skip transition if vngen_do_continue is run
	         ds_vox[# prop._time, ds_target] = action_fade;
	      } 
   
	      //Mark this action as complete when time is complete
	      if (ds_vox[# prop._time, ds_target] < 0) or (ds_vox[# prop._time, ds_target] >= action_fade) { 
	         //Disallow exceeding target values
	         ds_vox[# prop._time, ds_target] = action_fade; //Time
         
	         //End action
	         if (ds_target == ds_yindex) {
	            sys_action_term();
	         }
	      }  
	   }
   
	   //If duration is greater than 0...
	   if (action_fade > 0) {
	      //Get ease mode
	      if (argument_count > 2) {
	         var action_ease = argument[2];
	      } else {
	         var action_ease = true;
	      }
      
	      //Get transition time
	      var action_time = interp(0, 1, ds_vox[# prop._time, ds_target]/action_fade, action_ease);
   
	      //Fade sound out, if enabled
	      ds_vox[# prop._snd_vol, ds_target] = lerp(ds_vox[# prop._tmp_vol, ds_target], 0, action_time);
	   }
   
   
	   /*
	   FINALIZATION
	   */
   
	   //Remove vox from data structure when complete
	   if (ds_vox[# prop._time, ds_target] >= action_fade) {      
	      //Clear vox from memory
	      if (ds_exists(ds_vox[# prop._snd, ds_target], ds_type_list)) {
	         ds_list_destroy(ds_vox[# prop._snd, ds_target]);
	      }
      
	      //Clear fade vox data from memory
	      if (ds_exists(ds_vox[# prop._fade_src, ds_target], ds_type_list)) {
	         ds_list_destroy(ds_vox[# prop._fade_src, ds_target]);
	      }  
   
	      //Remove vox from data structure
	      ds_vox = sys_grid_delete(ds_vox, ds_target);
	   }
            
	   //Continue to next vox, if any
	   ds_target -= 1;
	}


}
