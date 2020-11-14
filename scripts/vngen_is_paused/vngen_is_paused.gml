/// @function	vngen_is_paused();
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_is_paused() {

	/*
	Checks whether or not VNgen elements are paused and returns 'true' or 'false'.

	Example usage:
	   if (vngen_is_paused()) {
	      draw_text(960, 540, "PAUSED");
	   }
	*/

	//Return the current pause state
	if (sys_event_skip()) {
	   //Use temp pause state if event skip is active
	   return global.vg_event_skip_pause;
	} else {
	   //Otherwise use primary pause state
	   return global.vg_pause;
	}


}
