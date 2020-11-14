/// @function	cmd_vngen_goto(event, [object], [perform]);
/// @param		{integer|string}	event
/// @param		{object}			[object]
/// @param		{boolean}			[perform]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function cmd_vngen_goto() {

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
	if (argument_count == 0) or (argument_count > 3) {
	   //Return argument error if input is malformed
	   return "Error: Wrong number of arguments";
	}

	//Get event type
	if (string_letters(argument[0]) == "") {
	   //Event ID
	   var event = real(argument[0]);
	} else {
	   //Event label
	   var event = argument[0];
	}

	//Go to object event, if specified
	if (argument_count > 1) {
	   //Use current object if 'self' keyword is supplied
	   if (argument[1] == "self") {
	      var object = object_index;
	   } else {
	      //Otherwise use supplied object
	      var object = asset_get_index(argument[1]);
	   }
   
	   //Enable or disable performing skipped events
	   var perform = true;
	   if (argument_count > 2) {
	      if (argument[2] == "false") {
	         var perform = false;
	      }
	   }
   
	   //If target object exists...
	   if (object_exists(object)) {
	      //Go to object
	      vngen_goto(event, object, perform);
                     
	      //Return result dialog
	      return "Jumped to object event";
	   } else {
	      //Otherwise return object error
	      return "Error: Unrecognized object";
	   }
	} else {
	   //Otherwise go to event in the current object
	   vngen_goto(event);
                     
	   //Return result dialog
	   return "Jumped to local event";
	}


}
