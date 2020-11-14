/// @function	cmd_vngen_file_save(filename, [encrypt]);
/// @param		{string}	filename
/// @param		{boolean}	[encrypt]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function cmd_vngen_file_save() {

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
	if (argument_count == 0) or (argument_count > 2) {
	   //Return argument error if input is malformed
	   return "Error: Wrong number of arguments";
	}

	//Enable encryption by default
	var encrypt = true;

	//Get encryption setting, if any
	if (argument_count > 1) {
	   if (argument[1] == "false") {
	      encrypt = false;
	   }
	}

	//Save file and get status
	var save = vngen_file_save(argument[0], encrypt);

	//Return result dialog
	if (save == true) {
	   if (encrypt == true) {
	      return "Wrote encrypted file to storage";
	   } else {
	      return "Wrote unencrypted file to storage";
	   }
	} else {
	   return "Error: File could not be written.";
	}


}
