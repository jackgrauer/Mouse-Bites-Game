/// @function	sys_event_skip([index]);
/// @param		{integer}	[index]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_event_skip() {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Automatically run by event/action scripts. Checks whether event skipping is currently 
	enabled and returns the result, or if a numeric value is supplied, enables or disables 
	skipping to the target event.

	argument0 = sets the numeric event ID to skip to (integer) (optional, use no argument for no change)

	Example usage:
	   sys_event_skip(5);
   
	   if (sys_event_skip()) {
	      sys_action_term();
	   }
	*/

	//Set event skip mode, if supplied
	if (argument_count > 0) {
	   event_skip = argument[0];
   
	   //If event skipping is disabled...
	   if (event_skip < 0) {
	      //... re-enable performing skipped events
	      event_skip_perform = true;
	   }
	   exit;
	}

	//Otherwise return the current event skip state
	return clamp(event_skip + 1, false, true);


}
