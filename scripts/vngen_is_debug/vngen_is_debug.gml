/// @function	vngen_is_debug();
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_is_debug() {

	/*
	Checks whether or not VNgen's debug mode is enabled and returns 'true' or 'false'.

	Example usage:
	   if (vngen_is_debug()) {
	      keyboard_virtual_show(kbv_type_default, kbv_returnkey_default, kbv_autocapitalize_none, false);
	   }
	*/

	//Return the current display state
	return global.vg_debug;


}
