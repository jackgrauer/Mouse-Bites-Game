/// @function	cmd_vngen_goto_unread([perform]);
/// @param		{boolean} [perform]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function cmd_vngen_goto_unread() {

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

	//Enable or disable performing skipped events, if specified
	var perform = true;
	if (argument_count > 0) {
	   if (argument[0] == "false") {
	      perform = false;
	   }
	}

	//Skip to first unread event
	vngen_goto_unread(perform);
                     
	//Return result dialog
	return "Jumped to first option or unread event";


}
