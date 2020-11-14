/// @function	sys_action_skip([enable]);
/// @param		{boolean} [enable]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_action_skip() {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Automatically run by event/action scripts. Checks whether action skipping is currently
	enabled and returns the result, or if a boolean value is supplied, enables or disables 
	skipping actions in the current event.

	argument0 = enable or disable action skip (integer) (optional, use no argument for no change)

	Example usage:
	   sys_action_skip(true);
   
	   if (sys_action_skip()) {
	      sys_action_term();
	   }
	*/

	//Set action skip mode, if supplied
	if (argument_count > 0) {
	   action_skip = clamp(argument[0], false, true);
	   exit;
	}

	//Otherwise return the current action skip state
	return action_skip;


}
