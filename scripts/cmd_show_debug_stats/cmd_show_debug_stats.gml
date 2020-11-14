/// @function	cmd_show_debug_stats([enable]);
/// @param		{boolean} [enable]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function cmd_show_debug_stats() {

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
	if (argument_count > 1) {
	   //Return argument error if input is malformed
	   return "Error: Wrong number of arguments";
	}

	//Set stats visibility directly, if specified
	if (argument_count > 0) {
	   switch (argument[0]) {
	      //Show debug stats
	      case "true": global.vg_debug_stats = true; break;
         
	      //Hide debug stats
	      case "false": global.vg_debug_stats = false; break;
         
	      //Otherwise return input error
	      default: return "Error: Value must be true or false";
	   }
	} else {
	   //Otherwise toggle visibility
	   switch (global.vg_debug_stats) {
	      case true: global.vg_debug_stats = false; break;
	      case false: global.vg_debug_stats = true; break;
	   }
	}
   
	//Return result dialog
	if (global.vg_debug_stats == true) {
	   return "VNgen debug stats are visible";
	} else {
	   return "VNgen debug stats are hidden";
	}


}
