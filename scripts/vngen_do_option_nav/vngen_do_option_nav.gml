/// @function	vngen_do_option_nav(amount);
/// @param		{integer}	amount
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_do_option_nav(argument0) {

	/*
	Navigates through a linear list of options by the amount specified, if options
	are currently active. 'Amount' refers to the number of options, where negative 
	values scroll up and  positive values scroll down. Options will be sorted by 
	z-index, which if left unmodified will be sorted by **reverse** creation order. 

	Note that options are not restricted to a certain display order, and therefore 
	incorrect option settings can result in unexpected navigation with this script.

	argument0 = number of options to scroll (integer)

	Example usage:
	   vngen_do_option_nav(1);
	   vngen_do_option_nav(-1);
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
	if (option_active == -1) {
	   //Initialize temporary variables for checking option slot
	   var ds_yindex;
	   var option_index = argument0;
   
	   //If no other option is hovered...
	   if (option_hover == -1) {
	      //Start selection on the first option
	      if (argument0 > 0) {
	         option_index -= 1;
	      }
	   } else {
	      //Otherwise get current option slot
	      ds_yindex = vngen_get_index(option_hover, vngen_type_option);
      
	      //Set starting index
	      if (!is_undefined(ds_yindex)) {
	         option_index += ds_yindex;
	      }
	   }
   
	   //Loop options if selection exceeds option quantity
	   if (option_index > option_count - 1) or (option_index < 0) {
	      option_index -= option_count*floor(option_index/option_count);
	   }
      
	   //Get option ID
	   option_hover = ds_option[# prop._id, option_index];
      
	   //Disallow undefined results
	   if (is_undefined(option_hover)) {
	      option_hover = -1;
	   } else {
	      //Reset sprite animations for the selected option
	      ds_option[# prop._img_index, option_index] = 0;
	   }

	   //Play hover sound, if any
	   if (audio_exists(option_snd_hover)) {
	      var snd = audio_play_sound(option_snd_hover, 0, false);
		  audio_sound_gain(snd, global.vg_vol_ui, 0);
	   }
	}


}
