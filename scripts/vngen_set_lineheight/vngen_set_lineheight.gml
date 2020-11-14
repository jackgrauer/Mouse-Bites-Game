/// @function	vngen_set_lineheight(id, type, multiplier);
/// @param		{real|string|const}	id
/// @param		{integer|macro}		type
/// @param		{real}				multiplier
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_set_lineheight() {

	/*
	VNgen uses a global lineheight multiplier to calculate the vertical space 
	between lines of text (relative to the height of the current font, in 
	pixels). This script changes the lineheight multiplier for all forms of
	text drawn by VNgen, where a value of 1 equals no extra separation between 
	lines.

	argument0 = the ID of the VNgen entity to change lineheight (real or string) (or use keyword 'all' for global)
	argument1 = the VNgen entity type the ID belongs to (integer or macro)
	argument2 = sets the lineheight, as a multiplier of font size (real)

	Example usage:
	   vngen_set_lineheight(all, vngen_type_text, 1.5);
	   vngen_set_lineheight("label_name", vngen_type_label, 2);
	*/

	//Initialize temporary variables for checking target entity
	var ds_data, ds_yindex;
	var ds_target = undefined;
	var ds_type = clamp(argument[1], vngen_type_text, vngen_type_label);

	//Get data structure for target entity
	switch (ds_type) {
	   case vngen_type_label: ds_data = ds_label; break;
	   default: ds_data = ds_text;
	}

	//Get entity slot, if supplied
	if (argument[0] != all) {
	   ds_target = vngen_get_index(argument[0], ds_type);

	   //If the target entity exists...
	   if (!is_undefined(ds_target)) { 
	      //Set lineheight multiplier
	      if (ds_data[# prop._txt_line_height, ds_target] != argument[2]) {
	         ds_data[# prop._txt_line_height, ds_target] = argument[2];
         
			 //Regenerate surface to match new lineheight
			 if (surface_exists(ds_data[# prop._surf, ds_target])) {
				 surface_free(ds_data[# prop._surf, ds_target]);
				 ds_data[# prop._surf, ds_target] = -1;
			 }
         
	         //Update text in backlog if created in the current event
	         if (ds_data == ds_text) {
	            if (!sys_event_skip()) {
	               vngen_log_add(auto, none, ds_text[# prop._name, ds_target], ds_text[# prop._txt_fnt, ds_target], ds_text[# prop._col1, ds_target], ds_text[# prop._col2, ds_target], ds_text[# prop._col3, ds_target], ds_text[# prop._col4, ds_target], ds_text[# prop._txt_shadow, ds_target], ds_text[# prop._txt_outline, ds_target], ds_text[# prop._txt_halign, ds_target], ds_text[# prop._txt_line_height, ds_target]);
	            }         
	         }
	      }
	   }
	} else {
	   //Otherwise set lineheight multiplier for all entities of the given type
	   if (ds_data == ds_label) {
	      //Labels
	      global.vg_lineheight_label = argument[2];
	   } else {
	      //Text
	      global.vg_lineheight_text = argument[2];
	   }
   
	   //Apply lineheight multiplier to existing entities
	   if (ds_exists(ds_data, ds_type_grid)) {
	      for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_data); ds_yindex += 1) {
	         //Set lineheight multiplier
	         if (ds_data[# prop._txt_line_height, ds_yindex] != argument[2]) {
	            ds_data[# prop._txt_line_height, ds_yindex] = argument[2];
			
				//Regenerate surface to match new lineheight
				if (surface_exists(ds_data[# prop._surf, ds_yindex])) {
					surface_free(ds_data[# prop._surf, ds_yindex]);
					ds_data[# prop._surf, ds_yindex] = -1;
				}
         
	            //Update text in backlog if created in the current event
	            if (ds_data == ds_text) {
	               if (!sys_event_skip()) {
	                  sys_queue_enqueue("log", vngen_log_get_index(previous) + 1, none, ds_text[# prop._name, ds_yindex], ds_text[# prop._txt_fnt, ds_yindex], ds_text[# prop._col1, ds_yindex], ds_text[# prop._col2, ds_yindex], ds_text[# prop._col3, ds_yindex], ds_text[# prop._col4, ds_yindex], ds_text[# prop._txt_shadow, ds_yindex], ds_text[# prop._txt_outline, ds_yindex], ds_text[# prop._txt_halign, ds_yindex], ds_text[# prop._txt_line_height, ds_yindex]);
	               }   
	            }
	         }
	      }
	   }   
	}


}
