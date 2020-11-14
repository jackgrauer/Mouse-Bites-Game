/// @function	cmd_window_set_fullscreen(full);
/// @param		{boolean} full
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function cmd_window_set_fullscreen() {

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

	//Set window mode
	switch (argument[0]) {
	   //Fullscreen
	   case "true": 
	      window_set_fullscreen(true); 
      
	      //Return result dialog
	      return "Set window mode to fullscreen";
	      break;
   
	   //Windowed
	   case "false": 
	      window_set_fullscreen(false); 
      
	      //Return result dialog
	      return "Set window mode to windowed";
	      break;
      
	   //Otherwise return input error
	   default: 
	      return "Error: Value must be true or false";
	}


}
