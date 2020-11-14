/// @function	vngen_do_auto(toggle, [delay], [sound]);
/// @param		{boolean|macro}	toggle
/// @param		{real}			[delay]
/// @param		{sound}			[sound]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_do_auto() {

	/*
	Toggles automatic text progression with an optional delay. Optionally
	also plays a sound on action.

	If only two arguments are supplied, the second argument will be interpreted
	as [delay]. To specify a sound with no delay, the [delay] argument must be
	set to 0.

	Designed for use in global mouse, keyboard, or gamepad input events.

	argument0 = enables, disables, or toggles automatic progression (boolean/macro) (true/false/toggle)
	argument1 = sets the delay before continuing, in seconds (real) (optional, use no argument for none)
	argument2 = sound to play on toggle (sound) (optional, use no argument for none)

	Example usage:
	   vngen_do_auto(toggle);
	   vngen_do_auto(true, 3);
	   vngen_do_auto(false, 0, snd_input);
	*/

	//Skip action if debug console is open
	if (global.cmd_visible == true) {
	   exit;
	}

	//Skip if engine is paused
	if (global.vg_pause == true) {
	   exit;
	}

	//Skip if options are active
	if (vngen_exists(any, vngen_type_option)) {
	   exit;
	}

	//Skip if event skipping is disabled
	if (event_noskip == true) {
	   exit;
	}

	//Get input command
	var arg_cmd = argument[0];

	//Use toggle, if enabled
	if (arg_cmd == toggle) {
	   arg_cmd = !global.vg_text_auto;
	}

	//If automatic progression is disabled...
	if (global.vg_text_auto == false) and (arg_cmd != false) {
	   //Enable auto mode
	   global.vg_text_auto = true;
   
	   //Reset auto delay
	   global.vg_text_auto_pause = 0;
	   global.vg_text_auto_current = 0;
   
	   //Set auto delay, if any
	   if (argument_count > 1) {
	      global.vg_text_auto_pause = argument[1];
   
	      //Skip initial delay if text doesn't exist
	      if (!vngen_exists(any, ds_text)) {
	         global.vg_text_auto_current = argument[1];
	      }
	   }
      
	   //Play audio, if any
	   if (argument_count > 2) {
	      if (audio_exists(argument[2])) {
	         if (!audio_is_playing(argument[2])) {
	            var snd = audio_play_sound(argument[2], 1, false);
				audio_sound_gain(snd, global.vg_vol_ui, 0);
	         }
	      }      
	   }
	   exit;
	}

	//If automatic progression is enabled...
	if (global.vg_text_auto == true) and (arg_cmd != true) {
	   //Disable auto mode
	   global.vg_text_auto = false;
   
	   //Reset auto delay
	   global.vg_text_auto_pause = 0;
	   global.vg_text_auto_current = 0;
      
	   //Play audio, if any
	   if (argument_count > 2) {
	      if (audio_exists(argument[2])) {
	         if (!audio_is_playing(argument[2])) {
	            var snd = audio_play_sound(argument[2], 1, false);
				audio_sound_gain(snd, global.vg_vol_ui, 0);
	         }
	      }      
	   }
	}


}
