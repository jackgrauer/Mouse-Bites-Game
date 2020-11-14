/// @function	vngen_do_continue([sound]);
/// @param		{sound}	[sound]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_do_continue() {

	/*
	Skips the actions in the current event or marks text actions as complete, finishing
	the event. Optionally also plays a sound for feedback. 

	Designed for use in global mouse, keyboard, or gamepad input events.

	argument0 = sound to play on continue (sound) (optional, use no argument for none)

	Example usage: 
	   vngen_do_continue(snd_continue);
	*/

	//Skip action if debug console is open
	if (global.cmd_visible == true) {
	   exit;
	}

	//Skip if engine is paused
	if (global.vg_pause == true) {
	   exit;
	}

	//If UI elements are not visible while UI is locked, force visible
	if (global.vg_ui_visible == false) and (global.vg_ui_lock == true) {
	   global.vg_ui_visible = true;
	   exit;
	}

	//Unpause text elements paused indefinitely in markup
	if (text_pause == true) {
	   text_pause = false;
	   exit;
	}

	//Skip if auto mode is enabled
	if (global.vg_text_auto == true) {
	   if (event_pause > -1) {
	      exit;
	   }
	}

	//Skip if noskip is enabled for the current event
	if (event_noskip == true) {
	   exit;
	}

	//Skip if links, buttons, or options are hovered
	if (mouse_hover == true) {
	   exit;
	}

	//Skip if options are displayed
	if (vngen_exists(any, vngen_type_option)) or (option_pause > 0) {
	   exit;
	}

	//Skip if button is hovered
	if (button_hover != -1) {
	   exit;
	}

	//If actions are not complete, skip ongoing actions
	if (action_complete < action_count) {
	   if (event_current < event_count) {
	      if (!sys_action_skip()) {
	         //Play sound on continue, if any
	         if (argument_count > 0) {
	            var snd = audio_play_sound(argument[0], 0.5, false);
				audio_sound_gain(snd, global.vg_vol_ui, 0);
	         }
      
	         //Skip actions
	         sys_action_skip(true);
	      }/* else {
	         //Fallback, force actions complete if all else fails
	         action_complete = action_count;
	      }*/
	   }
	}

	//Continue text actions
	text_continue = true;


}
