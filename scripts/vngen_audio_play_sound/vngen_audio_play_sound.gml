/// @function	vngen_audio_play_sound(id, sound, volume, fade, [ease], [loop]);
/// @param		{real|string}	id
/// @param		{sound}			sound
/// @param		{real}			volume
/// @param		{real}			fade
/// @param		{integer|macro}	[ease]
/// @param		{boolean}		[loop]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_audio_play_sound() {

	/*
	Plays a new sound effect with basic volume control and loop options and
	the given fade in time.

	Note that non-looped sounds are treated as an action and will prevent the
	event from progressing until the sound is complete. Skipping the current
	event will stop the sound. 

	Looped sounds are NOT treated as an action and the event will progress 
	without waiting for the sound to complete. Skipping the current event will 
	NOT stop the sound (use vngen_audio_stop).

	This script is intended for playing sound effects only, as separate
	scripts exist for playing music and voice.

	argument0 = identifier to use for the sound (real or string)
	argument1 = the sound resource to play (sound)
	argument2 = the target sound volume, where a value of 1 equals 100% (real) (0-1)
	argument3 = the length of time to fade the sound in, in seconds (real)
	argument4 = sets the fade easing method (see interp for available modes) (integer) (can also use true/false) (optional, use no argument for none)
	argument5 = enables or disables looping the sound (boolean) (true/false) (optional, use no argument for none)

	Example usage:
	   vngen_event() {
	      vngen_audio_play_sound("explode", snd_explosion, 1, 0, false, false);
	   }
	*/

	/*
	INITIALIZATION
	*/

	//Get loop mode
	if (argument_count > 5) {
	   var action_loop = argument[5];
	} else {
	   var action_loop = false;
	}

	//Enable action, if active
	switch (sys_action_init()) {
	   //Exit if event is inactive
	   case false: {
	      exit;
	   }
      
	   //Initialize action if active
	   case true: {
	      //Get audio slot, if any
	      var ds_target = vngen_get_index(argument[0], vngen_type_audio);
      
	      //If the target audio already exists...
	      if (!is_undefined(ds_target)) and (action_loop == true) {
	         //If the event isn't being skipped...
	         if (event_skip > ds_audio[# prop._event, ds_target]) {
	            //Reinitialize audio instance
	            ds_audio[# prop._snd, ds_target] = audio_play_sound(argument[1], 1, true);
	            audio_sound_set_track_position(ds_audio[# prop._snd, ds_target], ds_audio[# prop._snd_pos, ds_target]); 
			
	            //Reinitialize audio volume
	            audio_sound_gain(ds_audio[# prop._snd, ds_target], argument[2]*global.vg_vol_sound, 0);
	            ds_audio[# prop._snd_vol, ds_target] = argument[2]; //Volume
	            ds_audio[# prop._time, ds_target] = -1;             //Time
            
	            //End the action
	            sys_action_term();
	            exit;
	         } else {
	            //Otherwise stop the existing sound if the event is being skipped
	            if (audio_exists(ds_audio[# prop._snd, ds_target])) {
	               audio_stop_sound(ds_audio[# prop._snd, ds_target]);
	            }
	         }
	      } else {
	         //Skip action if event skip is active and sound is not looped
	         if (sys_event_skip()) {
	            if (action_loop == false) {
	               sys_action_term();
	               exit;
	            }
	         }
      
	         //Otherwise get the current number of audio entries
	         ds_target = ds_grid_height(ds_audio);
      
	         //Create new audio slot in data structure
	         ds_grid_resize(ds_audio, ds_grid_width(ds_audio), ds_grid_height(ds_audio) + 1);
	      }
   
	      //Set basic audio properties
	      ds_audio[# prop._id, ds_target] = argument[0];                                         //ID
	      ds_audio[# prop._snd, ds_target] = audio_play_sound(argument[1], 1, action_loop);      //Sound
	      ds_audio[# prop._type, ds_target] = action_loop;                                       //Type
	      ds_audio[# prop._event, ds_target] = event_current;                                    //Starting event
	      ds_audio[# prop._snd_dur, ds_target] = audio_sound_length(argument[1]);                //Length
	      ds_audio[# prop._snd_start, ds_target] = 0;                                            //Start
	      ds_audio[# prop._snd_end, ds_target] = ds_audio[# prop._snd_dur, ds_target];           //End 
	      ds_audio[# prop._snd_pos, ds_target] = 0;                                              //Playback position
	      ds_audio[# prop._snd_pitch, ds_target] = 1;                                            //Pitch
      
	      //Set special sound properties
	      ds_audio[# prop._fade_src, ds_target] = -1;                                            //Fade sound    
   
	      //Begin silent and fade sound in, if enabled
	      if (argument[3] > 0) {
	         audio_sound_gain(ds_audio[# prop._snd, ds_target], 0.01, 0);
	         ds_audio[# prop._snd_vol, ds_target] = 0; //Volume
	         ds_audio[# prop._time, ds_target] = 0;    //Time
	      } else {
	         //Otherwise set volume directly
	         audio_sound_gain(ds_audio[# prop._snd, ds_target], argument[2]*global.vg_vol_sound, 0);
	         ds_audio[# prop._snd_vol, ds_target] = argument[2]; //Volume
	         ds_audio[# prop._time, ds_target] = -1;             //Time
	      } 
	   }
	}
   

	/*
	DATA MANAGEMENT
	*/

	//Get audio slot
	var ds_target = vngen_get_index(argument[0], vngen_type_audio);

	//Skip action if target audio does not exist
	if (is_undefined(ds_target)) {
	   exit;
	}
	if (ds_audio[# prop._type, ds_target] > 1) {
	   exit;
	}


	/*
	PERFORM SOUND
	*/

	//Base action time on sound length, if not looped
	if (action_loop == false) {
	   //Increment fade transition
	   if (!sys_action_skip()) {
	      if (ds_audio[# prop._time, ds_target] < argument[3]) {
	         ds_audio[# prop._time, ds_target] += time_frame;
         
	         //Disallow exceeding target values
	         if (ds_audio[# prop._time, ds_target] > argument[3]) {
	            ds_audio[# prop._time, ds_target] = argument[3];         
	         }
	      }
	   } else {
	      //Otherwise skip if vngen_do_continue is run
	      ds_audio[# prop._snd_pos, ds_target] = ds_audio[# prop._snd_end, ds_target];
	      ds_audio[# prop._time, ds_target] = argument[3];
	   }
   
	   //Mark this action as complete when sound has finished
	   if (ds_audio[# prop._snd_pos, ds_target] >= ds_audio[# prop._snd_end, ds_target]) {      
	      //Ensure the sound has stopped
	      audio_stop_sound(ds_audio[# prop._snd, ds_target]);
   
	      //Remove sound from data structure
	      ds_audio = sys_grid_delete(ds_audio, ds_target);      
   
	      //End action
	      sys_action_term();
	      exit;
	   }

	   //Skip processing if sound is paused
	   if (audio_is_paused(ds_audio[# prop._snd, ds_target])) {
	      exit;
	   }
	} else {
	   //Otherwise base time on fade duration, if looped
	   if (ds_audio[# prop._time, ds_target] < argument[3]) {
	      if (!sys_action_skip()) {
	         //Increment fade transition
	         ds_audio[# prop._time, ds_target] += time_frame;
	      } else {
	         //Otherwise skip fade if vngen_do_continue is run
	         ds_audio[# prop._time, ds_target] = argument[3];
	      }    
   
	      //Mark this action as complete when fade has finished
	      if (ds_audio[# prop._time, ds_target] < 0) or (ds_audio[# prop._time, ds_target] >= argument[3]) {
	         //Disallow exceeding target values
	         ds_audio[# prop._time, ds_target] = argument[3];  
	         ds_audio[# prop._snd_vol, ds_target] = argument[2];
	         audio_sound_gain(ds_audio[# prop._snd, ds_target], argument[2]*global.vg_vol_sound, 0);
      
	         //End action
	         sys_action_term();
	         exit;
	      }
	   } else {
	      //Do not process when transitions are complete
	      exit;
	   }
	}

	//If duration is greater than 0...
	if (argument[3] > 0) {
	   //Get ease mode
	   if (argument_count > 4) {
	      var action_ease = argument[4];
	   } else {
	      var action_ease = true;
	   }
   
	   //Get transition time
	   var action_time = interp(0, 1, ds_audio[# prop._time, ds_target]/argument[3], action_ease);
   
	   //Perform audio fade
	   ds_audio[# prop._snd_vol, ds_target] = lerp(0, argument[2], action_time);

	   //Fade sound in, if enabled
	   audio_sound_gain(ds_audio[# prop._snd, ds_target], ds_audio[# prop._snd_vol, ds_target]*global.vg_vol_sound, 0);
	}



}
