/// @function	vngen_is_option_selected(id);
/// @param		{real|string}	id
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_is_option_selected(argument0) {

	/*
	Checks whether or not the specified option is selected and returns 'true' or 'false'.

	Note that this script is different from vngen_get_option in that only one ID can
	be checked at a time, and this function will return 'true' even while the option is
	held down, rather than only after release.

	argument0 = the option ID to check (real or string)

	Example usage:
	   if (vngen_is_option_selected("opt1")) {
	      draw_sprite(spr_glow, image_index, 
		              vngen_get_x("opt1", vngen_type_option), 
		              vngen_get_y("opt1", vngen_type_option));
	   }
	*/

	//Return option state
	return option_active == argument0;


}
