/// @function	vngen_get_speed(id);
/// @param		{real|string}	id
/// @param		{real}			speed
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_get_speed() {

	/*
	Returns the rate at which text increments for the specified text entity. It is 
	also possible to return the default speed of all text entities by supplying the 
	'all' keyword in place of an ID.

	This value is in characters per-second (CPS), and will automatically be adapted 
	to framerate and delta time. Speeds of 0 or less indicate no typewriter effect.

	argument0 = ID of the text entity to check speed (real or string) (or 'all' for all text entities)

	Example usage:
	   var cps = vngen_get_speed(all);
	   var cps = vngen_get_speed("text");
	*/

	//Initialize temporary variables for returning speed
	var text_id = all;

	//Get speed for specific entity if ID is supplied
	if (argument_count > 1) {
	   text_id = argument[0];
	}

	//Get speed for all text, if no ID is supplied
	if (text_id == all) {
	   return global.vg_speed_text;
	} else {
	   //Otherwise get speed for specific text entity
	   var ds_target = vngen_get_index(text_id, vngen_type_text);
	
	   if (!is_undefined(ds_target)) {
	      return ds_text[# prop._speed, ds_target];
	   }
	}


}
