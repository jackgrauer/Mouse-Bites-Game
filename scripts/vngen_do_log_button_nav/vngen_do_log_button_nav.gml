/// @function	vngen_do_log_button_nav(amount);
/// @param		{integer}	amount
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_do_log_button_nav(argument0) {

	/*
	Navigates through a linear list of log buttons by the amount specified, if log
	buttons currently exist. 'Amount' refers to the number of buttons, where negative 
	values scroll up and  positive values scroll down. Buttons will be sorted by 
	z-index, which if left unmodified will be sorted by **reverse** creation order. 

	This is NOT the same as vngen_do_log_nav, which navigates the backlog itself.

	Note that log buttos are not restricted to a certain display order, and therefore 
	incorrect button settings can result in unexpected navigation with this script.

	argument0 = number of buttons to scroll (integer)

	Example usage:
	   vngen_do_log_button_nav(1);
	   vngen_do_log_button_nav(-1);
	*/

	//Skip action if debug console is open
	if (global.cmd_visible == true) {
	   exit;
	}

	//Skip if backlog is closed
	if (global.vg_log_visible == false) {
	   exit;
	}

	//Skip action if buttons do not currently exist
	if (!vngen_exists(any, vngen_type_button)) {
	   exit;
	}

	//If a selection hasn't been made...
	if (button_active == -1) {
	   //Initialize temporary variables for checking button slot
	   var ds_yindex;
	   var button_index = argument0;
   
	   //If no other button is hovered...
	   if (button_hover == -1) {
	      //Start selection on the first button
	      if (argument0 > 0) {
	         button_index -= 1;
	      }
	   } else {
	      //Otherwise get current button slot
	      ds_yindex = vngen_get_index(button_hover, vngen_type_button);
      
	      //Set starting index
	      if (!is_undefined(ds_yindex)) {
	         button_index += ds_yindex;
	      }
	   }
   
	   //Loop buttons if selection exceeds button quantity
	   if (button_index > button_count - 1) or (button_index < 0) {
	      button_index -= button_count*floor(button_index/button_count);
	   }
      
	   //Get button ID
	   button_hover = global.ds_log_button[# prop._id, button_index];
      
	   //Disallow undefined results
	   if (is_undefined(button_hover)) {
	      button_hover = -1;
	   } else {
	      //Reset sprite animations for the selected button
	      global.ds_log_button[# prop._index, button_index] = 0;
	   }

	   //Play select sound, if any
	   if (audio_exists(global.ds_log_button[# prop._snd_hover, button_index])) {
	      var snd = audio_play_sound(global.ds_log_button[# prop._snd_hover, button_index], 0, false);
		  audio_sound_gain(snd, global.vg_vol_ui, 0);
	   }
	}


}
