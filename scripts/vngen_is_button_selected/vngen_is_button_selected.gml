/// @function	vngen_is_button_selected(id);
/// @param		{real|string}	id
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_is_button_selected(argument0) {

	/*
	Checks whether or not the specified button is selected and returns 'true' or 'false'.

	Note that this script is different from vngen_get_button in that only one ID can
	be checked at a time, and this function will return 'true' even while the button is
	held down, rather than only after release.

	argument0 = the button ID to check (real or string)

	Example usage:
	   if (vngen_is_button_selected("btn_fast_forward")) {
	      vngen_do_continue();
	   }
	*/

	//Return button state
	return button_active == argument0;


}
