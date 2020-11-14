/// @function	vngen_is_option_hovered(id);
/// @param		{real|string}	id
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_is_option_hovered(argument0) {

	/*
	Checks whether or not the specified option is hovered and returns 'true' or 'false'.

	argument0 = the option ID to check (real or string)

	Example usage:
	   if (vngen_is_option_hovered("opt1")) {
	      draw_sprite(spr_glow, image_index, 
		              vngen_get_x("opt1", vngen_type_option), 
		              vngen_get_y("opt1", vngen_type_option));
	   }
	*/

	//Return option hover state
	return option_hover == argument0;


}
