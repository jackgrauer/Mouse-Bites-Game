/// @function	cmd_vngen_file_delete(filename);
/// @param		{string}	filename
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function cmd_vngen_file_delete() {

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

	//Delete file, if it exists
	if (vngen_file_delete(argument[0])) {
	   //Return result dialog
	   return "File successfully deleted";
	} else {
	   //Otherwise return file error
	   return "Error: Delete failed or file not found";
	}


}
