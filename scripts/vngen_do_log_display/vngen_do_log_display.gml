/// @function	vngen_do_log_display(toggle, [sound]);
/// @param		{boolean|macro}	toggle
/// @param		{sound}			[sound]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_do_log_display() {

	/*
	Toggles showing or hiding the VNgen backlog. Optionally also plays a sound on action.

	Note that the rest of the engine will be paused while the log is displayed.

	Designed for use in global mouse, keyboard, or gamepad input events.

	argument0 = enables, disables, or toggles visibility (boolean/macro) (true/false/toggle)
	argument1 = sets the sound to play when executed (sound) (optional, use no argument for none)

	Example usage:
	   vngen_do_log_display();
	   vngen_do_log_display(toggle);
	   vngen_do_log_display(true, snd_input);
	*/

	//Skip action if debug console is open
	if (global.cmd_visible == true) {
	   exit;
	}

	//Set default input command
	var arg_cmd = toggle;

	//Get input command, if specified
	if (argument_count > 0) {
	   arg_cmd = argument[0];
	}

	//Use toggle, if enabled
	if (arg_cmd == toggle) {
	   arg_cmd = !global.vg_log_visible;
	}

	//If log is closed...
	if (global.vg_log_visible == false) and (arg_cmd != false) {
	   //If the engine is not paused...
	   if (global.vg_pause == false) {
	      //And if the log transition is complete...
	      if (global.vg_log_alpha <= 0) {
	         //Show log
	         global.vg_log_visible = true;
      
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
	      }      
	   }
	   exit;
	}

	//If the log is opened...
	if (global.vg_log_visible == true) and (arg_cmd != true) {
	   //And if the log transition is complete...
	   if (global.vg_log_alpha >= 1) {
	      //Hide log
	      global.vg_log_visible = false;
      
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
