/// @function	vngen_is_log_displayed();
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_is_log_displayed() {

	/*
	Checks whether or not the VNgen backlog is visible and returns 'true' or 'false'.

	Example usage:
	   if (vngen_is_log_displayed()) {
	      virtual_key_hide(my_key);
	   } else {
	      virtual_key_show(my_key);
	   }
	*/

	//Return the current log display state
	return global.vg_log_visible;


}
