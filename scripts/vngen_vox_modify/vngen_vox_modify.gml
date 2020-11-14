/// @function	vngen_vox_modify(name, pitch_min, pitch_max, volume, duration, [ease]);
/// @param		{string|macro}	name
/// @param		{real}			pitch_min
/// @param		{real}			pitch_max
/// @param		{real}			volume
/// @param		{real}			duration
/// @param		{integer|macro}	[ease]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_vox_modify() {

	/*
	Modifies existing speech synthesis with pitch and volume adjustments.

	Pitch will be automatically randomized between min/max values.

	argument0 = identifier or character name associated with the target sound (string) (or keyword 'all' for all)
	argument1 = the minimum pitch octave multiplier, where a value of 1 is default (real) (0-255)
	argument2 = the maximum pitch octave multiplier, where a value of 1 is default (real) (0-255)
	argument3 = the sound volume, where a value of 1 equals 100% (real) (0-1)
	argument4 = sets the length of the modification transition, in seconds (real)
	argument5 = sets the transition easing method (see interp for available modes) (integer) (can also use true/false) (optional, use no argument for none)

	Example usage:
	   vngen_event() {
	      vngen_vox_modify("John Doe", 1, 0.75, 1);
	      vngen_vox_modify("Jane Doe", 1, 0.75, 1, true);
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
	      if (argument[0] == all) {
	         //Modify all vox, if enabled
	         var ds_target = sys_grid_last(ds_vox);
	         var ds_yindex = 0;
	      } else {
	         //Otherwise get single vox to modify
	         var ds_target = vngen_get_index(argument[0], vngen_type_vox);
	         var ds_yindex = ds_target;
	      } 
   
	      //If the target vox exists...
	      if (!is_undefined(ds_target)) {
	         while (ds_target >= ds_yindex) { 
	            //Backup original values to temp value slots
	            ds_vox[# prop._tmp_pitch_min, ds_target] = ds_vox[# prop._snd_pitch_min, ds_target]; //Pitch minimum
	            ds_vox[# prop._tmp_pitch_max, ds_target] = ds_vox[# prop._snd_pitch_max, ds_target]; //Pitch maximum
	            ds_vox[# prop._tmp_vol, ds_target] = ds_vox[# prop._snd_vol, ds_target];             //Volume
            
	            //Set transition time
	            if (argument[4] > 0) {
	               ds_vox[# prop._tmp_time, ds_target] = 0;  //Time
	            } else {
	               ds_vox[# prop._tmp_time, ds_target] = -1; //Time
	            }      
            
	            //Continue to next sound, if any
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
	   //Modify all vox, if enabled
	   var ds_target = sys_grid_last(ds_vox);
	   var ds_yindex = 0;
	} else {
	   //Otherwise get single vox to modify
	   var ds_target = vngen_get_index(argument[0], vngen_type_vox);
	   var ds_yindex = ds_target;
	} 

	//Skip action if target vox does not exist
	if (is_undefined(ds_target)) {
	   exit;
	}


	/*
	PERFORM MODIFICATIONS
	*/

	while (ds_target >= ds_yindex) { 
	   //Increment transition time
	   if (ds_vox[# prop._tmp_time, ds_target] < argument[4]) {
	      if (!sys_action_skip()) {
	         ds_vox[# prop._tmp_time, ds_target] += time_frame;
	      } else {
	         //Otherwise skip transition if vngen_do_continue is run
	         ds_vox[# prop._tmp_time, ds_target] = argument[4];
	      }
      
	      //Mark this action as complete
	      if (ds_vox[# prop._tmp_time, ds_target] < 0) or (ds_vox[# prop._tmp_time, ds_target] >= argument[4]) { 
	         //Disallow exceeding target values
	         ds_vox[# prop._snd_pitch_min, ds_target] = argument[1]; //Pitch minimum
	         ds_vox[# prop._snd_pitch_min, ds_target] = argument[2]; //Pitch maximum
	         ds_vox[# prop._snd_vol, ds_target] = argument[3];       //Volume
	         ds_vox[# prop._tmp_time, ds_target] = argument[4];      //Time
         
	         //End action
	         if (ds_target == ds_yindex) {
	            sys_action_term();
            
	            //Continue to next vox, if any
	            ds_target -= 1;
	            continue;
	         } 
	      }   
	   } else {
	      //Do not process when transitions are complete
	      ds_target -= 1;
	      continue;
	   }
   
	   //If duration is greater than 0...
	   if (argument[4] > 0) {
	      //Get ease mode
	      if (argument_count == 5) {
	         var action_ease = argument[5];
	      } else {
	         var action_ease = true;
	      }
         
	      //Get transition time
	      var action_time = interp(0, 1, ds_vox[# prop._tmp_time, ds_target]/argument[4], action_ease);
   
	      //Perform audio modifications
	      ds_vox[# prop._snd_pitch_min, ds_target] = lerp(ds_vox[# prop._tmp_pitch_min, ds_target], argument[1], action_time); //Pitch minimum
	      ds_vox[# prop._snd_pitch_max, ds_target] = lerp(ds_vox[# prop._tmp_pitch_max, ds_target], argument[2], action_time); //Pitch maximum
	      ds_vox[# prop._snd_vol, ds_target] = lerp(ds_vox[# prop._tmp_vol, ds_target], argument[3], action_time);             //Volume
	   }
            
	   //Continue to next sound, if any
	   ds_target -= 1;
	}


}
