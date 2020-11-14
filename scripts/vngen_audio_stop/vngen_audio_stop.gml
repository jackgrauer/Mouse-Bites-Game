/// @function	vngen_audio_stop(id, [fade], [ease]);
/// @param		{real|string|macro}	id
/// @param		{real}				[fade]
/// @param		{integer|macro}		[ease]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_audio_stop() {

	/*
	Stops the given sound of any type with optional fade out parameters.

	As this script is itself treated as an action, it is only practical to
	stop looped sound effects and music.

	argument0 = identifier or character name associated with the target sound (real or string) (or keyword 'all' for all)
	argument1 = the length of time to fade the sound out, in seconds (real) (optional, use no argument for none)
	argument2 = sets the fade easing method (see interp for available modes) (integer) (can also use true/false) (optional, use no argument for none)

	Example usage:
	   vngen_event() {
	      vngen_audio_stop("explode");
	      vngen_audio_stop("explode", 2, true);
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
	      //Get audio slot
	      if (argument[0] == all) {
	         //Destroy all audio, if enabled
	         var ds_target = sys_grid_last(ds_audio);
	         var ds_yindex = 0;
	      } else {
	         //Otherwise get single sound to destroy
	         var ds_target = vngen_get_index(argument[0], vngen_type_audio);
	         var ds_yindex = ds_target;
	      }   
   
	      //If the target sound exists...
	      if (!is_undefined(ds_target)) {
	         while (ds_target >= ds_yindex) { 
	            //Backup original values to temp value slots
	            ds_audio[# prop._tmp_vol, ds_target] = ds_audio[# prop._snd_vol, ds_target]; //Volume
            
	            //Set transition time
	            if (action_fade > 0) {
	               ds_audio[# prop._time, ds_target] = 0;  //Time
	            } else {
	               ds_audio[# prop._time, ds_target] = -1; //Time
	            }      
            
	            //Continue to next sound, if any
	            ds_target -= 1;
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

	//Get audio slot
	if (argument[0] == all) {
	   //Destroy all audio, if enabled
	   var ds_target = sys_grid_last(ds_audio);
	   var ds_yindex = 0;
	} else {
	   //Otherwise get single sound to destroy
	   var ds_target = vngen_get_index(argument[0], vngen_type_audio);
	   var ds_yindex = ds_target;
	}   

	//Skip action if target audio does not exist
	if (is_undefined(ds_target)) {
	   exit;
	}


	/*
	PERFORM TRANSITIONS
	*/

	while (ds_target >= ds_yindex) { 
	   //Increment transition time
	   if (ds_audio[# prop._time, ds_target] < action_fade) {
	      if (!sys_action_skip()) {      
	         //Increment fade transition
	         ds_audio[# prop._time, ds_target] += time_frame; 
	      } else {
	         //Otherwise skip fade if vngen_do_continue is run
	         ds_audio[# prop._time, ds_target] = action_fade;
	      } 
   
	      //Mark this action as complete when fade has finished
	      if (ds_audio[# prop._time, ds_target] < 0) or (ds_audio[# prop._time, ds_target] >= action_fade) { 
	         //Disallow exceeding target values
	         ds_audio[# prop._time, ds_target] = action_fade;
         
	         //End action
	         if (ds_target == ds_yindex) or (is_even(ds_audio[# prop._type, ds_target])) {
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
	      var action_time = interp(0, 1, ds_audio[# prop._time, ds_target]/action_fade, action_ease);
	  
		  //Get sound type
		  var action_vol = global.vg_vol_sound;        //SFX
		  switch (ds_audio[# prop._type, ds_target]) {
	         case 2: action_vol = global.vg_vol_voice; //Voice
			 case 3: action_vol = global.vg_vol_music; //Music
			 case 6: action_vol = global.vg_vol_voice; //Voice paused
			 case 7: action_vol = global.vg_vol_music; //Music paused
		  }
   
	      //Fade sound out, if enabled
	      ds_audio[# prop._snd_vol, ds_target] = lerp(ds_audio[# prop._tmp_vol, ds_target], 0, action_time);
	      audio_sound_gain(ds_audio[# prop._snd, ds_target], ds_audio[# prop._snd_vol, ds_target]*action_vol, 0);    
	   }
   
   
	   /*
	   FINALIZATION
	   */
   
	   //Remove sound from data structure when complete
	   if (ds_audio[# prop._time, ds_target] >= action_fade) {
	      //Disable character speech animations
	      sys_anim_speech(argument[0], false, vngen_type_audio);
       
	      //Stop the sound
	      audio_stop_sound(ds_audio[# prop._snd, ds_target]);
   
	      //Remove sound from data structure
	      ds_audio = sys_grid_delete(ds_audio, ds_target);
	   }
            
	   //Continue to next sound, if any
	   ds_target -= 1;
	}


}
