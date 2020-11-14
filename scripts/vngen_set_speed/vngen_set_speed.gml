/// @function	vngen_set_speed([id], speed);
/// @param		{real|string}	[id]
/// @param		{real}			speed
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_set_speed() {

	/*
	Sets the rate at which text increments for the specified text entity. It is
	also possible to set the default speed of all text entities by supplying the
	'all' keyword in place of an ID.

	This value is in characters per-second (CPS), and will automatically be adapted 
	to framerate and delta time. Speeds of 0 or less will disable the typewriter
	effect.

	Speed is set to 25 by default.

	Note that while speed can be modified by adding [speed] markup directly within 
	text, this value acts as a multiplier of the global speed rather than an explicit 
	CPS value as set by this script.

	argument0 = ID of the text entity to apply speed to (real or string) (or 'all' for all text entities)
	argument1 = sets the speed at which VNgen text increments, in characters per-second (real) (or 0 for instant)

	Example usage:
	   vngen_set_speed(all, 30);
	   vngen_set_speed("text", 25);
	*/

	//Initialize temporary variables for applying speed
	var text_id = all;
	var text_speed = argument[0];

	//Set speed for specific entity if ID is supplied
	if (argument_count > 1) {
	   text_id = argument[0];
	   text_speed = argument[1];
	}

	//Set speed for all text, if no ID is supplied
	if (text_id == all) {
	   global.vg_speed_text = text_speed;
	} else {
	   //Otherwise set speed for specific text entity
	   var ds_target = vngen_get_index(text_id, vngen_type_text);
	
	   if (!is_undefined(ds_target)) {
	      ds_text[# prop._speed, ds_target] = text_speed;
	   }
	}


}
