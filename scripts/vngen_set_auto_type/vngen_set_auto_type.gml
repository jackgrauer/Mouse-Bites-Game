/// @function	vngen_set_auto_type(type);
/// @param		{integer}	type
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_set_auto_type(argument0) {

	/*
	Since version 1.0.8, VNgen will treat indefinite pause values in events and text 
	(e.g. [pause=-1]) as literal durations if auto mode is enabled. This script can
	be used to revert back to the old behavior.

	This script supports two types of auto mode:
		0, to use indefinite pause values as a duration if auto mode is enabled (default)
		1, to respect indefinite pauses, requiring a click even if auto mode is enabled

	argument0 = sets the behavior for indefinite pauses in auto mode (integer) (0-1)

	Example usage:
	   vngen_set_auto_type(1);
	*/

	//Set auto indefinite pause type
	global.vg_text_auto_pause_indefinite = clamp(argument0, 0, 1);


}
