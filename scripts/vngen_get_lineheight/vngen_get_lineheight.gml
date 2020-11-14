/// @function	vngen_get_lineheight(id, type);
/// @param		{real|string|const}	id
/// @param		{integer|macro}		type
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_get_lineheight() {

	/*
	VNgen uses a global lineheight multiplier to calculate the vertical space 
	between lines of text (relative to the height of the current font, in 
	pixels). This script returns the lineheight multiplier for all forms of
	text drawn by VNgen, where a value of 1 equals no extra separation between 
	lines.

	argument0 = the ID of the VNgen entity to get lineheight (real or string) (or use keyword 'all' for global)
	argument1 = the VNgen entity type the ID belongs to (integer or macro)

	Example usage:
	   var lineheight = vngen_get_lineheight(all, vngen_type_text);
	   var lineheight = vngen_get_lineheight("label_name", vngen_type_label);
	*/

	//Initialize temporary variables for checking target entity
	var ds_data;
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
	      //Get lineheight multiplier
		  return ds_data[# prop._txt_line_height, ds_target];
	   }
	} else {
	   //Otherwise get lineheight multiplier for all entities of the given type
	   if (ds_data == ds_label) {
	      //Labels
	      return global.vg_lineheight_label;
	   } else {
	      //Text
	      return global.vg_lineheight_text;
	   }  
	}


}
