/// @function	vngen_set_halign(id, type, halign);
/// @param		{real|string}	id
/// @param		{integer|macro}	type
/// @param		{constant}		halign
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_set_halign() {

	/*
	Sets the horizontal alignment of the specified text or label entity. It is 
	also possible to permanently set alignment of all entities of either type
	by supplying the 'all' keyword in place of an ID. In this case, alignment 
	will also apply to new entities created in the future.

	argument0 = ID of the entity to set alignment (real or string) (or 'all' for all text entities)
	argument1 = sets whether to get alignment for text or labels (integer/macro)
	argument2 = sets font alignment to either fa_left (default), fa_center, or fa_right (constant)

	Example usage:
	   vngen_set_halign("text", 6, fa_center);
	   vngen_set_halign(all, 7, fa_left);
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
	      //Set alignment
	      if (ds_data[# prop._txt_halign, ds_target] != argument[2]) {
	         ds_data[# prop._txt_halign, ds_target] = argument[2];
         
	         //Enable redrawing with new alignment
	         ds_data[# prop._redraw, ds_target] = ds_data[# prop._index, ds_target];
         
	         //Update text in backlog if created in the current event
	         if (ds_data == ds_text) {
	            if (!sys_event_skip()) {
	               vngen_log_add(auto, none, ds_text[# prop._name, ds_target], ds_text[# prop._txt_fnt, ds_target], ds_text[# prop._col1, ds_target], ds_text[# prop._col2, ds_target], ds_text[# prop._col3, ds_target], ds_text[# prop._col4, ds_target], ds_text[# prop._txt_shadow, ds_target], ds_text[# prop._txt_outline, ds_target], ds_text[# prop._txt_halign, ds_target], ds_text[# prop._txt_line_height, ds_target]);
	            }         
	         }
	      }
	   }
	} else {
	   //Otherwise set alignment for all entities of the given type
	   if (ds_data == ds_label) {
	      //Labels
	      global.vg_halign_label = argument[2];
	   } else {
	      //Text
	      global.vg_halign_text = argument[2];
	   }
   
	   //Apply alignment to existing entities
	   if (ds_exists(ds_data, ds_type_grid)) {
	      for (ds_yindex = 0; ds_yindex < ds_grid_height(ds_data); ds_yindex += 1) {
	         //Set alignment
	         if (ds_data[# prop._txt_halign, ds_target] != argument[2]) {
	            ds_data[# prop._txt_halign, ds_yindex] = argument[2];
            
	            //Enable redrawing with new alignment
	            ds_data[# prop._redraw, ds_yindex] = ds_data[# prop._index, ds_yindex];
         
	            //Update text in backlog if created in the current event
	            if (ds_data == ds_text) {
	               if (!sys_event_skip()) {
	                  sys_queue_enqueue("log", vngen_log_get_index(previous) + 1, none, ds_text[# prop._name, ds_target], ds_text[# prop._txt_fnt, ds_target], ds_text[# prop._col1, ds_target], ds_text[# prop._col2, ds_target], ds_text[# prop._col3, ds_target], ds_text[# prop._col4, ds_target], ds_text[# prop._txt_shadow, ds_target], ds_text[# prop._txt_outline, ds_target], ds_text[# prop._txt_halign, ds_target], ds_text[# prop._txt_line_height, ds_target]);
	               }   
	            }
	         }
	      }
	   }   
	}


}
