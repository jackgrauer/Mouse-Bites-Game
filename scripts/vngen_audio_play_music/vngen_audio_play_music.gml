/// @function	vngen_audio_play_music(id, sound, volume, fade, [ease], [start, end, full]);
/// @param		{real|string}	id
/// @param		{sound}			sound
/// @param		{real}			volume
/// @param		{real}			fade
/// @param		{integer|macro}	[ease]
/// @param		{real}			[start]
/// @param		{real}			[end]
/// @param		{boolean}		[full]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_audio_play_music() {

	/*
	Plays a looped music track with volume control and real-time loop region
	clipping options.

	Note that looped sounds are NOT treated as an action and the event will
	progress without waiting for the sound to complete. Skipping the current
	event will NOT stop the sound (use vngen_audio_stop).

	This script is intended for playing music only, as separate scripts exist 
	for playing sound effects and voice.

	argument0 = identifier to use for the sound (real or string)
	argument1 = the sound resource to play (sound)
	argument2 = the target sound volume, where a value of 1 equals 100% (real) (0-1)
	argument3 = the length of time to fade the sound in, in seconds (real)
	argument4 = sets the fade easing method (see interp for available modes) (integer) (can also use true/false) (optional, use no argument for none)
	argument5 = the start point to clip the loop region, in seconds (real) (optional, use no argument for none)
	argument6 = the end point to clip the loop region, in seconds (real) (optional, use no argument for none)
	argument7 = enables or disables playing from the beginning before clipping (boolean) (true/false) (optional, use no argument for none)

	Example usage:
	   vngen_event() {
	      vngen_audio_play_music("music", mus_battle, 1, 0.5);
	      vngen_audio_play_music("music", mus_battle, 1, 0.5, false);
	      vngen_audio_play_music("music", mus_battle, 1, 0.5, 5, 20, true);
	      vngen_audio_play_music("music", mus_battle, 1, 0.5, false, 5, 20, true);
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
	      //Get audio slot, if any
	      var ds_target = vngen_get_index(argument[0], vngen_type_audio);
      
	      //If the target audio already exists...
	      if (!is_undefined(ds_target)) {
	         //If the event isn't being skipped...
	         if (event_skip > ds_audio[# prop._event, ds_target]) {
	            //Reinitialize audio instance
	            ds_audio[# prop._snd, ds_target] = audio_play_sound(argument[1], 1, true);
	            audio_sound_set_track_position(ds_audio[# prop._snd, ds_target], ds_audio[# prop._snd_pos, ds_target]); 
			
				//Reinitialize audio volume
	            audio_sound_gain(ds_audio[# prop._snd, ds_target], argument[2]*global.vg_vol_music, 0);
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
	         //Otherwise get the current number of audio entries
	         ds_target = ds_grid_height(ds_audio);
         
	         //Create new audio slot in data structure
	         ds_grid_resize(ds_audio, ds_grid_width(ds_audio), ds_grid_height(ds_audio) + 1);
	      }

	      //Set basic audio properties   
	      ds_audio[# prop._id, ds_target] = argument[0];                                      //ID
	      ds_audio[# prop._snd, ds_target] = audio_play_sound(argument[1], 1, true);          //Sound
	      ds_audio[# prop._type, ds_target] = 3;                                              //Type
	      ds_audio[# prop._event, ds_target] = event_current;                                 //Starting event
	      ds_audio[# prop._snd_dur, ds_target] = audio_sound_length(argument[1]);             //Length
	      ds_audio[# prop._snd_start, ds_target] = 0;                                         //Start
	      ds_audio[# prop._snd_end, ds_target] = ds_audio[# prop._snd_dur, ds_target];        //End   
	      ds_audio[# prop._snd_pos, ds_target] = 0;                                           //Playback position
	      ds_audio[# prop._snd_pitch, ds_target] = 1;                                         //Pitch
      
	      //Set special sound properties
	      ds_audio[# prop._fade_src, ds_target] = -1;                                         //Fade sound    

	      //Begin silent and fade sound in, if enabled
	      if (argument[3] > 0) {
	         audio_sound_gain(ds_audio[# prop._snd, ds_target], 0.01, 0);
	         ds_audio[# prop._snd_vol, ds_target] = 0; //Volume
	         ds_audio[# prop._time, ds_target] = 0;    //Time
	      } else {
	         //Otherwise set volume directly
	         audio_sound_gain(ds_audio[# prop._snd, ds_target], argument[2]*global.vg_vol_music, 0);
	         ds_audio[# prop._snd_vol, ds_target] = argument[2]; //Volume
	         ds_audio[# prop._time, ds_target] = -1;             //Time
	      } 
      
	      //Clip sound, if enabled
	      if (argument_count > 5) {
	         ds_audio[# prop._snd_start, ds_target] = clamp(argument[argument_count - 3], 0, ds_audio[# prop._snd_dur, ds_target] - 0.05); //Start
	         ds_audio[# prop._snd_end, ds_target] = clamp(argument[argument_count - 2], 0.05, ds_audio[# prop._snd_dur, ds_target]);       //End
         
	         //Clip beginning, if enabled
	         if (argument[argument_count - 1] == false) {
	            ds_audio[# prop._snd_pos, ds_target] = ds_audio[# prop._snd_start, ds_target]; //Playback position
            
	            //Set starting playback position
	            audio_sound_set_track_position(ds_audio[# prop._snd, ds_target], ds_audio[# prop._snd_pos, ds_target]);  
	         }  
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
	if (ds_audio[# prop._type, ds_target] != 3) {
	   exit;
	}


	/*
	PERFORM SOUND
	*/

	//Increment fade time
	if (ds_audio[# prop._time, ds_target] < argument[3]) {
	   if (!sys_action_skip()) {
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
	      audio_sound_gain(ds_audio[# prop._snd, ds_target], argument[2]*global.vg_vol_music, 0);
      
	      //End action
	      sys_action_term();
	      exit;
	   }
	} else {
	   //Do not process when transitions are complete
	   exit;
	}

	//If duration is greater than 0...
	if (argument[3] > 0) {
	   //Get ease mode
	   if (argument_count == 5) or (argument_count > 7) {
	      var action_ease = argument[4];
	   } else {
	      var action_ease = true;
	   }
   
	   //Get transition time
	   var action_time = interp(0, 1, ds_audio[# prop._time, ds_target]/argument[3], action_ease);

	   //Perform audio fade
	   ds_audio[# prop._snd_vol, ds_target] = lerp(0, argument[2], action_time);
   
	   //Fade sound in, if enabled
	   audio_sound_gain(ds_audio[# prop._snd, ds_target], ds_audio[# prop._snd_vol, ds_target]*global.vg_vol_music, 0);
	}



}
