/// @function	vngen_do_ui_display(toggle, [stop], [sound]);
/// @param		{boolean}	toggle
/// @param		{boolean}	[stop]
/// @param		{sound}		[sound]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_do_ui_display() {

	/*
	Toggles showing or hiding UI-level VNgen elements, such as textboxes, text,
	buttons, and options. Optionally also plays a sound on action.

	By default, hiding UI elements will prevent progression until the UI is
	unhidden. However, this behavior can be disabled by setting the [stop]
	argument to 'false'.

	If only two arguments are supplied, the second argument will be interpreted
	as [stop] if 'true' or 'false', or [sound] if otherwise.

	Designed for use in global mouse, keyboard, or gamepad input events.

	argument0 = enables, disables, or toggles visibility (boolean/macro) (true/false/toggle)
	argument1 = enables or disables stopping VNgen progress while UI is hidden (boolean) (true/false) (optional, use no argument for 'true')
	argument2 = sets the sound to play when executed (sound) (optional, use no argument for none)

	Example usage:
	   vngen_do_ui_display(toggle);
	   vngen_do_ui_display(false, true);
	   vngen_do_ui_display(false, snd_input);
	   vngen_do_ui_display(true, false, snd_input);
	*/

	//Skip action if debug console is open
	if (global.cmd_visible == true) {
	   exit;
	}

	//Skip if engine is paused
	if (global.vg_pause == true) {
	   exit;
	}

	//Get input command
	var arg_cmd = argument[0];

	//Use toggle, if enabled
	if (arg_cmd == toggle) {
	   arg_cmd = !global.vg_ui_visible;
	}
      
	//Get input sound to play, if any
	var arg_snd = argument[argument_count - 1];

	//If UI is not visible...
	if (global.vg_ui_visible == false) and (arg_cmd != false) {
	   //Show UI elements
	   global.vg_ui_visible = true;
      
	   //Play audio, if any
	   if (argument_count > 1) {
	      if (arg_snd > 1) or (argument_count > 2) {
	         if (audio_exists(arg_snd)) {
	            if (!audio_is_playing(arg_snd)) {
	               var snd = audio_play_sound(arg_snd, 1, false); 
				   audio_sound_gain(snd, global.vg_vol_ui, 0);
	            }
	         }
	      }
	   }
	   exit;
	}

	//If UI is visible...
	if (global.vg_ui_visible == true) and (arg_cmd != true) {
	   //Hide UI elements
	   global.vg_ui_visible = false;
      
	   //Set UI lock state, if specified
	   if (argument_count > 1) {
	      if (argument[1] < 2) {
	         global.vg_ui_lock = argument[1]; 
	      }
	   }
      
	   //Play audio, if any
	   if (argument_count > 1) {
	      if (arg_snd > 1) or (argument_count > 2) {
	         if (audio_exists(arg_snd)) {
	            if (!audio_is_playing(arg_snd)) {
	               var snd = audio_play_sound(arg_snd, 1, false);
				   audio_sound_gain(snd, global.vg_vol_ui, 0);
	            }
	         }
	      }
	   }
	   exit;
	}


}
