/// @function	vngen_get_halign(id, type);
/// @param		{real|string}	id
/// @param		{integer|macro}	type
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_get_halign() {

	/*
	Returns the horizontal alignment of the specified text or label entity. It is 
	also possible to return the default alignment of all entities of either type
	by supplying the 'all' keyword in place of an ID.

	argument0 = ID of the entity to set alignment (real or string) (or 'all' for all text entities)
	argument1 = sets whether to get alignment for text or labels (integer/macro)

	Example usage:
	   var halign = vngen_get_halign("text", vngen_type_text);
	   var halign = vngen_get_halign(all, vngen_type_label);
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
	      //Get alignment
		  return ds_data[# prop._txt_halign, ds_target];
	   }
	} else {
	   //Otherwise get alignment for all entities of the given type
	   if (ds_data == ds_label) {
	      //Labels
	      return global.vg_halign_label;
	   } else {
	      //Text
	      return global.vg_halign_text;
	   }  
	}


}
