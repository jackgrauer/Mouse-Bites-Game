/// @function	cmd_vngen_room_goto(room, [event, object], [perform]);
/// @param		{room}				room
/// @param		{integer|string}	[event
/// @param		{object}			object]
/// @param		{boolean}			[perform]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function cmd_vngen_room_goto() {

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
	if (argument_count < 1) or (argument_count > 4) {
	   //Return argument error if input is malformed
	   return "Error: Wrong number of arguments";
	}

	//Get input object event
	if (argument_count > 1) {
	   var ev = argument[1];
	   var ev_obj = asset_get_index(argument[2]);
	   var ev_perform = true;
   
	   //Skip if input object is invalid
	   if (ev_obj < 0) {
		  return "Error: Unrecognized object"; 
	   }
   
	   //Convert event to real, if necessary
	   if (string_length(string_digits(ev)) == string_length(ev)) {
		  ev = real(ev); 
	   }
	}

	//Get input event skip setting as boolean
	if (argument_count > 3) {
	   if (argument[3] == "false") {
		  ev_perform = false; 
	   }
	}

	//Go to room, if it exists
	if (room_exists(asset_get_index(argument[0]))) {
	   if (argument_count == 1) {
		  //Just go to room, if no object is specified
	      vngen_room_goto(asset_get_index(argument[0]));
   
	      //Return result dialog
	      return "Jumped to room";
	   } else {
		  //Otherwise go to room and jump to object event
		  vngen_room_goto(asset_get_index(argument[0]), ev, ev_obj, ev_perform);
   
	      //Return result dialog
	      return "Jumped to room and skipped to target event";
	   }
	} else {
	   //Otherwise return room error
	   return "Error: Unrecognized room";
	}


}
