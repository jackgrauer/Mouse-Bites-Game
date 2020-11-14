/// @function	cmd_vngen_set_scale(view);
/// @param		{integer}	view
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function cmd_vngen_set_scale() {

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
	   return "Error: Wrong number of arguments";
	}

	//Get view to scale
	var view = argument[0];

	//Use keyword for disable
	if (argument[0] == "none") {
	   view = none;
	} else {
	   //Otherwise use index value
	   view = real(view);
	}

	//Check for correct input
	if (view < none) or (view > 7) {
	   //Return input error if invalid view is specified
	   return "Error: invalid view. Input view must be 0-7, or keyword 'none' to disable scaling."
	}

	//Set view to scale
	vngen_set_scale(view);

	//Return result dialog
	if (view >= 0) {
	   return "Enabled scaling for View " + string(view);
	} else {
	   return "View scaling disabled";
	}


}
