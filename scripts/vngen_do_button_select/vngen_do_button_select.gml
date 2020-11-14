/// @function	vngen_do_button_select([id]);
/// @param		{real|string}	[id]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_do_button_select() {

	/*
	Manually selects the current or specified button, playing the select 
	sound defined on button create, if any. Intended for use with keyboard 
	and gamepad input events.

	Note that this script does not need to be run in mouse input events, as
	they are handled automatically.

	argument0 = the button ID to select (real or string) (optional, use no argument for current button)

	Example usage:
	   if (keyboard_check_released(vk_enter)) {
	      vngen_do_button_select();
	   }
	   if (keyboard_check_released(ord("L"))) {
	      vngen_do_button_select("backlog");
	   }
	*/

	//Skip action if debug console is open
	if (global.cmd_visible == true) {
	   exit;
	}

	//Skip if backlog is open
	if (global.vg_log_visible == true) {
	   exit;
	}

	//Skip action if buttons do not currently exist
	if (!vngen_exists(any, vngen_type_button)) {
	   exit;
	}

	//If a selection hasn't been made...
	if (button_active == -1) {
	   //Select specific option, if supplied
	   if (argument_count > 0) {
	      if (vngen_exists(argument[0], vngen_type_button)) {
	         button_hover = argument[0];
	      } else {
	         //Otherwise skip if button does not exist
	         exit;
	      }
	   }
   
	   //If a button is currently hovered...
	   if (button_hover != -1) {
	      //Select the current button
	      button_active = button_hover;
	      button_result = button_hover;
      
	      //Get button index
	      var ds_target = vngen_get_index(button_hover, vngen_type_button);
      
	      //Play select sound, if any
		  if (!is_undefined(ds_target)) {
	         if (audio_exists(ds_button[# prop._snd_select, ds_target])) {
	            var snd = audio_play_sound(ds_button[# prop._snd_select, ds_target], 0, false);
				audio_sound_gain(snd, global.vg_vol_ui, 0);
	         }
		  }
	   }
	}


}
