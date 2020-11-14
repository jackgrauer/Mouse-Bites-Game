/// @function	vngen_is_button_hovered(id);
/// @param		{real|string}	id
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_is_button_hovered(argument0) {

	/*
	Checks whether or not the specified button is hovered and returns 'true' or 'false'.

	argument0 = the button ID to check (real or string)

	Example usage:
	   if (vngen_is_button_hovered("btn_fast_forward")) {
	      draw_sprite(spr_glow, image_index, 
		              vngen_get_x("btn_fast_forward", vngen_type_button), 
		              vngen_get_y("btn_fast_forward", vngen_type_button));
	   }
	*/

	//Return button hover state
	return button_hover == argument0;


}
