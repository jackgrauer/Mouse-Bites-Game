/// @function	vngen_is_ui_displayed();
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_is_ui_displayed() {

	/*
	Checks whether or not UI-level VNgen elements are visible (such as textboxes,
	text, buttons, and options) and returns 'true' or 'false'.

	Example usage:
	   if (vngen_is_ui_displayed()) {
	      virtual_key_show(my_key);
	   } else {
	      virtual_key_hide(my_key);
	   }
	*/

	//Return the current display state
	return global.vg_ui_visible;


}
