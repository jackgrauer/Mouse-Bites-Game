/// @function	sys_read_skip([enable]);
/// @param		{boolean}	[enable]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_read_skip() {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Automatically run by event/action scripts. Checks whether read skipping is currently 
	enabled and returns the result, or if a boolean value is supplied, enables or disables 
	skipping to the first unread event.

	argument0 = enables or disables read event skipping (integer) (optional, use no argument for no change)

	Example usage:
	   sys_read_skip(true);
   
	   if (sys_read_skip()) {
	      sys_action_skip(true);
	   }
	*/

	//Set read skip mode, if supplied
	if (argument_count > 0) {
	   global.vg_event_skip_read = argument[0];
	   exit;
	}

	//Otherwise return the current read skip state
	return global.vg_event_skip_read;


}
