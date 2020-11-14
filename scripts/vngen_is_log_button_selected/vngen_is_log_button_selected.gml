/// @function	vngen_is_log_button_selected(id);
/// @param		{real|string}	id
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_is_log_button_selected(argument0) {

	/*
	Checks whether or not the specified button is selected and returns 'true' or 'false'.

	Note that this script is different from vngen_get_log_button in that only one ID can
	be checked at a time, and this function will return 'true' even while the button is
	held down, rather than only after release.

	argument0 = the button ID to check (real or string)

	Example usage:
	   if (vngen_is_log_button_selected("btn_scroll_up")) {
	      vngen_do_log_nav(-1);
	   }
	   if (vngen_is_log_button_selected("btn_scroll_dn")) {
	      vngen_do_log_nav(1);
	   }
	*/

	//Return button state
	return button_active == argument0;


}
