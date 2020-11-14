/// @function	vngen_count(type, [name]);
/// @param		{integer|macro}	type
/// @param		{string}		[name]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_count() {

	/*
	Returns the number of VNgen entities of the given type which currently exist.
	Note that in the case of buttons, the result returned will differ based on
	whether the backlog is open or closed.

	argument0 = sets the entity type to check (integer) (or use vngen_type_perspective,
	            vngen_type_scene, vngen_type_char, vngen_type_attach, vngen_type_emote,
	            vngen_type_textbox, vngen_type_text, vngen_type_label, vngen_type_prompt,
	            vngen_type_option, vngen_type_audio, vngen_type_vox, vngen_type_effect,
	            vngen_type_button, or vngen_type_speaker)
	argument1 = name of the parent character to check, if entity is an attachment (string) (optional, use no argument for none)
            
	Example usage:
	   var num = string(vngen_count(2));
   
	   draw_text(x, y, "There are currently " + num + " characters.");
	*/

	//Initialize temporary variables for checking target entity
	var ds_count, ds_data, ds_xindex, ds_yindex;

	//Get target character, if any
	if (argument_count > 1) {
	   var name = argument[1];
	} else {
	   var ds_count = 0;
	   var name = -1;
	}

	//Get data structure for target entity
	switch (argument[0]) {
	   case vngen_type_perspective: ds_data = ds_perspective; break;
	   case vngen_type_scene:       ds_data = ds_scene; break;
	   case vngen_type_char:        ds_data = ds_character; break;
	   case vngen_type_attach:      ds_data = -vngen_type_attach; break;
	   case vngen_type_emote:       ds_data = ds_emote; break;
	   case vngen_type_textbox:     ds_data = ds_textbox; break;
	   case vngen_type_text:        ds_data = ds_text; break;
	   case vngen_type_label:       ds_data = ds_label; break;
	   case vngen_type_prompt:      ds_data = ds_prompt; break;
	   case vngen_type_option:      ds_data = ds_option; break;
	   case vngen_type_audio:       ds_data = ds_audio; break;
	   case vngen_type_vox:         ds_data = ds_vox; break;
	   case vngen_type_effect:      ds_data = ds_effect; break;
	   case vngen_type_button:      ds_data = -vngen_type_button; break;
	   case vngen_type_speaker:     ds_data = -vngen_type_speaker; break;
	   default: return false;
	}

	//Check special entities
	if (ds_data < 0) {
	   //Check speaker names
	   if (ds_data == -vngen_type_speaker) {
	      if (ds_exists(ds_text, ds_type_grid)) {
	         //Return number of speakers
	         return ds_grid_height(ds_text);
	      }
	   }   
   
	   //Check character attachments
	   if (ds_data == -vngen_type_attach) {
	      if (ds_exists(ds_character, ds_type_grid)) {
	         for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_character); ds_yindex += 1) {
	            //If no character was specified...
	            if (name == -1) {
	               //Get number of attachments for each character
	               if (ds_exists(ds_character[# prop._attach_data, ds_yindex], ds_type_grid)) {
	                  ds_count += ds_grid_height(ds_character[# prop._attach_data, ds_yindex]);
	               }
	            } else {
	               //If target character exists (if any)...
	               if (ds_character[# prop._id, ds_yindex] == name) {
	                  if (ds_exists(ds_character[# prop._attach_data, ds_yindex], ds_type_grid)) {
	                     //Return number of attachments for the specified character
	                     return ds_grid_height(ds_character[# prop._attach_data, ds_yindex]);
	                  }
	               }
	            }
	         }
         
	         //Return number of attachments for all characters
	         if (name == -1) {
	            return ds_count;
	         }
	      }
	   }
   
	   //Check buttons
	   if (ds_data == -vngen_type_button) {
	      //Check log buttons
	      if (ds_exists(global.ds_log_button, ds_type_grid)) {
	         if (global.vg_log_visible == true) {
	            //Return number of log buttons
	            return ds_grid_height(global.ds_log_button);
	         }
	      }
      
	      //Check other buttons
	      if (ds_exists(ds_button, ds_type_grid)) {
	         if (global.vg_log_visible == false) {
	            //Return number of buttons
	            return ds_grid_height(ds_button);
	         }
	      }
	   }
   
	//Check other entities
	} else {
	   if (ds_exists(ds_data, ds_type_grid)) {
	      //Return number of entities
	      return ds_grid_height(ds_data);
	   }
	}

	//If target entity is not found, return 0
	return 0;


}
