/// @function	vngen_audio_replace(id, sound, [fade], [ease]);
/// @param		{real|string}	id
/// @param		{sound}			sound
/// @param		{real}			[fade]
/// @param		{integer|macro}	[ease]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_audio_replace() {

	/*
	Replaces the given sound with a new sound, maintaining playback position
	and other properties.

	As this script is itself treated as an action, it is only practical to
	replace looped sound effects and music.

	argument0 = identifier or character name associated with the target sound (real or string)
	argument1 = the new sound resource to play (sound)
	argument2 = the length of time to transition from one sound to the other, in seconds (real) (optional, use no argument for none)
	argument3 = sets the fade easing method (see interp for available modes) (integer) (can also use true/false) (optional, use no argument for none)

	Example usage:
	   vngen_event() {
	      vngen_audio_replace("music", music_intense);
	      vngen_audio_replace("music", music_intense, 2, true);
	   }
	*/

	/*
	INITIALIZATION
	*/

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
	      //Get audio slot
	      var ds_target = vngen_get_index(argument[0], vngen_type_audio);
   
	      //If the target sound exists...
	      if (!is_undefined(ds_target)) {
	         //Get loop mode
	         if (is_odd(ds_audio[# prop._type, ds_target])) {
	            var action_loop = true;
	         } else {
	            var action_loop = false;
	         }
         
	         //Set sound values
	         ds_audio[# prop._fade_src, ds_target] = ds_audio[# prop._snd, ds_target];                                               //Fade sound
	         ds_audio[# prop._fade_vol, ds_target] = 0;                                                                              //Fade volume
	         ds_audio[# prop._snd, ds_target] = audio_play_sound(argument[1], 1, action_loop);                                       //Sound   
	         ds_audio[# prop._event, ds_target] = event_current;                                                                     //Starting event
	         ds_audio[# prop._snd_dur, ds_target] = audio_sound_length(argument[1]);                                                 //Length
	         ds_audio[# prop._snd_end, ds_target] = min(ds_audio[# prop._snd_end, ds_target], ds_audio[# prop._snd_dur, ds_target]); //End 
            
	         //Synchronize audio properties
	         audio_sound_set_track_position(ds_audio[# prop._snd, ds_target], min(ds_audio[# prop._snd_pos, ds_target], ds_audio[# prop._snd_dur, ds_target] - 0.05));
	         audio_sound_pitch(ds_audio[# prop._snd, ds_target], ds_audio[# prop._snd_pitch, ds_target]);
         
	         //Begin silent and fade new sound in, if enabled
	         if (action_fade > 0) {
	            audio_sound_gain(ds_audio[# prop._snd, ds_target], 0.01, 0);
	            ds_audio[# prop._fade_time, ds_target] = 0;  //Time
	         } else {
	            ds_audio[# prop._fade_time, ds_target] = -1; //Time
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
	var ds_target = vngen_get_index(argument[0], vngen_type_audio);

	//Skip action if target audio does not exist
	if (is_undefined(ds_target)) {
	   exit;
	}


	/*
	PERFORM REPLACEMENT
	*/

	//Increment transition time
	if (ds_audio[# prop._fade_time, ds_target] < action_fade) {
	   if (!sys_action_skip()) {      
	      //Increment fade transition
	      ds_audio[# prop._fade_time, ds_target] += time_frame; 
	   } else {
	      //Otherwise skip fade if vngen_do_continue is run
	      ds_audio[# prop._fade_time, ds_target] = action_fade;
	   } 

	   //Mark this action as complete when fade has finished
	   if (ds_audio[# prop._fade_time, ds_target] < 0) or (ds_audio[# prop._fade_time, ds_target] >= action_fade) { 
	      //Get sound type
		  var action_vol = global.vg_vol_sound;        //SFX
		  switch (ds_audio[# prop._type, ds_target]) {
		     case 2: action_vol = global.vg_vol_voice; //Voice
	         case 3: action_vol = global.vg_vol_music; //Music
	         case 6: action_vol = global.vg_vol_voice; //Voice paused
		     case 7: action_vol = global.vg_vol_music; //Music paused
		  }
	  
	      //Disallow exceeding target values
	      ds_audio[# prop._fade_time, ds_target] = action_fade;                                                   //Time
	      audio_sound_gain(ds_audio[# prop._snd, ds_target], ds_audio[# prop._snd_vol, ds_target]*action_vol, 0); //Volume
      
	      //Reset old sound volume
	      audio_sound_gain(ds_audio[# prop._fade_src, ds_target], 1, 0);
      
	      //Reset old sound pitch
	      audio_sound_pitch(ds_audio[# prop._fade_src, ds_target], 1);
      
	      //Stop old sound
	      audio_stop_sound(ds_audio[# prop._fade_src, ds_target]);
	      ds_audio[# prop._fade_src, ds_target] = -1;
      
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
	   var action_time = interp(0, 1, ds_audio[# prop._fade_time, ds_target]/action_fade, action_ease);
   
	   //Get sound type
	   var action_vol = global.vg_vol_sound;        //SFX
	   switch (ds_audio[# prop._type, ds_target]) {
		  case 2: action_vol = global.vg_vol_voice; //Voice
	      case 3: action_vol = global.vg_vol_music; //Music
	      case 6: action_vol = global.vg_vol_voice; //Voice paused
		  case 7: action_vol = global.vg_vol_music; //Music paused
	   }  
   
	   //Perform audio modifications
	   ds_audio[# prop._fade_vol, ds_target] = lerp(0, ds_audio[# prop._snd_vol, ds_target], action_time);

	   //Fade between sounds, if enabled
	   audio_sound_gain(ds_audio[# prop._snd, ds_target], ds_audio[# prop._fade_vol, ds_target]*action_vol, 0);                                               //New sound
	   audio_sound_gain(ds_audio[# prop._fade_src, ds_target], (ds_audio[# prop._snd_vol, ds_target] - ds_audio[# prop._fade_vol, ds_target])*action_vol, 0); //Old sound
	}



}
