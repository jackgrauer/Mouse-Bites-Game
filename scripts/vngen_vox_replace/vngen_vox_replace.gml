/// @function	vngen_vox_replace(name, sound, [fade], [ease]);
/// @param		{string}		name
/// @param		{sound|array}	sound
/// @param		{real}			[fade]
/// @param		{integer|macro}	[ease]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_vox_replace() {

	/*
	Replaces the given vox with a new sound or array of sounds, maintaining volume 
	and other properties.

	argument0 = identifier or character name associated with the target vox (real or string)
	argument1 = the new sound resource to play (sound or array)
	argument2 = the length of time to transition from one sound to the other, in seconds (real) (optional, use no argument for none)
	argument3 = sets the fade easing method (see interp for available modes) (integer) (can also use true/false) (optional, use no argument for none)

	Example usage:
	   vngen_event() {
	      vngen_vox_replace("John Doe", vox_happy);
	      vngen_vox_replace("John Doe", vox_happy, 2, true);
	   }
	*/

	/*
	INITIALIZATION
	*/

	//Initialize temporary variables for checking vox data
	var a_vox, ds_data, ds_yindex;

	//Get fade time, if any
	if (argument_count > 2) {
	   var action_fade = argument[2];
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
	      var ds_target = vngen_get_index(argument[0], vngen_type_vox);
   
	      //If the target sound exists...
	      if (!is_undefined(ds_target)) {         
	         //Ensure fade vox data structure exists
	         if (!ds_exists(ds_vox[# prop._fade_src, ds_target], ds_type_list)) {
	            ds_vox[# prop._fade_src, ds_target] = ds_list_create();
	         }
         
	         //Get vox data
	         ds_data = ds_vox[# prop._snd, ds_target];
         
	         //Backup original sounds to temp vox list
	         for (ds_yindex = 0; ds_yindex < ds_list_size(ds_data); ds_yindex += 1) {
	            ds_list_add(ds_vox[# prop._fade_src, ds_target], ds_data[| ds_yindex]);
	         } //(Must use loop instead of ds_list_copy due to bug in copy function)
         
	         //Clear original sound list
	         ds_list_clear(ds_vox[# prop._snd, ds_target]);

	         //Add new sound(s) to vox
	         sys_vox_add(ds_vox, ds_target, argument[1]);
         
	         //Set audio properties
	         ds_vox[# prop._fade_vol, ds_target] = 0;      //Fade volume
         
	         //Set transition time
	         if (action_fade > 0) {
	            ds_vox[# prop._fade_time, ds_target] = 0;  //Time
	         } else {
	            ds_vox[# prop._fade_time, ds_target] = -1; //Time
	         }     
	      } else {
	         //Skip action if sound does not exist
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
	var ds_target = vngen_get_index(argument[0], vngen_type_vox);

	//Skip action if target audio does not exist
	if (is_undefined(ds_target)) {
	   exit;
	}


	/*
	PERFORM REPLACEMENT
	*/

	//Increment transition time
	if (ds_vox[# prop._fade_time, ds_target] < action_fade) {
	   if (!sys_action_skip()) {      
	      //Increment fade transition
	      ds_vox[# prop._fade_time, ds_target] += time_frame; 
	   } else {
	      //Otherwise skip fade if vngen_do_continue is run
	      ds_vox[# prop._fade_time, ds_target] = action_fade;
	   } 

	   //Mark this action as complete when fade has finished
	   if (ds_vox[# prop._fade_time, ds_target] < 0) or (ds_vox[# prop._fade_time, ds_target] >= action_fade) { 
	      //Disallow exceeding target values
	      ds_vox[# prop._fade_vol, ds_target] = 1;            //Fade volume
	      ds_vox[# prop._fade_time, ds_target] = action_fade; //Time
      
	      //Clear fade vox from memory
	      if (ds_exists(ds_vox[# prop._fade_src, ds_target], ds_type_list)) {
	         ds_list_destroy(ds_vox[# prop._fade_src, ds_target]);
	      }
	      ds_vox[# prop._fade_src, ds_target] = -1;
      
	      //End action
	      sys_action_term();
	      exit;
	   }  
	} else {
	   //Do not process when transitions are complete
	   exit;
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
	   var action_time = interp(0, 1, ds_vox[# prop._fade_time, ds_target]/action_fade, action_ease);
   
	   //Fade between old and new audio
	   ds_vox[# prop._fade_vol, ds_target] = action_time;
	}


}
