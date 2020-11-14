/// @function	vngen_audio_play_voice(name, sound, volume, fade, [ease], [lang]);
/// @param		{string}		name
/// @param		{sound}			sound
/// @param		{real}			volume
/// @param		{real}			fade
/// @param		{integer|macro}	[ease]
/// @param		{real|string}	[lang]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_audio_play_voice() {

	/*
	Plays a voice line for the specified character with basic volume and fade
	options. Voice lines will be logged to the current event and trigger
	character speaking animations.

	This script can also be made language-specific by adding a sixth argument,
	effectively disabling it if the specified language is not enabled.

	Note that voice sounds are treated as an action and will prevent the
	event from progressing until the sound is complete. Skipping the current
	event will stop the sound.

	This script is intended for playing voiceover only, as separate scripts 
	exist for playing music and sound effects.

	argument0 = the character name associated with the sound (string)
	argument1 = the sound resource to play (sound)
	argument2 = the target sound volume, where a value of 1 equals 100% (real) (0-1)
	argument3 = the length of time to fade the sound in, in seconds (real)
	argument4 = sets the fade easing method (see interp for available modes) (integer) (can also use true/false)
	argument5 = the language flag to be associated with the sound (real or string) (optional, use no argument for none)

	Example usage:
	   vngen_event() {
	      vngen_audio_play_voice("John Doe", snd_voice, 1, 1, true);
	      vngen_audio_play_voice("John Doe", snd_voice, 1, 0, false, "en-US");
	   }
	*/

	/*
	INITIALIZATION
	*/

	//Get input language, if any
	var action_lang = undefined;
	if (argument_count == 5) {
	   if (is_string(argument[4])) {
	      action_lang = argument[4];
	   }
	} else {
	   if (argument_count > 5) {
	      action_lang = argument[5];
	   }
	}

	//Enable action, if active
	switch (sys_action_init()) {
	   //Exit if event is inactive
	   case false: {
	      exit;
	   }
      
	   //Initialize action if active
	   case true: {
	      //Skip action if event skip is active
	      if (sys_event_skip()) {
	         sys_action_term();
	         exit;
	      }
      
	      //Skip action if not in target language, if any
	      if (!is_undefined(action_lang)) {
	         if (global.vg_lang_audio != action_lang) {
	            sys_action_term();     
	            exit;
	         }
	      }
   
	      //Get the current number of audio entries
	      var ds_target = ds_grid_height(ds_audio);
      
	      //Create new audio slot in data structure
	      ds_grid_resize(ds_audio, ds_grid_width(ds_audio), ds_grid_height(ds_audio) + 1);
   
	      //Set basic audio properties   
	      ds_audio[# prop._id, ds_target] = argument[0];                               //Name
	      ds_audio[# prop._snd, ds_target] = audio_play_sound(argument[1], 1, false);  //Sound
	      ds_audio[# prop._type, ds_target] = 2;                                       //Type
	      ds_audio[# prop._event, ds_target] = event_current;                          //Starting event
	      ds_audio[# prop._snd_dur, ds_target] = audio_sound_length(argument[1]);      //Length
	      ds_audio[# prop._snd_start, ds_target] = 0;                                  //Start
	      ds_audio[# prop._snd_end, ds_target] = ds_audio[# prop._snd_dur, ds_target]; //End    
	      ds_audio[# prop._snd_pos, ds_target] = 0;                                    //Playback position
	      ds_audio[# prop._snd_pitch, ds_target] = 1;                                  //Pitch
      
	      //Set special sound properties
	      ds_audio[# prop._fade_src, ds_target] = -1;                                  //Fade sound    
      
	      //Begin silent and fade sound in, if enabled
	      if (argument[3] > 0) {
	         audio_sound_gain(ds_audio[# prop._snd, ds_target], 0.01, 0);
	         ds_audio[# prop._snd_vol, ds_target] = 0;                                 //Volume
	         ds_audio[# prop._time, ds_target] = 0;                                    //Time
	      } else {
	         //Otherwise set volume directly
	         audio_sound_gain(ds_audio[# prop._snd, ds_target], argument[2]*global.vg_vol_voice, 0);
	         ds_audio[# prop._snd_vol, ds_target] = argument[2];                       //Volume
	         ds_audio[# prop._time, ds_target] = -1;                                   //Time
	      }
      
	      //Enable character speech animations
	      sys_anim_speech(argument[0], true, vngen_type_audio);
      
	      //Add voice to the backlog for the current event
	      if (!sys_event_skip()) {
	         vngen_log_add(auto, argument[1]);      
	      }
	   }
	}


	/*
	DATA MANAGEMENT
	*/

	//Skip action if not in target language, if any
	if (!is_undefined(action_lang)) {
	   if (global.vg_lang_audio != action_lang) {    
	      exit;
	   }
	}

	//Get audio slot
	var ds_target = vngen_get_index(argument[0], vngen_type_audio);

	//Skip action if target audio does not exist
	if (is_undefined(ds_target)) {
	   exit;
	}
	if (ds_audio[# prop._type, ds_target] != 2) {
	   exit;
	}


	/*
	PERFORM SOUND
	*/

	//Skip if vngen_do_continue is run
	if (sys_action_skip()) {
	   ds_audio[# prop._snd_pos, ds_target] = ds_audio[# prop._snd_end, ds_target];
	}   

	//Mark this action as complete when sound has finished
	if (ds_audio[# prop._snd_pos, ds_target] >= ds_audio[# prop._snd_end, ds_target]) {     
	   //Disable character speech animations
	   sys_anim_speech(argument[0], false, vngen_type_audio);
   
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

	//Increment fade time
	if (ds_audio[# prop._time, ds_target] < argument[3]) {
	   if (!sys_action_skip()) {
	      //Increment fade transition
	      ds_audio[# prop._time, ds_target] += time_frame;
	   } else {
	      //Otherwise skip fade if vngen_do_continue is run
	      ds_audio[# prop._time, ds_target] = argument[3];
	   }     
   
	   //Disallow exceeding target values
	   if (ds_audio[# prop._time, ds_target] < 0) or (ds_audio[# prop._time, ds_target] >= argument[3]) {
	      ds_audio[# prop._time, ds_target] = argument[3];  
	      audio_sound_gain(ds_audio[# prop._snd, ds_target], argument[2]*global.vg_vol_voice, 0);
	   }
	}

	//If duration is greater than 0...
	if (argument[3] > 0) {
	   //Get ease mode
	   if (argument_count > 4) {
	      if (is_real(argument[4])) {
	         var action_ease = argument[4];
	      } else {
	         var action_ease = true;
	      }
	   } else {
	      var action_ease = true;
	   }
   
	   //Get transition time
	   var action_time = interp(0, 1, ds_audio[# prop._time, ds_target]/argument[3], action_ease);

	   //Fade sound in, if enabled
	   ds_audio[# prop._snd_vol, ds_target] = lerp(0, argument[2], action_time);
	   audio_sound_gain(ds_audio[# prop._snd, ds_target], ds_audio[# prop._snd_vol, ds_target]*global.vg_vol_voice, 0);
	}


}
