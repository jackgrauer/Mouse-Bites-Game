/// @function	vngen_is_auto();
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_is_auto() {

	/*
	Checks whether or not automatic VNgen progression is enabled 
	and returns 'true' or 'false'.

	Example usage:
	   if (vngen_is_auto()) {
	      draw_text(32, 24, "AUTO");
	   }
	*/

	//Return the current auto state
	return global.vg_text_auto;


}
