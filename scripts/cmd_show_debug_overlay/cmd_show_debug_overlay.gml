/// @function	cmd_show_debug_overlay(enable);
/// @param		{boolean} enable
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function cmd_show_debug_overlay() {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	A command script for use with the VNgen command console.

	Note that all arguments passed from the command console are passed as strings
	and must be converted to reals manually, if necessary.

	See sys_cmd_add to add commands to the console.
	*/

	//Check for correct input
	if (argument_count != 1) {
	   //Return argument error if input is malformed
	   return "Error: Wrong number of arguments (value must be true or false)";
	}

	//Set overlay visibility
	switch (argument[0]) {
	   //Show debug overlay
	   case "true": 
	      show_debug_overlay(true); 
      
	      //Return result dialog
	      return "GameMaker debug overlay is visible (*WARNING*: Active debug functions may impact reported performance!)";
	      break;
   
	   //Hide debug overlay
	   case "false": 
	      show_debug_overlay(false); 
      
	      //Return result dialog
	      return "GameMaker debug overlay is hidden";
	      break;
      
	   //Otherwise return input error
	   default: 
	      return "Error: Value must be true or false";
	}


}
