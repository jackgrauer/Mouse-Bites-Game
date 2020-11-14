/// @function	vngen_code_execute();
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_code_execute() {

	/*
	Executes arbitrary code as a VNgen action. Code is only executed once, and will not be
	executed while skipping events with vngen_goto to reconstruct the target event. This protects
	code from being executed multiple times. To execute code critical to the reconstruction of
	skipped events, use vngen_code_execute_ext instead.

	Note that executed code is limited to the object event where VNgen actions are run (usually Step).

	Example usage:
	   vngen_event() {
	      if (vngen_code_execute()) {
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
	      //Skip action if event skip is active
	      if (sys_event_skip()) {
	         sys_action_term();  
	         exit;
	      }
      
	      //Continue to next action once complete
	      sys_action_term();
	  
		  //Perform code
		  return true;
	   }
	}

	//Otherwise do not perform code
	return false;


}
