/// @function	vngen_do_debug(toggle, [sound]);
/// @param		{boolean}	toggle
/// @param		{sound}		[sound]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_do_debug() {

	/*
	Toggles enabling or disabling debug mode, after which the built-in developer console 
	can be accessed in-game via the tilde (~) key. Optionally also plays a sound on action.

	Debug mode is disabled by default.

	Type 'help' in the developer console in-game to see available functions and commands.

	argument0 = enables, disables, or toggles visibility (boolean/macro) (true/false/toggle)
	argument1 = sets the sound to play when executed (sound) (optional, use no argument for none)

	Example usage: 
	   vngen_do_debug(toggle);
	   vngen_do_debug(true, snd_input);
	*/

	//Skip action if debug console is open
	if (global.cmd_visible == true) {
	   exit;
	}

	//Get input command
	var arg_cmd = argument[0];

	//Use toggle, if enabled
	if (arg_cmd == toggle) {
	   arg_cmd = !global.vg_debug;
	}

	//If debug mode is disabled...
	if (global.vg_debug == false) and (arg_cmd != false) {
	   //Enable debug mdoe
	   global.vg_debug = true;
      
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

	//If debug mode is enabled...
	if (global.vg_debug == true) and (arg_cmd != true) {
	   //Disable debug mdoe
	   global.vg_debug = false;
      
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


}
