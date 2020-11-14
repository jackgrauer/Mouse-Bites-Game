/// @function	sys_action_init();
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_action_init() {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Automatically run by action scripts. Assigns an ID to the running action and
	tests whether the action should be performed, returning true or false based
	on the result

	No parameters

	Example usage:
	   if (!sys_action_init()) {
	      exit;
	   }
	*/
   
	//Skip action if performing skipped events is disabled
	if (event_skip_perform == false) {
	   if (action_count == 0) {
	      return false;
	   }
	}   

	//Get action ID
	action_id += 1;

	//Do not initialize action if event is inactive
	if (event_exit == true) {
	   return false;
	}

	//Enable action initialization, if active
	if (action_current == action_id) {   
	   //Continue to next action once initialized
	   action_current += 1;
   
	   //Enable action initialization
	   return true;
	}

	//Otherwise, neither initialize nor exit action
	return -1;


}
