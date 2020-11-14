/// @function	vngen_code_execute_ext();
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_code_execute_ext() {

	/*
	Executes arbitrary code as a VNgen action. While it may seem identical to the standard
	vngen_code_execute, vngen_code_execute_ext executes code with one critical difference:
	code will also be executed during vngen_goto operations to reconstruct the target event.
	To execute code which should not be repeated, use vngen_code_execute instead.

	Note that executed code is limited to the object event where VNgen actions are run (usually Step).

	Example usage:
	   vngen_event() {
	      if (vngen_code_execute_ext()) {
		     my_var += 1;
		  }
	   }
	*/

	/*
	INITIALIZATION
	*/

	//Enable action, if active
	switch (sys_action_init()) {
	   //Exit if event is inactive
	   case false: {
	      break;
	   }
      
	   //Initialize action if active
	   case true: {
	      //Continue to next action once complete
	      sys_action_term();
	  
		  //Perform code
		  return true;
	   }
	}

	//Otherwise do not perform code
	return false;


}
