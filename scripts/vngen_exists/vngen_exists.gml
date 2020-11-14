/// @function	vngen_exists(id, type, [name]);
/// @param		{real|string}	id
/// @param		{integer|macro}	type
/// @param		{string}		[name]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_exists() {

	/*
	Checks to see whether the VNgen entity of the given ID and type currently exists
	and returns true or false. Note that in the case of buttons, the result returned 
	will differ based on whether the backlog is open or closed.

	argument0 = ID of the entity to check (real or string) (or -3 for any)
	argument1 = sets the entity type to check (integer) (or use vngen_type_perspective,
	            vngen_type_scene, vngen_type_char, vngen_type_attach, vngen_type_emote,
	            vngen_type_textbox, vngen_type_text, vngen_type_label, vngen_type_prompt,
	            vngen_type_option, vngen_type_audio, vngen_type_vox, vngen_type_effect,
	            vngen_type_button, or vngen_type_speaker)
	argument2 = name of the parent character to check, if entity is an attachment (string) (optional, use no argument for none)
            
	Example usage:
	   if (vngen_exists("tb", 5)) {
	      //Do something
	   }
	*/

	//Initialize temporary variables for checking target entity
	var ds_data, ds_xindex, ds_yindex;

	//Get target character, if any
	if (argument_count > 2) {
	   var name = argument[2];
	} else {
	   var name = -1;
	}

	//Get data structure for target entity
	switch (argument[1]) {
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
	         //Check any speakers, if enabled
	         if (argument[0] == any) {
	            if (ds_grid_height(ds_text) > 0) {
	               return true;
	            }
	         } else {
	            //Check specific speaker   
	            for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_text); ds_yindex += 1) {
	               //If target speaker is active, return true
	               if (ds_text[# prop._name, ds_yindex] == argument[0]) {
	                  return true;
	               }
	            }
	         }
	      }
	   }   
   
	   //Check character attachments
	   if (ds_data == -vngen_type_attach) {
	      if (ds_exists(ds_character, ds_type_grid)) {
	         for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_character); ds_yindex += 1) {
	            //If target character exists (if any)...
	            if (ds_character[# prop._id, ds_yindex] == name) or (name == -1) {
	               //Get attachment data from characters
	               ds_data = ds_character[# prop._attach_data, ds_yindex];
            
	               //Check any attachments, if enabled
	               if (ds_exists(ds_data, ds_type_grid)) {
	                  if (argument[0] == any) {
	                     if (ds_grid_height(ds_data) > 0) {
	                        return true;
	                     }
	                  } else {
	                     //Check specific attachment
	                     for (ds_xindex = 0; ds_xindex < ds_grid_height(ds_data); ds_xindex += 1) {
	                        //If target attachment exists, return true
	                        if (ds_data[# prop._id, ds_xindex] == argument[0]) {
	                           return true;
	                        }               
	                     }
	                  }
	               }
	            }
	         }
	      }
	   }
   
	   //Check buttons
	   if (ds_data == -vngen_type_button) {
	      //Check log buttons
	      if (ds_exists(global.ds_log_button, ds_type_grid)) {
	         if (global.vg_log_visible == true) {
	            //Check any log buttons, if enabled
	            if (argument[0] == any) {
	               if (ds_grid_height(global.ds_log_button) > 0) {
	                  return true;
	               }
	            } else {      
	               //Check specific log button
	               for (ds_yindex = 0; ds_yindex < ds_grid_height(global.ds_log_button); ds_yindex += 1) {
	                  //If target button exists, return true
	                  if (global.ds_log_button[# prop._id, ds_yindex] == argument[0]) {
	                     return true;
	                  }
	               }
	            }
	         }
	      }
      
	      //Check other buttons
	      if (ds_exists(ds_button, ds_type_grid)) {
	         if (global.vg_log_visible == false) {
	            //Check any button, if enabled
	            if (argument[0] == any) {
	               if (ds_grid_height(ds_button) > 0) {
	                  return true;
	               }
	            } else {      
	               //Check specific button
	               for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_button); ds_yindex += 1) {
	                  //If target button exists, return true
	                  if (ds_button[# prop._id, ds_yindex] == argument[0]) {
	                     return true;
	                  }
	               }
	            }
	         }
	      }
	   }
   
	//Check other entities
	} else {
	   if (ds_exists(ds_data, ds_type_grid)) {
	      //Check any ID, if enabled
	      if (argument[0] == any) {
	         if (ds_grid_height(ds_data) > 0) {
	            return true;
	         }
	      } else {
	         //Check specific ID
	         for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_data); ds_yindex += 1) {
	            //If target entity exists, return true
	            if (ds_data[# prop._id, ds_yindex] == argument[0]) {
	               return true;
	            }
	         }
	      }
	   }
	}

	//If target entity is not found, return false
	return false;


}
