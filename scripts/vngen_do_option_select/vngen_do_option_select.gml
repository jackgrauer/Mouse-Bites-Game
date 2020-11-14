/// @function	vngen_do_option_select([id]);
/// @param		{real|string}	[id]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_do_option_select() {

	/*
	Manually selects the current or specified option, if any.

	Note that this script does not need to be run in mouse input events, as
	they are handled automatically.

	argument0 = the option ID to select (optional, use no argument for current option)

	Example usage:
	   if (keyboard_check_released(vk_enter)) {
	      vngen_do_option_select();
	   }
	   if (keyboard_check_released(ord("Y"))) {
	      vngen_do_option_select("yes");
	   }
	*/

	//Skip action if debug console is open
	if (global.cmd_visible == true) {
	   exit;
	}

	//Skip if engine is paused
	if (global.vg_pause == true) {
	   exit;
	}

	//Skip action if options do not currently exist
	if (!vngen_exists(any, vngen_type_option)) {
	   exit;
	}

	//If a selection hasn't been made...
	if (option_result == -1) {
	   //Select specific option, if supplied
	   if (argument_count > 0) {
	      if (vngen_exists(argument[0], vngen_type_option)) {
	         option_hover = argument[0];
	      } else {
	         //Otherwise skip if option does not exist
	         exit;
	      }
	   }
   
	   //If an option is currently hovered...
	   if (option_hover != -1) {
	      //Select the current option
	      option_active = option_hover;
	      option_result = option_hover;

	      //Play select sound, if any
	      if (audio_exists(option_snd_select)) {
	         var snd = audio_play_sound(option_snd_select, 0, false);
			 audio_sound_gain(snd, global.vg_vol_ui, 0);
	      }
	   }
	}


}
