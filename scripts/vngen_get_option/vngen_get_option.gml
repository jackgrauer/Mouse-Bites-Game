/// @function	vngen_get_option([id], [clear]);
/// @param		{real|string}	[id]
/// @param		{boolean}		[clear]
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_get_option() {

	/*
	Returns the ID of the most recently-selected option. If no such selection exists,
	-1 will be returned instead. If the ID for a previous option block is supplied, 
	the ID of the individual option selected in that instance will be returned instead.

	This script can also clear the most recent option result to prevent code from being 
	executed multiple times. Clearing is enabled by default.

	If only one argument is supplied, reals will be treated as 'clear' and strings will
	be treated as an option block ID.

	By using this script in "if" or "switch" statements after an option code block,
	virtually any action can be triggered by an on-screen menu.

	argument0 = the ID of the option block to return result from (real or string) (optional, use no argument for most recent)
	argument1 = enables or disables clearing option results to prevent re-execution (boolean) (true/false) (optional, use no argument for true)

	Example usage:
	   if (vngen_get_option() == "op1") {
	      //Action
	   }
   
	   switch (vngen_get_option("my_options")) {
	      case "op2": //Action; break;
	      case "op3": //Action; break;
	   }
	*/

	//Initialize temporary variables for checking option
	var option_choice = -1;
	var option_src = 0;
	if (argument_count > 0) {
	   option_src = is_string(argument[0]);
	}

	//Return null if event skip is active
	if (sys_event_skip()) {
	   return option_choice;
	}

	//Return null if options are active
	if (option_count > 0) or (option_exit == true) or (option_pause > 0) {
	    return option_choice;
	}

	//Get option to return
	if (argument_count == 2) or (option_src == 1) {
	   //Get previous option, if any
	   if (ds_exists(global.ds_option_result, ds_type_map)) {
	      if (ds_map_exists(global.ds_option_result, argument[0])) {
	         option_choice = global.ds_option_result[? argument[0]];
		 
			 //If option is undefined, return null
			 if (is_undefined(option_choice)) {
			    option_choice = -1;
		     }
	      }
	   }
	} else {
	   //Otherwise get the most recent option
	   option_choice = option_result;
	}

	//Get clear mode
	var option_clear = true;
	if (argument_count > 0) {
	   if (argument_count == 2) or (option_src == 0) {
	      if (argument[argument_count - 1] == false) {
	         option_clear = false;
	      }
	   }
	}

	//Clear most recent option results, if enabled
	if (option_clear == true) {
	   option_result = -1;
	}

	//Return option results
	return option_choice;


}
