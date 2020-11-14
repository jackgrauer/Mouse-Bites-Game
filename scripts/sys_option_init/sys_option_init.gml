/// @function	sys_option_init();
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_option_init() {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Automatically run by option scripts. Assigns an ID to the running option and
	tests whether the option should be performed, returning true or false based
	on the result

	No parameters

	Example usage:
	   if (!sys_option_init()) {
	      exit;
	   }
	*/

	//Get option ID
	option_id += 1;

	//Do not initialize option if block is inactive
	if (option_exit == true) {
	   return false;
	}

	//Enable option initialization, if active
	if (option_current == option_id) {   
	   //Continue to next option once initialized
	   option_current += 1;
   
	   //Enable option initialization
	   return true;
	}

	//Otherwise, neither initialize nor exit option
	return -1;


}
