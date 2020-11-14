/// @function	sys_action_term();
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_action_term() {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Automatically run by action scripts. Terminates the running action so that
	it is considered complete and will no longer be performed.

	No parameters

	Example usage:
	   sys_action_term();
	*/

	//Mark the running action as complete
	action_complete += 1;


}
