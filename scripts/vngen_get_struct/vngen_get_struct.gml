/// @function	vngen_get_struct(id, type, [name]);
/// @param		{real|string}	id
/// @param		{integer|macro}	type
/// @param		{string}		[name]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_get_struct() {

	/*
	Returns the numerical data structure index of the specified entity of the given ID 
	and type, or 'undefined' if the entity or type does not exist.

	Note that indices are not entirely unique and can be shared by data structures of 
	different types, but not by structures of the same type.

	argument0 = ID of the entity to check (real or string)
	argument1 = sets the entity type to check (integer) (or use vngen_type_perspective,
	            vngen_type_scene, vngen_type_char, vngen_type_attach, vngen_type_emote,
	            vngen_type_textbox, vngen_type_text, vngen_type_label, vngen_type_prompt,
	            vngen_type_option, vngen_type_audio, vngen_type_vox, vngen_type_effect,
	            or vngen_type_button)
	argument2 = name of the parent character to check, if entity is an attachment (string) (optional, use no argument for none)
            
	Example usage:
	   var ds_index = vngen_get_struct("tb", 5);
	*/

	//Initialize temporary variables for checking target entity
	var ds_data, ds_xindex, ds_yindex;

	//Get target character, if any
	if (argument_count > 2) {
	   var name = argument[2];
	} else {
	   var name = -1;
	}

	//Use previous entity, if same as current entity
	if (global.ds_ptype == argument[1]) {
	   if (ds_exists(global.ds_pdata, ds_type_grid)) {
	      //Use sub-entity if type is attachment
	      if (global.ds_ptype == vngen_type_attach) {
	         if (ds_character[# prop._id, global.ds_pyindex] == name) or (name == -1) {
	            if (global.ds_pdata[# prop._id, global.ds_pxindex] == argument[0]) {
	               //Return target value
	               return global.ds_pdata;
	            }
	         }
	      } else {
	         //Otherwise use standard entity
	         if (global.ds_pdata[# prop._id, global.ds_pyindex] == argument[0]) {
	            //Return target value
	            return global.ds_pdata;
			 }
	      }
	   }
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
	   default: return undefined;
	}

	//Check special entities
	if (ds_data < 0) {
	   //Check character attachments
	   if (ds_data == -vngen_type_attach) {
	      if (ds_exists(ds_character, ds_type_grid)) {
	         for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_character); ds_yindex += 1) {
	            //If target character exists (if any)...
	            if (ds_character[# prop._id, ds_yindex] == name) or (name == -1) {
	               //Get attachment data from characters
	               ds_data = ds_character[# prop._attach_data, ds_yindex];
            
	               //Check attachments
	               if (ds_exists(ds_data, ds_type_grid)) {
	                  for (ds_xindex = 0; ds_xindex < ds_grid_height(ds_data); ds_xindex += 1) {
	                     //If target attachment exists, return structure
	                     if (ds_data[# prop._id, ds_xindex] == argument[0]) {
				            //Record target entity
				            global.ds_pdata = ds_data;
				            global.ds_ptype = argument[1];
				            global.ds_pxindex = ds_xindex;
							global.ds_pyindex = ds_yindex;
			   
				            //Return target value
	                        return ds_data;
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
	         for (ds_yindex = 0; ds_yindex < ds_grid_height(global.ds_log_button); ds_yindex += 1) {
	            //If target button exists, return structure
	            if (global.ds_log_button[# prop._id, ds_yindex] == argument[0]) {
				   //Record target entity
				   global.ds_pdata = global.ds_log_button;
				   global.ds_ptype = argument[1];
				   global.ds_pyindex = ds_yindex;
			   
				   //Return target value
	               return global.ds_log_button;
	            }
	         }
	      }
      
	      //Check other buttons
	      if (ds_exists(ds_button, ds_type_grid)) {
	         for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_button); ds_yindex += 1) {
	            //If target button exists, return structure
	            if (ds_button[# prop._id, ds_yindex] == argument[0]) {
				   //Record target entity
				   global.ds_pdata = ds_button;
				   global.ds_ptype = argument[1];
				   global.ds_pyindex = ds_yindex;
			   
				   //Return target value
	               return ds_button;
	            }
	         }
	      }
	   }
   
	//Check other entities
	} else {
	   if (ds_exists(ds_data, ds_type_grid)) {
	      //Check target data structure for input ID
	      for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_data); ds_yindex += 1) {
	         //If target entity exists, return structure
	         if (ds_data[# prop._id, ds_yindex] == argument[0]) {
				//Record target entity
				global.ds_pdata = ds_data;
				global.ds_ptype = argument[1];
				global.ds_pyindex = ds_yindex;
			
				//Return target structure
	            return ds_data;
	         }
	      }
	   }
	}

	//If target entity is not found, return undefined
	return undefined;


}
