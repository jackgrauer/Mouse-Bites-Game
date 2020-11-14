/// @function	cmd_help();
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function cmd_help() {

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

	//Display console commands using external help file, if it exists
	if (file_exists(working_directory + "XGASOFT\\VNgen\\help.html")) and (os_browser == browser_not_a_browser) {
	   url_open("file:" + working_directory + "XGASOFT\\VNgen\\help.html");
   
	   //Return result dialog
	   return "Opened help file in default browser";
	} else {
	   //Otherwise, if help file does not exist, use internal dialog instead
	   return cmd_localhelp();
	}


}
