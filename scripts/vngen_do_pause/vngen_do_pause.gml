/// @function	vngen_do_pause(toggle, [sound]);
/// @param		{boolean}	toggle
/// @param		{sound}		[sound]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_do_pause() {

	/*
	Toggles pausing most VNgen elements, except for buttons. Optionally
	also plays a sound on action.

	Designed for use in global mouse, keyboard, or gamepad input events.

	argument0 = enables, disables, or toggles pausing (boolean/macro) (true/false/toggle)
	argument1 = sets the sound to play when executed (sound) (optional, use no argument for none)

	Example usage:
	   vngen_do_pause(toggle);
	   vngen_do_pause(true, snd_input);
	*/

	//Skip action if debug console is open
	if (global.cmd_visible == true) {
	   exit;
	}

	//Get input command
	var arg_cmd = argument[0];

	//Use toggle, if enabled
	if (arg_cmd == toggle) {
	   arg_cmd = !global.vg_pause;
	}

	//If the engine is not paused...
	if (global.vg_pause == false) and (arg_cmd != false) {
	   //Pause engine
	   global.vg_pause = true;
      
	   //Play audio, if any
	   if (argument_count > 1) {
	      if (audio_exists(argument[1])) {
	         if (!audio_is_playing(argument[1])) {
	            var snd = audio_play_sound(argument[1], 1, false);
				audio_sound_gain(snd, global.vg_vol_ui, 0);
	         }
	      }      
	   }
	   exit;
	}

	//If the engine is paused...
	if (global.vg_pause == true) and (arg_cmd != true) {
	   //If the log is closed...
	   if (global.vg_log_visible == false) {
	      //Unpause engine
	      global.vg_pause = false;
      
	      //Play audio, if any
	      if (argument_count > 1) {
	         if (audio_exists(argument[1])) {
	            if (!audio_is_playing(argument[1])) {
	               var snd = audio_play_sound(argument[1], 1, false);
				   audio_sound_gain(snd, global.vg_vol_ui, 0);
	            }
	         }
	      }        
	   }
	}


}
